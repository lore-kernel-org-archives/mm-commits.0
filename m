From: akpm@linux-foundation.org
Subject: - drivers-char-nvramc-codingstyle-fixes.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:30 -0800
Message-ID: <200812291919.mBTJJUuO031701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbYL2TUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:20:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     drivers/char/nvram.c: CodingStyle fixes
has been removed from the -mm tree.  Its filename was
     drivers-char-nvramc-codingstyle-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/nvram.c: CodingStyle fixes
From: Wim Van Sebroeck <wim@iguana.be>

Bring drivers/char/nvram.c in line with the Coding Style.

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nvram.c |  126 ++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 74 deletions(-)

diff -puN drivers/char/nvram.c~drivers-char-nvramc-codingstyle-fixes drivers/char/nvram.c
--- a/drivers/char/nvram.c~drivers-char-nvramc-codingstyle-fixes
+++ a/drivers/char/nvram.c
@@ -46,7 +46,7 @@
 /* select machine configuration */
 #if defined(CONFIG_ATARI)
 #  define MACH ATARI
-#elif defined(__i386__) || defined(__x86_64__) || defined(__arm__)  /* and others?? */
+#elif defined(__i386__) || defined(__x86_64__) || defined(__arm__)  /* and ?? */
 #  define MACH PC
 #else
 #  error Cannot build nvram driver for this machine configuration.
@@ -107,9 +107,9 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static DEFINE_SPINLOCK(nvram_state_lock);
@@ -123,7 +123,7 @@ static void mach_set_checksum(void);
 
 #ifdef CONFIG_PROC_FS
 static int mach_proc_infos(unsigned char *contents, char *buffer, int *len,
-    off_t *begin, off_t offset, int size);
+					off_t *begin, off_t offset, int size);
 #endif
 
 /*
@@ -133,18 +133,17 @@ static int mach_proc_infos(unsigned char
  *
  * It is worth noting that these functions all access bytes of general
  * purpose memory in the NVRAM - that is to say, they all add the
- * NVRAM_FIRST_BYTE offset.  Pass them offsets into NVRAM as if you did not 
+ * NVRAM_FIRST_BYTE offset.  Pass them offsets into NVRAM as if you did not
  * know about the RTC cruft.
  */
 
-unsigned char
-__nvram_read_byte(int i)
+unsigned char __nvram_read_byte(int i)
 {
 	return CMOS_READ(NVRAM_FIRST_BYTE + i);
 }
+EXPORT_SYMBOL(__nvram_read_byte);
 
-unsigned char
-nvram_read_byte(int i)
+unsigned char nvram_read_byte(int i)
 {
 	unsigned long flags;
 	unsigned char c;
@@ -154,16 +153,16 @@ nvram_read_byte(int i)
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return c;
 }
+EXPORT_SYMBOL(nvram_read_byte);
 
 /* This races nicely with trying to read with checksum checking (nvram_read) */
-void
-__nvram_write_byte(unsigned char c, int i)
+void __nvram_write_byte(unsigned char c, int i)
 {
 	CMOS_WRITE(c, NVRAM_FIRST_BYTE + i);
 }
+EXPORT_SYMBOL(__nvram_write_byte);
 
-void
-nvram_write_byte(unsigned char c, int i)
+void nvram_write_byte(unsigned char c, int i)
 {
 	unsigned long flags;
 
@@ -171,15 +170,15 @@ nvram_write_byte(unsigned char c, int i)
 	__nvram_write_byte(c, i);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 }
+EXPORT_SYMBOL(nvram_write_byte);
 
-int
-__nvram_check_checksum(void)
+int __nvram_check_checksum(void)
 {
 	return mach_check_checksum();
 }
+EXPORT_SYMBOL(__nvram_check_checksum);
 
-int
-nvram_check_checksum(void)
+int nvram_check_checksum(void)
 {
 	unsigned long flags;
 	int rv;
@@ -189,16 +188,15 @@ nvram_check_checksum(void)
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return rv;
 }
