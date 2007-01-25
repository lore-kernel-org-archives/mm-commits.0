From: akpm@osdl.org
Subject: + uml-locking-fixes-in-the-ubd-driver.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:03:39 -0800
Message-ID: <200701250603.l0P63dUJ007569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341AbXAYGDm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:03:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: locking fixes in the ubd driver
has been added to the -mm tree.  Its filename is
     uml-locking-fixes-in-the-ubd-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: locking fixes in the ubd driver
From: Jeff Dike <jdike@addtoit.com>

Some small locking and formatting fixes in the ubd driver.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/ubd_kern.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-locking-fixes-in-the-ubd-driver arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-locking-fixes-in-the-ubd-driver
+++ a/arch/um/drivers/ubd_kern.c
@@ -131,7 +131,6 @@ static struct block_device_operations ub
 
 /* Protected by ubd_lock */
 static int fake_major = MAJOR_NR;
-
 static struct gendisk *ubd_gendisk[MAX_DEV];
 static struct gendisk *fake_gendisk[MAX_DEV];
 
@@ -142,10 +141,6 @@ static struct gendisk *fake_gendisk[MAX_
 #define OPEN_FLAGS ((struct openflags) { .r = 1, .w = 1, .s = 0, .c = 0, \
 					 .cl = 1 })
 #endif
-
-/* Not protected - changed only in ubd_setup_common and then only to
- * to enable O_SYNC.
- */
 static struct openflags global_openflags = OPEN_FLAGS;
 
 struct cow {
@@ -197,6 +192,7 @@ struct ubd {
 	.lock =			SPIN_LOCK_UNLOCKED,	\
 }
 
+/* Protected by ubd_lock */
 struct ubd ubd_devs[MAX_DEV] = { [ 0 ... MAX_DEV - 1 ] = DEFAULT_UBD };
 
 /* Only changed by fake_ide_setup which is a setup */
@@ -288,7 +284,7 @@ static int ubd_setup_common(char *str, i
 	struct ubd *ubd_dev;
 	struct openflags flags = global_openflags;
 	char *backing_file;
-	int n, err, i;
+	int n, err = 0, i;
 
 	if(index_out) *index_out = -1;
 	n = *str;
@@ -299,15 +295,16 @@ static int ubd_setup_common(char *str, i
 		str++;
 		if(!strcmp(str, "sync")){
 			global_openflags = of_sync(global_openflags);
-			return 0;
+			goto out1;
 		}
+
+		err = -EINVAL;
 		major = simple_strtoul(str, &end, 0);
 		if((*end != '\0') || (end == str)){
 			*error_out = "Didn't parse major number";
-			return -EINVAL;
+			goto out1;
 		}
 
-		err = -EINVAL;
 		mutex_lock(&ubd_lock);
 		if(fake_major != MAJOR_NR){
 			*error_out = "Can't assign a fake major twice";
@@ -473,12 +470,6 @@ static void do_ubd_request(request_queue
 /* Only changed by ubd_init, which is an initcall. */
 int thread_fd = -1;
 
-/* Changed by ubd_handler, which is serialized because interrupts only
- * happen on CPU 0.
- * XXX: currently unused.
- */
-static int intr_count = 0;
-
 /* call ubd_finish if you need to serialize */
 static void __ubd_finish(struct request *req, int error)
 {
@@ -518,7 +509,6 @@ static void ubd_handler(void)
 	int n;
 
 	do_ubd = 0;
-	intr_count++;
 	n = os_read_file(thread_fd, &req, sizeof(req));
 	if(n != sizeof(req)){
 		printk(KERN_ERR "Pid %d - spurious interrupt in ubd_handler, "
@@ -637,8 +627,7 @@ static int ubd_open_dev(struct ubd *ubd_
 }
 
 static int ubd_disk_register(int major, u64 size, int unit,
-			struct gendisk **disk_out)
-			
+			     struct gendisk **disk_out)
 {
 	struct gendisk *disk;
 
@@ -840,7 +829,7 @@ out:
 }
 
 /* All these are called by mconsole in process context and without
- * ubd-specific locks.
+ * ubd-specific locks.  The structure itself is const except for .list.
  */
 static struct mc_device ubd_mc = {
 	.list		= LIST_HEAD_INIT(ubd_mc.list),
@@ -863,13 +852,17 @@ static int __init ubd0_init(void)
 {
 	struct ubd *ubd_dev = &ubd_devs[0];
 
+	mutex_lock(&ubd_lock);
 	if(ubd_dev->file == NULL)
 		ubd_dev->file = "root_fs";
+	mutex_unlock(&ubd_lock);
+
 	return(0);
 }
 
 __initcall(ubd0_init);
 
+/* Used in ubd_init, which is an initcall */
 static struct platform_driver ubd_driver = {
 	.driver = {
 		.name  = DRIVER_NAME,
@@ -892,12 +885,14 @@ static int __init ubd_init(void)
 			return -1;
 	}
 	platform_driver_register(&ubd_driver);
+ 	mutex_lock(&ubd_lock);
 	for (i = 0; i < MAX_DEV; i++){
 		err = ubd_add(i, &error);
 		if(err)
 			printk(KERN_ERR "Failed to initialize ubd device %d :"
 			       "%s\n", i, error);
 	}
+ 	mutex_unlock(&ubd_lock);
 	return 0;
 }
 
@@ -1129,7 +1124,7 @@ static int ubd_ioctl(struct inode * inod
 				 sizeof(ubd_id)))
 			return(-EFAULT);
 		return(0);
-		
+
 	case CDROMVOLREAD:
 		if(copy_from_user(&volume, (char __user *) arg, sizeof(volume)))
 			return(-EFAULT);
_

Patches currently in -mm which might be from jdike@addtoit.com are

fix-uml-on-non-standard-vm-split-hosts.patch
uml-fix-mknod.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
