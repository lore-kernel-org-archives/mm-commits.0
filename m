From: akpm@linux-foundation.org
Subject: [merged] ummunotify-userspace-support-for-mmu-notifications-v3.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:29:06 -0700
Message-ID: <200908101929.n7AJT6sd028832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbZHJT3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rolandd@cisco.com, jgunthorpe@obsidianresearch.com, jsquyres@cisco.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     ummunotify: Userspace support for MMU notifications (v3)
has been removed from the -mm tree.  Its filename was
     ummunotify-userspace-support-for-mmu-notifications-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ummunotify: Userspace support for MMU notifications (v3)
From: Roland Dreier <rolandd@cisco.com>

Changes since v2:
 - Added Documentation/ummunotify/ with a text file and a test program
   (hooked up to CONFIG_BUILD_DOCSRC, fixed things like hooking up
   ummunotify.h to headers_install)
 - Integrated Andrew's checkpatch fixes (no more > 80 char lines in
   kernel source; userspace test code has some long lines due to not
   wanting to split printf formats)
 - Clean up "if (test_bit) { clear_bit } else { set_bit }" -- code was
   actually buggy since we don't want to reset the bit after we cleared
   it (ie 3 events in a row)

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jeff Squyres <jsquyres@cisco.com> 
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Makefile                  |    3 
 Documentation/ummunotify/Makefile       |    7 
 Documentation/ummunotify/ummunotify.txt |  150 ++++++++++++++++
 Documentation/ummunotify/umn-test.c     |  200 ++++++++++++++++++++++
 drivers/char/ummunotify.c               |   54 +++--
 include/linux/ummunotify.h              |   10 -
 6 files changed, 397 insertions(+), 27 deletions(-)

diff -puN Documentation/Makefile~ummunotify-userspace-support-for-mmu-notifications-v3 Documentation/Makefile
--- a/Documentation/Makefile~ummunotify-userspace-support-for-mmu-notifications-v3
+++ a/Documentation/Makefile
@@ -1,3 +1,4 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
 	filesystems/configfs/ ia64/ networking/ \
-	pcmcia/ spi/ video4linux/ vm/ watchdog/src/
+	pcmcia/ spi/ video4linux/ vm/ ummunotify/ \
+	watchdog/src/
diff -puN /dev/null Documentation/ummunotify/Makefile
--- /dev/null
+++ a/Documentation/ummunotify/Makefile
@@ -0,0 +1,7 @@
+# List of programs to build
+hostprogs-y := umn-test
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_umn-test.o += -I$(objtree)/usr/include
diff -puN /dev/null Documentation/ummunotify/ummunotify.txt
--- /dev/null
+++ a/Documentation/ummunotify/ummunotify.txt
@@ -0,0 +1,150 @@
+UMMUNOTIFY
+
+  Ummunotify relays MMU notifier events to userspace.  This is useful
+  for libraries that need to track the memory mapping of applications;
+  for example, MPI implementations using RDMA want to cache memory
+  registrations for performance, but tracking all possible crazy cases
+  such as when, say, the FORTRAN runtime frees memory is impossible
+  without kernel help.
+
+Basic Model
+
+  A userspace process uses it by opening /dev/ummunotify, which
+  returns a file descriptor.  Interest in address ranges is registered
+  using ioctl() and MMU notifier events are retrieved using read(), as
+  described in more detail below.  Userspace can register multiple
+  address ranges to watch, and can unregister individual ranges.
+
+  Userspace can also mmap() a single read-only page at offset 0 on
+  this file descriptor.  This page contains (at offest 0) a single
+  64-bit generation counter that the kernel increments each time an
+  MMU notifier event occurs.  Userspace can use this to very quickly
+  check if there are any events to retrieve without needing to do a
+  system call.
+
+Control
+
+  To start using ummunotify, a process opens /dev/ummunotify in
+  read-only mode.  Control from userspace is done via ioctl(); the
+  defined ioctls are:
+
+    UMMUNOTIFY_EXCHANGE_FEATURES: This ioctl takes a single 32-bit
+      word of feature flags as input, and the kernel updates the
+      features flags word to contain only features requested by
+      userspace and also supported by the kernel.
+
+      This ioctl is only included for forward compatibility; no
+      feature flags are currently defined, and the kernel will simply
+      update any requested feature mask to 0.  The kernel will always
+      default to a feature mask of 0 if this ioctl is not used, so
+      current userspace does not need to perform this ioctl.
+
+    UMMUNOTIFY_REGISTER_REGION: Userspace uses this ioctl to tell the
+      kernel to start delivering events for an address range.  The
+      range is described using struct ummunotify_register_ioctl:
+
+	struct ummunotify_register_ioctl {
+		__u64	start;
+		__u64	end;
+		__u64	user_cookie;
+		__u32	flags;
+		__u32	reserved;
+	};
+
+      start and end give the range of userspace virtual addresses;
+      start is included in the range and end is not, so an example of
+      a 4 KB range would be start=0x1000, end=0x2000.
+
+      user_cookie is an opaque 64-bit quantity that is returned by the
+      kernel in events involving the range, and used by userspace to
+      stop watching the range.  Each registered address range must
+      have a distinct user_cookie.
+
+      It is fine with the kernel if userspace registers multiple
+      overlapping or even duplicate address ranges, as long as a
+      different cookie is used for each registration.
+
+      flags and reserved are included for forward compatibility;
+      userspace should simply set them to 0 for the current interface.
+
+    UMMUNOTIFY_UNREGISTER_REGION: Userspace passes in the 64-bit
+      user_cookie used to register a range to tell the kernel to stop
+      watching an address range.  Once this ioctl completes, the
+      kernel will not deliver any further events for the range that is
+      unregistered.
+
+Events
+
+  When an event occurs that invalidates some of a process's memory
+  mapping in an address range being watched, ummunotify queues an
+  event report for that address range.  If more than one event
+  invalidates parts of the same address range before userspace
+  retrieves the queued report, then further reports for the same range
+  will not be queued -- when userspace does read the queue, only a
+  single report for a given range will be returned.
+
+  If multiple ranges being watched are invalidated by a single event
+  (which is especially likely if userspace registers overlapping
+  ranges), then an event report structure will be queued for each
+  address range registration.
+
+  Userspace retrieves queued events via read() on the ummunotify file
+  descriptor; a buffer that is at least as big as struct
+  ummunotify_event should be used to retrieve event reports, and if a
+  larger buffer is passed to read(), multiple reports will be returned
+  (if available).
+
+  If the ummunotify file descriptor is in blocking mode, a read() call
+  will wait for an event report to be available.  Userspace may also
+  set the ummunotify file descriptor to non-blocking mode and use all
+  standard ways of waiting for data to be available on the ummunotify
+  file descriptor, including epoll/poll()/select() and SIGIO.
+
+  The format of event reports is:
+
+	struct ummunotify_event {
+		__u32	type;
+		__u32	flags;
+		__u64	hint_start;
+		__u64	hint_end;
+		__u64	user_cookie_counter;
+	};
+
+  where the type field is either UMMUNOTIFY_EVENT_TYPE_INVAL or
+  UMMUNOTIFY_EVENT_TYPE_LAST.  Events of type INVAL describe
+  invalidation events as follows: user_cookie_counter contains the
+  cookie passed in when userspace registered the range that the event
+  is for.  hint_start and hint_end contain the start address and end
+  address that were invalidated.
+
+  The flags word contains bit flags, with only UMMUNOTIFY_EVENT_FLAG_HINT
+  defined at the moment.  If HINT is set, then the invalidation event
+  invalidated less than the full address range and the kernel returns
+  the exact range invalidated; if HINT is not sent then hint_start and
+  hint_end are set to the original range registered by userspace.
+  (HINT will not be set if, for example, multiple events invalidated
+  disjoint parts of the range and so a single start/end pair cannot
+  represent the parts of the range that were invalidated)
+
+  If the event type is LAST, then the read operation has emptied the
+  list of invalidated regions, and the flags, hint_start and hint_end
+  fields are not used.  user_cookie_counter holds the value of the
+  kernel's generation counter (see below of more details) when the
+  empty list occurred.
+
+Generation Count
+
+  Userspace may mmap() a page on a ummunotify file descriptor via
+
+	mmap(NULL, sizeof (__u64), PROT_READ, MAP_SHARED, ummunotify_fd, 0);
+
+  to get a read-only mapping of the kernel's 64-bit generation
+  counter.  The kernel will increment this generation counter each
+  time an event report is queued.
+
+  Userspace can use the generation counter as a quick check to avoid
+  system calls; if the value read from the mapped kernel counter is
+  still equal to the value returned in user_cookie_counter for the
+  most recent LAST event retrieved, then no further events have been
+  queued and there is no need to try a read() on the ummunotify file
+  descriptor.
diff -puN /dev/null Documentation/ummunotify/umn-test.c
--- /dev/null
+++ a/Documentation/ummunotify/umn-test.c
@@ -0,0 +1,200 @@
+/*
+ * Copyright (c) 2009 Cisco Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <stdint.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include <linux/ummunotify.h>
+
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+
+#define UMN_TEST_COOKIE 123
+
+static int		umn_fd;
+static volatile __u64  *umn_counter;
+
+static int umn_init(void)
+{
+	__u32 flags;
+
+	umn_fd = open("/dev/ummunotify", O_RDONLY);
+	if (umn_fd < 0) {
+		perror("open");
+		return 1;
+	}
+
+	if (ioctl(umn_fd, UMMUNOTIFY_EXCHANGE_FEATURES, &flags)) {
+		perror("exchange ioctl");
+		return 1;
+	}
+
+	printf("kernel feature flags: 0x%08x\n", flags);
+
+	umn_counter = mmap(NULL, sizeof *umn_counter, PROT_READ,
+			   MAP_SHARED, umn_fd, 0);
+	if (umn_counter == MAP_FAILED) {
+		perror("mmap");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int umn_register(void *buf, size_t size, __u64 cookie)
+{
+	struct ummunotify_register_ioctl r = {
+		.start		= (unsigned long) buf,
+		.end		= (unsigned long) buf + size,
+		.user_cookie	= cookie,
+	};
+
+	if (ioctl(umn_fd, UMMUNOTIFY_REGISTER_REGION, &r)) {
+		perror("register ioctl");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int umn_unregister(__u64 cookie)
+{
+	if (ioctl(umn_fd, UMMUNOTIFY_UNREGISTER_REGION, &cookie)) {
+		perror("unregister ioctl");
+		return 1;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int			page_size;
+	__u64			old_counter;
+	void		       *t;
+	int			got_it;
+
+	if (umn_init())
+		return 1;
+
+	printf("\n");
+
+	old_counter = *umn_counter;
+	if (old_counter != 0) {
+		fprintf(stderr, "counter = %lld (expected 0)\n", old_counter);
+		return 1;
+	}
+
+	page_size = sysconf(_SC_PAGESIZE);
+	t = mmap(NULL, 3 * page_size, PROT_READ,
+		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
+
+	if (umn_register(t, 3 * page_size, UMN_TEST_COOKIE))
+		return 1;
+
+	munmap(t + page_size, page_size);
+
+	old_counter = *umn_counter;
+	if (old_counter != 1) {
+		fprintf(stderr, "counter = %lld (expected 1)\n", old_counter);
+		return 1;
+	}
+
+	got_it = 0;
+	while (1) {
+		struct ummunotify_event	ev;
+		int			len;
+
+		len = read(umn_fd, &ev, sizeof ev);
+		if (len < 0) {
+			perror("read event");
+			return 1;
+		}
+		if (len != sizeof ev) {
+			fprintf(stderr, "Read gave %d bytes (!= event size %zd)\n",
+				len, sizeof ev);
+			return 1;
+		}
+
+		switch (ev.type) {
+		case UMMUNOTIFY_EVENT_TYPE_INVAL:
+			if (got_it) {
+				fprintf(stderr, "Extra invalidate event\n");
+				return 1;
+			}
+			if (ev.user_cookie_counter != UMN_TEST_COOKIE) {
+				fprintf(stderr, "Invalidate event for cookie %lld (expected %d)\n",
+					ev.user_cookie_counter,
+					UMN_TEST_COOKIE);
+				return 1;
+			}
+
+			printf("Invalidate event:\tcookie %lld\n",
+			       ev.user_cookie_counter);
+
+			if (!(ev.flags & UMMUNOTIFY_EVENT_FLAG_HINT)) {
+				fprintf(stderr, "Hint flag not set\n");
+				return 1;
+			}
+
+			if (ev.hint_start != (uintptr_t) t + page_size ||
+			    ev.hint_end != (uintptr_t) t + page_size * 2) {
+				fprintf(stderr, "Got hint %llx..%llx, expected %p..%p\n",
+					ev.hint_start, ev.hint_end,
+					t + page_size, t + page_size * 2);
+				return 1;
+			}
+
+			printf("\t\t\thint %llx...%llx\n",
+			       ev.hint_start, ev.hint_end);
+
+			got_it = 1;
+			break;
+
+		case UMMUNOTIFY_EVENT_TYPE_LAST:
+			if (!got_it) {
+				fprintf(stderr, "Last event without invalidate event\n");
+				return 1;
+			}
+
+			printf("Empty event:\t\tcounter %lld\n",
+			       ev.user_cookie_counter);
+			goto done;
+
+		default:
+			fprintf(stderr, "unknown event type %d\n",
+				ev.type);
+			return 1;
+		}
+	}
+
+done:
+	umn_unregister(123);
+	munmap(t, page_size);
+
+	old_counter = *umn_counter;
+	if (old_counter != 1) {
+		fprintf(stderr, "counter = %lld (expected 1)\n", old_counter);
+		return 1;
+	}
+
+	return 0;
+}
diff -puN drivers/char/ummunotify.c~ummunotify-userspace-support-for-mmu-notifications-v3 drivers/char/ummunotify.c
--- a/drivers/char/ummunotify.c~ummunotify-userspace-support-for-mmu-notifications-v3
+++ a/drivers/char/ummunotify.c
@@ -138,27 +138,39 @@ static void ummunotify_handle_notify(str
 	for (n = rb_first(&priv->reg_tree); n; n = rb_next(n)) {
 		reg = rb_entry(n, struct ummunotify_reg, node);
 
+		/*
+		 * Ranges overlap if they're not disjoint; and they're
+		 * disjoint if the end of one is before the start of
+		 * the other one.  So if both disjointness comparisons
+		 * fail then the ranges overlap.
+		 *
+		 * Since we keep the tree of regions we're watching
+		 * sorted by start address, we can end this loop as
+		 * soon as we hit a region that starts past the end of
+		 * the range for the event we're handling.
+		 */
 		if (reg->start >= end)
 			break;
 
 		/*
-		 * Ranges overlap if they're not disjoint; and they're
-		 * disjoint if the end of one is before the start of
-		 * the other one.
+		 * Just go to the next region if the start of the
+		 * range is after then end of the region -- there
+		 * might still be more overlapping ranges that have a
+		 * greater start.
 		 */
