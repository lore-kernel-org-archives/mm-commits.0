From: akpm@linux-foundation.org
Subject: [merged] kfifo-use-void-pointers-for-user-buffers.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:23 -0800
Message-ID: <201001212127.o0LLRNgn030638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326Ab0AUV2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, awalls@radix.net, dhillonv10@gmail.com, dmitry.torokhov@gmail.com, rdreier@cisco.com, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kfifo: use void * pointers for user buffers
has been removed from the -mm tree.  Its filename was
     kfifo-use-void-pointers-for-user-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: use void * pointers for user buffers
From: Andi Kleen <andi@firstfloor.org>

The pointers to user buffers are currently unsigned char *, which requires
a lot of casting in the caller for any non-char typed buffers.  Use void *
instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@radix.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   10 +++++-----
 kernel/kfifo.c        |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-use-void-pointers-for-user-buffers include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-use-void-pointers-for-user-buffers
+++ a/include/linux/kfifo.h
@@ -104,15 +104,15 @@ union { \
 
 #undef __kfifo_initializer
 
-extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
+extern void kfifo_init(struct kfifo *fifo, void *buffer,
 			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
 			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int kfifo_in(struct kfifo *fifo,
-				const unsigned char *from, unsigned int len);
+				const void *from, unsigned int len);
 extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
-				unsigned char *to, unsigned int len);
+				void *to, unsigned int len);
 
 /**
  * kfifo_reset - removes the entire FIFO contents
@@ -194,7 +194,7 @@ static inline __must_check unsigned int 
  * bytes copied.
  */
 static inline unsigned int kfifo_in_locked(struct kfifo *fifo,
-		const unsigned char *from, unsigned int n, spinlock_t *lock)
+		const void *from, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
 	unsigned int ret;
@@ -219,7 +219,7 @@ static inline unsigned int kfifo_in_lock
  * @to buffer and returns the number of copied bytes.
  */
 static inline __must_check unsigned int kfifo_out_locked(struct kfifo *fifo,
-	unsigned char *to, unsigned int n, spinlock_t *lock)
+	void *to, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
 	unsigned int ret;
diff -puN kernel/kfifo.c~kfifo-use-void-pointers-for-user-buffers kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-use-void-pointers-for-user-buffers
+++ a/kernel/kfifo.c
@@ -28,7 +28,7 @@
 #include <linux/log2.h>
 #include <linux/uaccess.h>
 
-static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
+static void _kfifo_init(struct kfifo *fifo, void *buffer,
 		unsigned int size)
 {
 	fifo->buffer = buffer;
@@ -44,7 +44,7 @@ static void _kfifo_init(struct kfifo *fi
  * @size: the size of the internal buffer, this have to be a power of 2.
  *
  */
-void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
+void kfifo_init(struct kfifo *fifo, void *buffer, unsigned int size)
 {
 	/* size must be a power of 2 */
 	BUG_ON(!is_power_of_2(size));
@@ -235,7 +235,7 @@ EXPORT_SYMBOL(__kfifo_in_n);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_in(struct kfifo *fifo, const unsigned char *from,
+unsigned int kfifo_in(struct kfifo *fifo, const void *from,
 				unsigned int len)
 {
 	len = min(kfifo_avail(fifo), len);
@@ -277,7 +277,7 @@ EXPORT_SYMBOL(__kfifo_out_n);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_out(struct kfifo *fifo, unsigned char *to, unsigned int len)
+unsigned int kfifo_out(struct kfifo *fifo, void *to, unsigned int len)
 {
 	len = min(kfifo_len(fifo), len);
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
mm-add-swap-slot-free-callback-to-block_device_operations.patch
kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
rcu-add-rcustring-adt-for-rcu-protected-strings.patch
add-a-kernel_address-that-works-for-data-too.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch

