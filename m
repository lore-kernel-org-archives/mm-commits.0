From: akpm@linux-foundation.org
Subject: + tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
 added to -mm tree
Date: Wed, 21 May 2014 15:13:03 -0700
Message-ID: <537d24ef.o2OekqYr6XCTsuSn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaEUWNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 May 2014 18:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, koct9i@gmail.com

Subject: + tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch added to -mm tree
To: koct9i@gmail.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Wed, 21 May 2014 15:13:03 -0700


The patch titled
     Subject: tools/vm/page-types.c: catch sigbus if raced with truncate
has been added to the -mm tree.  Its filename is
     tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: tools/vm/page-types.c: catch sigbus if raced with truncate

Recently added page-cache dumping is known to be a little bit racy.
But after race with truncate it just dies due to unhandled SIGBUS
when it tries to poke pages beyond the new end of file.
This patch adds handler for SIGBUS which skips the rest of the file.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff -puN tools/vm/page-types.c~tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate
+++ a/tools/vm/page-types.c
@@ -32,6 +32,8 @@
 #include <assert.h>
 #include <ftw.h>
 #include <time.h>
+#include <setjmp.h>
+#include <signal.h>
 #include <sys/types.h>
 #include <sys/errno.h>
 #include <sys/fcntl.h>
@@ -824,21 +826,38 @@ static void show_file(const char *name,
 			atime, now - st->st_atime);
 }
 
+static sigjmp_buf sigbus_jmp;
+
+static void * volatile sigbus_addr;
+
+static void sigbus_handler(int sig, siginfo_t *info, void *ucontex)
+{
+	(void)sig;
+	(void)ucontex;
+	sigbus_addr = info ? info->si_addr : NULL;
+	siglongjmp(sigbus_jmp, 1);
+}
+
+static struct sigaction sigbus_action = {
+	.sa_sigaction = sigbus_handler,
+	.sa_flags = SA_SIGINFO,
+};
+
 static void walk_file(const char *name, const struct stat *st)
 {
 	uint8_t vec[PAGEMAP_BATCH];
 	uint64_t buf[PAGEMAP_BATCH], flags;
 	unsigned long nr_pages, pfn, i;
+	off_t off, end = st->st_size;
 	int fd;
-	off_t off;
 	ssize_t len;
 	void *ptr;
 	int first = 1;
 
 	fd = checked_open(name, O_RDONLY|O_NOATIME|O_NOFOLLOW);
 
-	for (off = 0; off < st->st_size; off += len) {
-		nr_pages = (st->st_size - off + page_size - 1) / page_size;
+	for (off = 0; off < end; off += len) {
+		nr_pages = (end - off + page_size - 1) / page_size;
 		if (nr_pages > PAGEMAP_BATCH)
 			nr_pages = PAGEMAP_BATCH;
 		len = nr_pages * page_size;
@@ -855,11 +874,19 @@ static void walk_file(const char *name,
 		if (madvise(ptr, len, MADV_RANDOM))
 			fatal("madvice failed: %s", name);
 
+		if (sigsetjmp(sigbus_jmp, 1)) {
+			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
+			fprintf(stderr, "got sigbus at offset %lld: %s\n",
+					(long long)end, name);
+			goto got_sigbus;
+		}
+
 		/* populate ptes */
 		for (i = 0; i < nr_pages ; i++) {
 			if (vec[i] & 1)
 				(void)*(volatile int *)(ptr + i * page_size);
 		}
+got_sigbus:
 
 		/* turn off harvesting reference bits */
 		if (madvise(ptr, len, MADV_SEQUENTIAL))
@@ -910,6 +937,7 @@ static void walk_page_cache(void)
 
 	kpageflags_fd = checked_open(PROC_KPAGEFLAGS, O_RDONLY);
 	pagemap_fd = checked_open("/proc/self/pagemap", O_RDONLY);
+	sigaction(SIGBUS, &sigbus_action, NULL);
 
 	if (stat(opt_file, &st))
 		fatal("stat failed: %s\n", opt_file);
@@ -925,6 +953,7 @@ static void walk_page_cache(void)
 
 	close(kpageflags_fd);
 	close(pagemap_fd);
+	signal(SIGBUS, SIG_DFL);
 }
 
 static void parse_file(const char *name)
_

Patches currently in -mm which might be from koct9i@gmail.com are

tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
linux-next.patch

