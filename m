From: akpm@linux-foundation.org
Subject: - kill-declare_mutex_locked.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:06 -0700
Message-ID: <200710180653.l9I6r6dL030410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932334AbXJRHmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:42:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, satyam.sharma@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kill DECLARE_MUTEX_LOCKED
has been removed from the -mm tree.  Its filename was
     kill-declare_mutex_locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kill DECLARE_MUTEX_LOCKED
From: Christoph Hellwig <hch@lst.de>

DECLARE_MUTEX_LOCKED was used for semaphores used as completions and we've
got rid of them.  Well, except for one in libusual that the maintainer
explicitly wants to keep as semaphore.  So convert that useage to an
explicit sema_init and kill of DECLARE_MUTEX_LOCKED so that new code is
reminded to use a completion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: "Satyam Sharma" <satyam.sharma@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/libusual.c    |    4 +++-
 include/asm-alpha/semaphore.h     |    1 -
 include/asm-arm/semaphore.h       |    1 -
 include/asm-avr32/semaphore.h     |    1 -
 include/asm-blackfin/semaphore.h  |    1 -
 include/asm-cris/semaphore.h      |    1 -
 include/asm-frv/semaphore.h       |    1 -
 include/asm-h8300/semaphore.h     |    1 -
 include/asm-ia64/semaphore.h      |    1 -
 include/asm-m32r/semaphore.h      |    1 -
 include/asm-m68k/semaphore.h      |    1 -
 include/asm-m68knommu/semaphore.h |    1 -
 include/asm-mips/semaphore.h      |    1 -
 include/asm-parisc/semaphore.h    |    1 -
 include/asm-powerpc/semaphore.h   |    1 -
 include/asm-s390/semaphore.h      |    1 -
 include/asm-sh/semaphore.h        |    1 -
 include/asm-sh64/semaphore.h      |    1 -
 include/asm-sparc/semaphore.h     |    1 -
 include/asm-sparc64/semaphore.h   |    1 -
 include/asm-v850/semaphore.h      |    1 -
 include/asm-x86/semaphore_32.h    |    1 -
 include/asm-x86/semaphore_64.h    |    1 -
 include/asm-xtensa/semaphore.h    |    1 -
 24 files changed, 3 insertions(+), 24 deletions(-)

