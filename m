From: akpm@linux-foundation.org
Subject: - uml-formatting-fixes-around-os_read_write_file-callers.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:25 -0700
Message-ID: <200705080007.l4807Pcf009281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967419AbXEHAH6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: formatting fixes around os_{read_write}_file callers
has been removed from the -mm tree.  Its filename was
     uml-formatting-fixes-around-os_read_write_file-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: formatting fixes around os_{read_write}_file callers
From: Jeff Dike <jdike@addtoit.com>

Formatting fixes ahead of renaming os_{read_write}_file_k to
os_{read_write}_file and fixing all the callers.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c |   11 ---
 arch/um/drivers/cow_sys.h   |   17 +---
 arch/um/drivers/ubd_kern.c  |  124 +++++++++++++++++-----------------
 arch/um/kernel/initrd.c     |   32 ++++----
 arch/um/kernel/smp.c        |   25 +-----
 5 files changed, 89 insertions(+), 120 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-formatting-fixes-around-os_read_write_file-callers arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-formatting-fixes-around-os_read_write_file-callers
+++ a/arch/um/drivers/chan_user.c
@@ -203,14 +203,3 @@ void register_winch(int fd, struct tty_s
 		}
 	}
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/cow_sys.h~uml-formatting-fixes-around-os_read_write_file-callers arch/um/drivers/cow_sys.h
--- a/arch/um/drivers/cow_sys.h~uml-formatting-fixes-around-os_read_write_file-callers
+++ a/arch/um/drivers/cow_sys.h
@@ -8,7 +8,7 @@
 
 static inline void *cow_malloc(int size)
 {
-	return(um_kmalloc(size));
+	return um_kmalloc(size);
 }
 
 static inline void cow_free(void *ptr)
@@ -20,29 +20,22 @@ static inline void cow_free(void *ptr)
 
 static inline char *cow_strdup(char *str)
 {
-	return(uml_strdup(str));
+	return uml_strdup(str);
 }
 
 static inline int cow_seek_file(int fd, __u64 offset)
 {
-	return(os_seek_file(fd, offset));
+	return os_seek_file(fd, offset);
 }
 
 static inline int cow_file_size(char *file, unsigned long long *size_out)
 {
-	return(os_file_size(file, size_out));
+	return os_file_size(file, size_out);
 }
 
 static inline int cow_write_file(int fd, void *buf, int size)
 {
-	return(os_write_file_k(fd, buf, size));
+	return os_write_file_k(fd, buf, size);
 }
 
 #endif
-
-/*
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/ubd_kern.c~uml-formatting-fixes-around-os_read_write_file-callers arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-formatting-fixes-around-os_read_write_file-callers
+++ a/arch/um/drivers/ubd_kern.c
@@ -89,7 +89,7 @@ static inline int ubd_test_bit(__u64 bit
 	bits = sizeof(data[0]) * 8;
 	n = bit / bits;
 	off = bit % bits;
-	return((data[n] & (1 << off)) != 0);
+	return (data[n] & (1 << off)) != 0;
 }
 
 static inline void ubd_set_bit(__u64 bit, unsigned char *data)
@@ -146,7 +146,7 @@ struct cow {
 	unsigned long *bitmap;
 	unsigned long bitmap_len;
 	int bitmap_offset;
-        int data_offset;
+	int data_offset;
 };
 
 #define MAX_SG 64
@@ -174,10 +174,10 @@ struct ubd {
 
 #define DEFAULT_COW { \
 	.file =			NULL, \
-        .fd =			-1, \
-        .bitmap =		NULL, \
+	.fd =			-1,	\
+	.bitmap =		NULL, \
 	.bitmap_offset =	0, \
-        .data_offset =		0, \
+	.data_offset =		0, \
 }
 
 #define DEFAULT_UBD { \
@@ -187,9 +187,9 @@ struct ubd {
 	.size =			-1, \
 	.boot_openflags =	OPEN_FLAGS, \
 	.openflags =		OPEN_FLAGS, \
-        .no_cow =               0, \
+	.no_cow =               0, \
 	.shared =		0, \
-        .cow =			DEFAULT_COW, \
+	.cow =			DEFAULT_COW, \
 	.lock =			SPIN_LOCK_UNLOCKED,	\
 	.request =		NULL, \
 	.start_sg =		0, \
@@ -249,7 +249,7 @@ static void make_ide_entries(char *dev_n
 static int fake_ide_setup(char *str)
 {
 	fake_ide = 1;
-	return(1);
+	return 1;
 }
 
 __setup("fake_ide", fake_ide_setup);
@@ -267,7 +267,7 @@ static int parse_unit(char **ptr)
 	if(isdigit(*str)) {
 		n = simple_strtoul(str, &end, 0);
 		if(end == str)
-			return(-1);
+			return -1;
 		*ptr = end;
 	}
 	else if (('a' <= *str) && (*str <= 'z')) {
@@ -275,7 +275,7 @@ static int parse_unit(char **ptr)
 		str++;
 		*ptr = str;
 	}
-	return(n);
+	return n;
 }
 
 /* If *index_out == -1 at exit, the passed option was a general one;
@@ -442,7 +442,7 @@ static int udb_setup(char *str)
 {
 	printk("udb%s specified on command line is almost certainly a ubd -> "
 	       "udb TYPO\n", str);
-	return(1);
+	return 1;
 }
 
 __setup("udb", udb_setup);
@@ -541,7 +541,7 @@ static void ubd_handler(void)
 static irqreturn_t ubd_intr(int irq, void *dev)
 {
 	ubd_handler();
-	return(IRQ_HANDLED);
+	return IRQ_HANDLED;
 }
 
 /* Only changed by ubd_init, which is an initcall. */