+EXPORT_SYMBOL(nvram_check_checksum);
 
-static void
-__nvram_set_checksum(void)
+static void __nvram_set_checksum(void)
 {
 	mach_set_checksum();
 }
 
 #if 0
-void
-nvram_set_checksum(void)
+void nvram_set_checksum(void)
 {
 	unsigned long flags;
 
@@ -212,7 +210,7 @@ nvram_set_checksum(void)
  * The are the file operation function for user access to /dev/nvram
  */
 
-static loff_t nvram_llseek(struct file *file,loff_t offset, int origin )
+static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
 	lock_kernel();
 	switch (origin) {
@@ -230,8 +228,8 @@ static loff_t nvram_llseek(struct file *
 	return (offset >= 0) ? (file->f_pos = offset) : -EINVAL;
 }
 
-static ssize_t
-nvram_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+static ssize_t nvram_read(struct file *file, char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	unsigned char contents[NVRAM_BYTES];
 	unsigned i = *ppos;
@@ -254,13 +252,13 @@ nvram_read(struct file *file, char __use
 
 	return tmp - contents;
 
-      checksum_err:
+checksum_err:
 	spin_unlock_irq(&rtc_lock);
 	return -EIO;
 }
 
-static ssize_t
-nvram_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t nvram_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	unsigned char contents[NVRAM_BYTES];
 	unsigned i = *ppos;
@@ -287,14 +285,13 @@ nvram_write(struct file *file, const cha
 
 	return tmp - contents;
 
-      checksum_err:
+checksum_err:
 	spin_unlock_irq(&rtc_lock);
 	return -EIO;
 }
 
-static int
-nvram_ioctl(struct inode *inode, struct file *file,
-    unsigned int cmd, unsigned long arg)
+static int nvram_ioctl(struct inode *inode, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int i;
 
@@ -315,7 +312,7 @@ nvram_ioctl(struct inode *inode, struct 
 		return 0;
 
 	case NVRAM_SETCKS:
-		/* just set checksum, contents unchanged (maybe useful after 
+		/* just set checksum, contents unchanged (maybe useful after
 		 * checksum garbaged somehow...) */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
@@ -330,8 +327,7 @@ nvram_ioctl(struct inode *inode, struct 
 	}
 }
 
-static int
-nvram_open(struct inode *inode, struct file *file)
+static int nvram_open(struct inode *inode, struct file *file)
 {
 	lock_kernel();
 	spin_lock(&nvram_state_lock);
@@ -356,8 +352,7 @@ nvram_open(struct inode *inode, struct f
 	return 0;
 }
 
-static int
-nvram_release(struct inode *inode, struct file *file)
+static int nvram_release(struct inode *inode, struct file *file)
 {
 	spin_lock(&nvram_state_lock);
 
@@ -375,17 +370,15 @@ nvram_release(struct inode *inode, struc
 }
 
 #ifndef CONFIG_PROC_FS
-static int
-nvram_read_proc(char *buffer, char **start, off_t offset,
-    int size, int *eof, void *data)
+static int nvram_read_proc(char *buffer, char **start, off_t offset,
+						int size, int *eof, void *data)
 {
 	return 0;
 }
 #else
 
-static int
-nvram_read_proc(char *buffer, char **start, off_t offset,
-    int size, int *eof, void *data)
+static int nvram_read_proc(char *buffer, char **start, off_t offset,
+						int size, int *eof, void *data)
 {
 	unsigned char contents[NVRAM_BYTES];
 	int i, len = 0;
@@ -409,14 +402,14 @@ nvram_read_proc(char *buffer, char **sta
  * this like that... */
 #define PRINT_PROC(fmt,args...)					\
 	do {							\
-		*len += sprintf(buffer+*len, fmt, ##args);	\
+		*len += sprintf(buffer + *len, fmt, ##args);	\
 		if (*begin + *len > offset + size)		\
 			return 0;				\
 		if (*begin + *len < offset) {			\
 			*begin += *len;				\
 			*len = 0;				\
 		}						\
-	} while(0)
+	} while (0)
 
 #endif /* CONFIG_PROC_FS */
 
@@ -436,8 +429,7 @@ static struct miscdevice nvram_dev = {
 	&nvram_fops
 };
 
-static int __init
-nvram_init(void)
+static int __init nvram_init(void)
 {
 	int ret;
 
@@ -459,15 +451,14 @@ nvram_init(void)
 	}
 	ret = 0;
 	printk(KERN_INFO "Non-volatile memory driver v" NVRAM_VERSION "\n");
-      out:
+out:
 	return ret;
-      outmisc:
+outmisc:
 	misc_deregister(&nvram_dev);
 	goto out;
 }
 
-static void __exit
-nvram_cleanup_module(void)
+static void __exit nvram_cleanup_module(void)
 {
 	remove_proc_entry("driver/nvram", NULL);
 	misc_deregister(&nvram_dev);
@@ -482,8 +473,7 @@ module_exit(nvram_cleanup_module);
 
 #if MACH == PC
 
-static int
-pc_check_checksum(void)
+static int pc_check_checksum(void)
 {
 	int i;
 	unsigned short sum = 0;
@@ -493,11 +483,10 @@ pc_check_checksum(void)
 		sum += __nvram_read_byte(i);
 	expect = __nvram_read_byte(PC_CKS_LOC)<<8 |
 	    __nvram_read_byte(PC_CKS_LOC+1);
-	return ((sum & 0xffff) == expect);
+	return (sum & 0xffff) == expect;
 }
 
-static void
-pc_set_checksum(void)
+static void pc_set_checksum(void)
 {
 	int i;
 	unsigned short sum = 0;
@@ -522,9 +511,8 @@ static char *gfx_types[] = {
 	"monochrome",
 };
 
-static int
-pc_proc_infos(unsigned char *nvram, char *buffer, int *len,
-    off_t *begin, off_t offset, int size)
+static int pc_proc_infos(unsigned char *nvram, char *buffer, int *len,
+					off_t *begin, off_t offset, int size)
 {
 	int checksum;
 	int type;
@@ -590,20 +578,18 @@ pc_proc_infos(unsigned char *nvram, char
 
 #if MACH == ATARI
 
-static int
-atari_check_checksum(void)
+static int atari_check_checksum(void)
 {
 	int i;
 	unsigned char sum = 0;
 
 	for (i = ATARI_CKS_RANGE_START; i <= ATARI_CKS_RANGE_END; ++i)
 		sum += __nvram_read_byte(i);
-	return (__nvram_read_byte(ATARI_CKS_LOC) == (~sum & 0xff) &&
-	    __nvram_read_byte(ATARI_CKS_LOC + 1) == (sum & 0xff));
+	return (__nvram_read_byte(ATARI_CKS_LOC) == (~sum & 0xff)) &&
+	    (__nvram_read_byte(ATARI_CKS_LOC + 1) == (sum & 0xff));
 }
 
-static void
-atari_set_checksum(void)
+static void atari_set_checksum(void)
 {
 	int i;
 	unsigned char sum = 0;
@@ -654,9 +640,8 @@ static char *colors[] = {
 	"2", "4", "16", "256", "65536", "??", "??", "??"
 };
 
-static int
-atari_proc_infos(unsigned char *nvram, char *buffer, int *len,
-    off_t *begin, off_t offset, int size)
+static int atari_proc_infos(unsigned char *nvram, char *buffer, int *len,
+					off_t *begin, off_t offset, int size)
 {
 	int checksum = nvram_check_checksum();
 	int i;
@@ -725,11 +710,4 @@ atari_proc_infos(unsigned char *nvram, c
 #endif /* MACH == ATARI */
 
 MODULE_LICENSE("GPL");
