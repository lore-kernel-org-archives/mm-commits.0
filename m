From: akpm@linux-foundation.org
Subject: + kill-declare_mutex_locked.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:31:51 -0700
Message-ID: <200707192131.l6JLVpLN024060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762261AbXGSVcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de


The patch titled
     kill DECLARE_MUTEX_LOCKED
has been added to the -mm tree.  Its filename is
     kill-declare_mutex_locked.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kill DECLARE_MUTEX_LOCKED
From: Christoph Hellwig <hch@lst.de>

DECLARE_MUTEX_LOCKED was used for semaphores used as completions and we've
got rid of them.  Well, except for one in libusual that the maintainer
explicitly wants to keep as semaphore.  So convert that useage to an
explicit sema_init and kill of DECLARE_MUTEX_LOCKED so that new code is
reminded to use a completion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/libusual.c    |    4 +++-
 include/asm-alpha/semaphore.h     |    1 -
 include/asm-arm/semaphore.h       |    1 -
 include/asm-arm26/semaphore.h     |    1 -
 include/asm-avr32/semaphore.h     |    1 -
 include/asm-blackfin/semaphore.h  |    1 -
 include/asm-cris/semaphore.h      |    1 -
 include/asm-frv/semaphore.h       |    1 -
 include/asm-h8300/semaphore.h     |    1 -
 include/asm-i386/semaphore.h      |    1 -
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
 include/asm-x86_64/semaphore.h    |    1 -
 include/asm-xtensa/semaphore.h    |    1 -
 25 files changed, 3 insertions(+), 25 deletions(-)

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
diff -puN include/asm-arm26/semaphore.h~kill-declare_mutex_locked include/asm-arm26/semaphore.h
--- a/include/asm-arm26/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-arm26/semaphore.h
@@ -29,7 +29,6 @@ struct semaphore {
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
diff -puN include/asm-i386/semaphore.h~kill-declare_mutex_locked include/asm-i386/semaphore.h
--- a/include/asm-i386/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-i386/semaphore.h
@@ -59,7 +59,6 @@ struct semaphore {
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
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void sema_init (struct semaphore *sem, int val)
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
diff -puN include/asm-x86_64/semaphore.h~kill-declare_mutex_locked include/asm-x86_64/semaphore.h
--- a/include/asm-x86_64/semaphore.h~kill-declare_mutex_locked
+++ a/include/asm-x86_64/semaphore.h
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
fix-spufs-build-after-fault-changes.patch
gdth-remove-redundant-pci-stuff.patch
gdth-remove-redundant-pci-stuff-update.patch
git-xfs.patch
remove-handle_mm_fault-export.patch
sysv-convert-to-new-aops.patch
kill-declare_mutex_locked.patch
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
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