@@ -560,7 +560,7 @@ static inline int ubd_file_size(struct u
 	char *file;
 
 	file = ubd_dev->cow.file ? ubd_dev->cow.file : ubd_dev->file;
-	return(os_file_size(file, size_out));
+	return os_file_size(file, size_out);
 }
 
 static void ubd_close_dev(struct ubd *ubd_dev)
@@ -632,10 +632,10 @@ static int ubd_open_dev(struct ubd *ubd_
 		if(err < 0) goto error;
 		ubd_dev->cow.fd = err;
 	}
-	return(0);
+	return 0;
  error:
 	os_close_file(ubd_dev->fd);
-	return(err);
+	return err;
 }
 
 static void ubd_device_release(struct device *dev)
@@ -653,7 +653,7 @@ static int ubd_disk_register(int major, 
 
 	disk = alloc_disk(1 << UBD_SHIFT);
 	if(disk == NULL)
-		return(-ENOMEM);
+		return -ENOMEM;
 
 	disk->major = major;
 	disk->first_minor = unit << UBD_SHIFT;
@@ -758,14 +758,14 @@ static int ubd_config(char *str, char **
 		goto err_free;
 	}
 
- 	mutex_lock(&ubd_lock);
+	mutex_lock(&ubd_lock);
 	ret = ubd_add(n, error_out);
 	if (ret)
 		ubd_devs[n].file = NULL;
- 	mutex_unlock(&ubd_lock);
+	mutex_unlock(&ubd_lock);
 
 out:
- 	return ret;
+	return ret;
 
 err_free:
 	kfree(str);
@@ -780,7 +780,7 @@ static int ubd_get_config(char *name, ch
 	n = parse_unit(&name);
 	if((n >= MAX_DEV) || (n < 0)){
 		*error_out = "ubd_get_config : device number out of range";
-		return(-1);
+		return -1;
 	}
 
 	ubd_dev = &ubd_devs[n];
@@ -801,17 +801,17 @@ static int ubd_get_config(char *name, ch
 
  out:
 	mutex_unlock(&ubd_lock);
-	return(len);
+	return len;
 }
 
 static int ubd_id(char **str, int *start_out, int *end_out)
 {
-        int n;
+	int n;
 
 	n = parse_unit(str);
-        *start_out = 0;
-        *end_out = MAX_DEV - 1;
-        return n;
+	*start_out = 0;
+	*end_out = MAX_DEV - 1;
+	return n;
 }
 
 static int ubd_remove(int n, char **error_out)
@@ -832,7 +832,7 @@ static int ubd_remove(int n, char **erro
 	if(ubd_dev->count > 0)
 		goto out;
 
- 	ubd_gendisk[n] = NULL;
+	ubd_gendisk[n] = NULL;
 	if(disk != NULL){
 		del_gendisk(disk);
 		put_disk(disk);
@@ -858,7 +858,7 @@ static struct mc_device ubd_mc = {
 	.list		= LIST_HEAD_INIT(ubd_mc.list),
 	.name		= "ubd",
 	.config		= ubd_config,
- 	.get_config	= ubd_get_config,
+	.get_config	= ubd_get_config,
 	.id		= ubd_id,
 	.remove		= ubd_remove,
 };
@@ -880,7 +880,7 @@ static int __init ubd0_init(void)
 		ubd_dev->file = "root_fs";
 	mutex_unlock(&ubd_lock);
 
-	return(0);
+	return 0;
 }
 
 __initcall(ubd0_init);
@@ -908,14 +908,14 @@ static int __init ubd_init(void)
 			return -1;
 	}
 	platform_driver_register(&ubd_driver);
- 	mutex_lock(&ubd_lock);
+	mutex_lock(&ubd_lock);
 	for (i = 0; i < MAX_DEV; i++){
 		err = ubd_add(i, &error);
 		if(err)
 			printk(KERN_ERR "Failed to initialize ubd device %d :"
 			       "%s\n", i, error);
 	}
- 	mutex_unlock(&ubd_lock);
+	mutex_unlock(&ubd_lock);
 	return 0;
 }
 
@@ -939,7 +939,7 @@ static int __init ubd_driver_init(void){
 		       "ubd : Failed to start I/O thread (errno = %d) - "
 		       "falling back to synchronous I/O\n", -io_pid);
 		io_pid = -1;
-		return(0);
+		return 0;
 	}
 	err = um_request_irq(UBD_IRQ, thread_fd, IRQ_READ, ubd_intr,
 			     IRQF_DISABLED, "ubd", ubd_devs);