diff -puN drivers/usb/storage/libusual.c~kill-declare_mutex_locked drivers/usb/storage/libusual.c
--- a/drivers/usb/storage/libusual.c~kill-declare_mutex_locked
+++ a/drivers/usb/storage/libusual.c
@@ -30,7 +30,7 @@ static atomic_t usu_bias = ATOMIC_INIT(U
 #define BIAS_NAME_SIZE  (sizeof("usb-storage"))
 static const char *bias_names[3] = { "none", "usb-storage", "ub" };
 
-static DECLARE_MUTEX_LOCKED(usu_init_notify);
+static struct semaphore usu_init_notify;
 static DECLARE_COMPLETION(usu_end_notify);
 static atomic_t total_threads = ATOMIC_INIT(0);
 
@@ -204,6 +204,8 @@ static int __init usb_usual_init(void)
 {
 	int rc;
 
+	sema_init(&usu_init_notify, 0);
+
 	rc = usb_register(&usu_driver);
 	up(&usu_init_notify);
 	return rc;
diff -puN include/asm-alpha/semaphore.h~kill-declare_mutex_locked include/asm-alpha/semaphore.h
--- a/include/asm-alpha/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-alpha/semaphore.h
@@ -30,7 +30,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
diff -puN include/asm-arm/semaphore.h~kill-declare_mutex_locked include/asm-arm/semaphore.h
--- a/include/asm-arm/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-arm/semaphore.h
@@ -28,7 +28,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INIT(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
diff -puN include/asm-avr32/semaphore.h~kill-declare_mutex_locked include/asm-avr32/semaphore.h
--- a/include/asm-avr32/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-avr32/semaphore.h
@@ -36,7 +36,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-blackfin/semaphore.h~kill-declare_mutex_locked include/asm-blackfin/semaphore.h
--- a/include/asm-blackfin/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-blackfin/semaphore.h
@@ -35,7 +35,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
diff -puN include/asm-cris/semaphore.h~kill-declare_mutex_locked include/asm-cris/semaphore.h
--- a/include/asm-cris/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-cris/semaphore.h
@@ -35,7 +35,6 @@ struct semaphore {
         struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
diff -puN include/asm-frv/semaphore.h~kill-declare_mutex_locked include/asm-frv/semaphore.h
--- a/include/asm-frv/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-frv/semaphore.h
@@ -49,7 +49,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-h8300/semaphore.h~kill-declare_mutex_locked include/asm-h8300/semaphore.h
--- a/include/asm-h8300/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-h8300/semaphore.h
@@ -39,7 +39,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-ia64/semaphore.h~kill-declare_mutex_locked include/asm-ia64/semaphore.h
--- a/include/asm-ia64/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-ia64/semaphore.h
@@ -28,7 +28,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void
 sema_init (struct semaphore *sem, int val)
diff -puN include/asm-m32r/semaphore.h~kill-declare_mutex_locked include/asm-m32r/semaphore.h
--- a/include/asm-m32r/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-m32r/semaphore.h
@@ -35,7 +35,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-m68k/semaphore.h~kill-declare_mutex_locked include/asm-m68k/semaphore.h
--- a/include/asm-m68k/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-m68k/semaphore.h
@@ -40,7 +40,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
diff -puN include/asm-m68knommu/semaphore.h~kill-declare_mutex_locked include/asm-m68knommu/semaphore.h
--- a/include/asm-m68knommu/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-m68knommu/semaphore.h
@@ -39,7 +39,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-mips/semaphore.h~kill-declare_mutex_locked include/asm-mips/semaphore.h
--- a/include/asm-mips/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-mips/semaphore.h
@@ -49,7 +49,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
diff -puN include/asm-parisc/semaphore.h~kill-declare_mutex_locked include/asm-parisc/semaphore.h
--- a/include/asm-parisc/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-parisc/semaphore.h
@@ -53,7 +53,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 extern inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-powerpc/semaphore.h~kill-declare_mutex_locked include/asm-powerpc/semaphore.h
--- a/include/asm-powerpc/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-powerpc/semaphore.h
@@ -35,7 +35,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-s390/semaphore.h~kill-declare_mutex_locked include/asm-s390/semaphore.h
--- a/include/asm-s390/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-s390/semaphore.h
@@ -33,7 +33,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-sh/semaphore.h~kill-declare_mutex_locked include/asm-sh/semaphore.h
--- a/include/asm-sh/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-sh/semaphore.h
@@ -37,7 +37,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-sh64/semaphore.h~kill-declare_mutex_locked include/asm-sh64/semaphore.h
--- a/include/asm-sh64/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-sh64/semaphore.h
@@ -44,7 +44,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-sparc/semaphore.h~kill-declare_mutex_locked include/asm-sparc/semaphore.h
--- a/include/asm-sparc/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-sparc/semaphore.h
@@ -26,7 +26,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-sparc64/semaphore.h~kill-declare_mutex_locked include/asm-sparc64/semaphore.h
--- a/include/asm-sparc64/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-sparc64/semaphore.h
@@ -26,7 +26,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-v850/semaphore.h~kill-declare_mutex_locked include/asm-v850/semaphore.h
--- a/include/asm-v850/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-v850/semaphore.h
@@ -22,7 +22,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER (name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC (name,1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC (name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-x86/semaphore_32.h~kill-declare_mutex_locked include/asm-x86/semaphore_32.h
--- a/include/asm-x86/semaphore_32.h~kill-declare_mutex_locked
+++ a/include/asm-x86/semaphore_32.h
@@ -59,7 +59,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-x86/semaphore_64.h~kill-declare_mutex_locked include/asm-x86/semaphore_64.h
--- a/include/asm-x86/semaphore_64.h~kill-declare_mutex_locked
+++ a/include/asm-x86/semaphore_64.h
@@ -60,7 +60,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
diff -puN include/asm-xtensa/semaphore.h~kill-declare_mutex_locked include/asm-xtensa/semaphore.h
--- a/include/asm-xtensa/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-xtensa/semaphore.h
@@ -33,7 +33,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dcache-dont-expose-uninitialized-memory-in.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
reiserfs-fix-up-lockdep-warnings.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-dont-use-bug-when-panicking.patch
reiserfs-use-is_reusable-to-catch-corruption.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-fix-memset-byte-count-during-resize.patch
reiserfs-remove-first_zero_hint.patch
reiserfs-remove-first_zero_hint-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