-		if (!(reg->end <= start || end <= reg->start)) {
-			hit = 1;
+		if (start >= reg->end)
+			continue;
 
-			if (!test_and_set_bit(UMMUNOTIFY_FLAG_INVALID, &reg->flags))
-				list_add_tail(&reg->list, &priv->invalid_list);
+		hit = 1;
 
-			if (test_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags)) {
-				clear_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags);
-			} else {
-				set_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags);
-				reg->hint_start = start;
-				reg->hint_end   = end;
-			}
+		if (test_and_set_bit(UMMUNOTIFY_FLAG_INVALID, &reg->flags)) {
+			/* Already on invalid list */
+			clear_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags);
+		} else {
+			list_add_tail(&reg->list, &priv->invalid_list);
+			set_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags);
+			reg->hint_start = start;
+			reg->hint_end   = end;
 		}
 	}
 
@@ -315,17 +327,17 @@ static ssize_t ummunotify_read(struct fi
 			break;
 		}
 
-		reg = list_first_entry(&priv->invalid_list, struct ummunotify_reg,
-				       list);
+		reg = list_first_entry(&priv->invalid_list,
+				       struct ummunotify_reg, list);
 
 		events[n].type = UMMUNOTIFY_EVENT_TYPE_INVAL;
 		if (test_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags)) {
-			events[n].flags	= UMMUNOTIFY_EVENT_FLAG_HINT;
+			events[n].flags	     = UMMUNOTIFY_EVENT_FLAG_HINT;
 			events[n].hint_start = max(reg->start, reg->hint_start);
-			events[n].hint_end = min(reg->end, reg->hint_end);
+			events[n].hint_end   = min(reg->end, reg->hint_end);
 		} else {
 			events[n].hint_start = reg->start;
-			events[n].hint_end = reg->end;
+			events[n].hint_end   = reg->end;
 		}
 		events[n].user_cookie_counter = reg->user_cookie;
 