@@ -974,7 +974,7 @@ static int ubd_open(struct inode *inode,
 	        err = -EROFS;
 	}*/
  out:
-	return(err);
+	return err;
 }
 
 static int ubd_release(struct inode * inode, struct file * file)
@@ -984,7 +984,7 @@ static int ubd_release(struct inode * in
 
 	if(--ubd_dev->count == 0)
 		ubd_close_dev(ubd_dev);
-	return(0);
+	return 0;
 }
 
 static void cowify_bitmap(__u64 io_offset, int length, unsigned long *cow_mask,
@@ -1040,7 +1040,7 @@ static void cowify_req(struct io_thread_
 			if(ubd_test_bit(sector + i, (unsigned char *) bitmap))
 				ubd_set_bit(i, (unsigned char *)
 					    &req->sector_mask);
-                }
+		}
 	}
 	else cowify_bitmap(req->offset, req->length, &req->sector_mask,
 			   &req->cow_offset, bitmap, bitmap_offset,
@@ -1157,21 +1157,21 @@ static int ubd_ioctl(struct inode * inod
 		ubd_id.cyls = ubd_dev->size / (128 * 32 * 512);
 		if(copy_to_user((char __user *) arg, (char *) &ubd_id,
 				 sizeof(ubd_id)))
-			return(-EFAULT);
-		return(0);
+			return -EFAULT;
+		return 0;
 
 	case CDROMVOLREAD:
 		if(copy_from_user(&volume, (char __user *) arg, sizeof(volume)))
-			return(-EFAULT);
+			return -EFAULT;
 		volume.channel0 = 255;
 		volume.channel1 = 255;
 		volume.channel2 = 255;
 		volume.channel3 = 255;
 		if(copy_to_user((char __user *) arg, &volume, sizeof(volume)))
-			return(-EFAULT);
-		return(0);
+			return -EFAULT;
+		return 0;
 	}
-	return(-EINVAL);
+	return -EINVAL;
 }
 
 static int path_requires_switch(char *from_cmdline, char *from_cow, char *cow)
@@ -1213,29 +1213,29 @@ static int backing_file_mismatch(char *f
 	if(err < 0){
 		printk("Failed to get modification time of backing file "
 		       "\"%s\", err = %d\n", file, -err);
-		return(err);
+		return err;
 	}
 
 	err = os_file_size(file, &actual);
 	if(err < 0){
 		printk("Failed to get size of backing file \"%s\", "
 		       "err = %d\n", file, -err);
-		return(err);
+		return err;
 	}
 
-  	if(actual != size){
+	if(actual != size){
 		/*__u64 can be a long on AMD64 and with %lu GCC complains; so
 		 * the typecast.*/
 		printk("Size mismatch (%llu vs %llu) of COW header vs backing "
 		       "file\n", (unsigned long long) size, actual);
-		return(-EINVAL);
+		return -EINVAL;
 	}
 	if(modtime != mtime){
 		printk("mtime mismatch (%ld vs %ld) of COW header vs backing "
 		       "file\n", mtime, modtime);
-		return(-EINVAL);
+		return -EINVAL;
 	}
-	return(0);
+	return 0;
 }
 
 int read_cow_bitmap(int fd, void *buf, int offset, int len)
@@ -1244,13 +1244,13 @@ int read_cow_bitmap(int fd, void *buf, i
 
 	err = os_seek_file(fd, offset);
 	if(err < 0)
-		return(err);
+		return err;
 
-	err = os_read_file_k(fd, buf, len);
+	err = os_read_file(fd, buf, len);
 	if(err < 0)
-		return(err);
+		return err;
 
-	return(0);
+	return 0;
 }
 
 int open_ubd_file(char *file, struct openflags *openflags, int shared,
@@ -1268,14 +1268,14 @@ int open_ubd_file(char *file, struct ope
 	if (fd < 0) {
 		if ((fd == -ENOENT) && (create_cow_out != NULL))
 			*create_cow_out = 1;
-                if (!openflags->w ||
-                   ((fd != -EROFS) && (fd != -EACCES)))
+		if (!openflags->w ||
+		    ((fd != -EROFS) && (fd != -EACCES)))
 			return fd;
 		openflags->w = 0;
 		fd = os_open_file(file, *openflags, mode);
 		if (fd < 0)
 			return fd;
-        }
+	}
 
 	if(shared)
 		printk("Not locking \"%s\" on the host\n", file);
@@ -1289,7 +1289,7 @@ int open_ubd_file(char *file, struct ope
 
 	/* Successful return case! */
 	if(backing_file_out == NULL)
-		return(fd);
+		return fd;
 
 	err = read_cow_header(file_reader, &fd, &version, &backing_file, &mtime,
 			      &size, &sectorsize, &align, bitmap_offset_out);
@@ -1299,7 +1299,7 @@ int open_ubd_file(char *file, struct ope
 		goto out_close;
 	}
 	if(err)
-		return(fd);
+		return fd;
 
 	asked_switch = path_requires_switch(*backing_file_out, backing_file, file);
 
@@ -1322,7 +1322,7 @@ int open_ubd_file(char *file, struct ope
 	cow_sizes(version, size, sectorsize, align, *bitmap_offset_out,
 		  bitmap_len_out, data_offset_out);
 
-        return fd;
+	return fd;
  out_close:
 	os_close_file(fd);
 	return err;
@@ -1347,10 +1347,10 @@ int create_cow_file(char *cow_file, char
 			    bitmap_offset_out, bitmap_len_out,
 			    data_offset_out);
 	if(!err)
-		return(fd);
+		return fd;
 	os_close_file(fd);
  out:
-	return(err);
+	return err;
 }
 
 static int update_bitmap(struct io_thread_req *req)
@@ -1358,12 +1358,12 @@ static int update_bitmap(struct io_threa
 	int n;
 
 	if(req->cow_offset == -1)
-		return(0);
+		return 0;
 
 	n = os_seek_file(req->fds[1], req->cow_offset);
 	if(n < 0){
 		printk("do_io - bitmap lseek failed : err = %d\n", -n);
-		return(1);
+		return 1;
 	}
 
 	n = os_write_file_k(req->fds[1], &req->bitmap_words,
@@ -1371,10 +1371,10 @@ static int update_bitmap(struct io_threa
 	if(n != sizeof(req->bitmap_words)){
 		printk("do_io - bitmap update failed, err = %d fd = %d\n", -n,
 		       req->fds[1]);
-		return(1);
+		return 1;
 	}
 
-	return(0);
+	return 0;
 }
 
 void do_io(struct io_thread_req *req)
diff -puN arch/um/kernel/initrd.c~uml-formatting-fixes-around-os_read_write_file-callers arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~uml-formatting-fixes-around-os_read_write_file-callers
+++ a/arch/um/kernel/initrd.c
@@ -21,12 +21,20 @@ static int __init read_initrd(void)
 	long long size;
 	int err;
 
-	if(initrd == NULL) return 0;
+	if(initrd == NULL)
+		return 0;
+
 	err = os_file_size(initrd, &size);
-	if(err) return 0;
+	if(err)
+		return 0;
+
 	area = alloc_bootmem(size);
-	if(area == NULL) return 0;
-	if(load_initrd(initrd, area, size) == -1) return 0;
+	if(area == NULL)
+		return 0;
+
+	if(load_initrd(initrd, area, size) == -1)
+		return 0;
+
 	initrd_start = (unsigned long) area;
 	initrd_end = initrd_start + size;
 	return 0;
@@ -53,25 +61,15 @@ int load_initrd(char *filename, void *bu
 	fd = os_open_file(filename, of_read(OPENFLAGS()), 0);
 	if(fd < 0){
 		printk("Opening '%s' failed - err = %d\n", filename, -fd);
-		return(-1);
+		return -1;
 	}
 	n = os_read_file_k(fd, buf, size);
 	if(n != size){
 		printk("Read of %d bytes from '%s' failed, err = %d\n", size,
 		       filename, -n);
-		return(-1);
+		return -1;
 	}
 
 	os_close_file(fd);
-	return(0);
+	return 0;
 }
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/smp.c~uml-formatting-fixes-around-os_read_write_file-callers arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c~uml-formatting-fixes-around-os_read_write_file-callers
+++ a/arch/um/kernel/smp.c
@@ -89,7 +89,7 @@ static int idle_proc(void *cpup)
 
 	cpu_set(cpu, cpu_online_map);
 	default_idle();
-	return(0);
+	return 0;
 }
 
 static struct task_struct *idle_thread(int cpu)
@@ -97,8 +97,8 @@ static struct task_struct *idle_thread(i
 	struct task_struct *new_task;
 	unsigned char c;
 
-        current->thread.request.u.thread.proc = idle_proc;
-        current->thread.request.u.thread.arg = (void *) cpu;
+	current->thread.request.u.thread.proc = idle_proc;
+	current->thread.request.u.thread.arg = (void *) cpu;
 	new_task = fork_idle(cpu);
 	if(IS_ERR(new_task))
 		panic("copy_process failed in idle_thread, error = %ld",
@@ -111,7 +111,7 @@ static struct task_struct *idle_thread(i
 	CHOOSE_MODE(os_write_file_k(new_task->thread.mode.tt.switch_pipe[1], &c,
 				    sizeof(c)),
 		    ({ panic("skas mode doesn't support SMP"); }));
-	return(new_task);
+	return new_task;
 }
 
 void smp_prepare_cpus(unsigned int maxcpus)
@@ -162,13 +162,13 @@ int __cpu_up(unsigned int cpu)
 	cpu_set(cpu, smp_commenced_mask);
 	while (!cpu_isset(cpu, cpu_online_map))
 		mb();
-	return(0);
+	return 0;
 }
 
 int setup_profiling_timer(unsigned int multiplier)
 {
 	printk(KERN_INFO "setup_profiling_timer\n");
-	return(0);
+	return 0;
 }
 
 void smp_call_function_slave(int cpu);
@@ -204,7 +204,7 @@ void IPI_handler(int cpu)
 
 int hard_smp_processor_id(void)
 {
-	return(pid_to_processor_id(os_getpid()));
+	return pid_to_processor_id(os_getpid());
 }
 
 static DEFINE_SPINLOCK(call_lock);
@@ -253,14 +253,3 @@ int smp_call_function(void (*_func)(void
 }
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