@@ -347,7 +359,7 @@ out:
 }
 
 static unsigned int ummunotify_poll(struct file *filp,
-					struct poll_table_struct *wait)
+				    struct poll_table_struct *wait)
 {
 	struct ummunotify_file *priv = filp->private_data;
 
@@ -379,7 +391,7 @@ static long ummunotify_exchange_features
 }
 
 static long ummunotify_register_region(struct ummunotify_file *priv,
-				   struct ummunotify_register_ioctl __user *arg)
+				       void __user *arg)
 {
 	struct ummunotify_register_ioctl parm;
 	struct ummunotify_reg *reg, *treg;
diff -puN include/linux/ummunotify.h~ummunotify-userspace-support-for-mmu-notifications-v3 include/linux/ummunotify.h
--- a/include/linux/ummunotify.h~ummunotify-userspace-support-for-mmu-notifications-v3
+++ a/include/linux/ummunotify.h
@@ -44,11 +44,11 @@
  * unused and should be set to 0 for forward compatibility.
  */
 struct ummunotify_register_ioctl {
-	__u64	start;		/* in */
-	__u64	end;		/* in */
-	__u64	user_cookie;	/* in */
-	__u32	flags;		/* in */
-	__u32	reserved;	/* in */
+	__u64	start;
+	__u64	end;
+	__u64	user_cookie;
+	__u32	flags;
+	__u32	reserved;
 };
 
 #define UMMUNOTIFY_MAGIC		'U'
_

Patches currently in -mm which might be from rolandd@cisco.com are

linux-next.patch
ummunotify-userspace-support-for-mmu-notifications-v3-fix.patch

