From: akpm@linux-foundation.org
Subject: - uml-arch-um-drivers-formatting.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:11 -0700
Message-ID: <200710162039.l9GKdBnd015522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933886AbXJPV21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: arch/um/drivers formatting
has been removed from the -mm tree.  Its filename was
     uml-arch-um-drivers-formatting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: arch/um/drivers formatting
From: Jeff Dike <jdike@addtoit.com>

Style fixes for the rest of the drivers.  arch/um/drivers should be pretty
CodingStyle-compliant now.

Except for the ubd driver, which will have to be treated separately.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c      |   18 ++-
 arch/um/drivers/cow_user.c       |  133 ++++++++++++++---------------
 arch/um/drivers/fd.c             |   13 +-
 arch/um/drivers/hostaudio_kern.c |  118 +++++++++++++------------
 arch/um/drivers/mconsole_user.c  |  119 +++++++++++--------------
 arch/um/drivers/mmapper_kern.c   |   64 ++++++-------
 arch/um/drivers/null.c           |    4 
 arch/um/drivers/pty.c            |   16 +--
 arch/um/drivers/xterm.c          |   12 +-
 9 files changed, 244 insertions(+), 253 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-arch-um-drivers-formatting arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/chan_user.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
@@ -82,17 +82,21 @@ int generic_console_write(int fd, const 
 		if (err)
 			goto error;
 		new = save;
-		/* The terminal becomes a bit less raw, to handle \n also as
+		/*
+		 * The terminal becomes a bit less raw, to handle \n also as
 		 * "Carriage Return", not only as "New Line". Otherwise, the new
-		 * line won't start at the first column.*/
+		 * line won't start at the first column.
+		 */
 		new.c_oflag |= OPOST;
 		CATCH_EINTR(err = tcsetattr(fd, TCSAFLUSH, &new));
 		if (err)
 			goto error;
 	}
 	err = generic_write(fd, buf, n, NULL);
-	/* Restore raw mode, in any case; we *must* ignore any error apart
-	 * EINTR, except for debug.*/
+	/*
+	 * Restore raw mode, in any case; we *must* ignore any error apart
+	 * EINTR, except for debug.
+	 */
 	if (isatty(fd))
 		CATCH_EINTR(tcsetattr(fd, TCSAFLUSH, &save));
 	return err;
@@ -167,13 +171,13 @@ static int winch_thread(void *arg)
 		exit(1);
 	}
 
-	if(ioctl(pty_fd, TIOCSCTTY, 0) < 0){
+	if (ioctl(pty_fd, TIOCSCTTY, 0) < 0) {
 		printk(UM_KERN_ERR "winch_thread : TIOCSCTTY failed on "
 		       "fd %d err = %d\n", pty_fd, errno);
 		exit(1);
 	}
 
-	if(tcsetpgrp(pty_fd, os_getpid()) < 0){
+	if (tcsetpgrp(pty_fd, os_getpid()) < 0) {
 		printk(UM_KERN_ERR "winch_thread : tcsetpgrp failed on "
 		       "fd %d err = %d\n", pty_fd, errno);
 		exit(1);
diff -puN arch/um/drivers/cow_user.c~uml-arch-um-drivers-formatting arch/um/drivers/cow_user.c
--- a/arch/um/drivers/cow_user.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/cow_user.c
@@ -1,17 +1,18 @@
-#include <stddef.h>
-#include <string.h>
-#include <errno.h>
-/* _XOPEN_SOURCE is needed for pread, but we define _GNU_SOURCE, which defines
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
+ * Licensed under the GPL
+ */
+
+/*
+ * _XOPEN_SOURCE is needed for pread, but we define _GNU_SOURCE, which defines
  * that.
  */
 #include <unistd.h>
 #include <byteswap.h>
-#include <sys/time.h>
-#include <sys/param.h>
-#include <sys/user.h>
-
-#include "os.h"
-
+#include <errno.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <asm/types.h>
 #include "cow.h"
 #include "cow_sys.h"
 
@@ -28,7 +29,8 @@ struct cow_header_v1 {
 	__s32 sectorsize;
 } __attribute__((packed));
 
-/* Define PATH_LEN_V3 as the usual value of MAXPATHLEN, just hard-code it in
+/*
+ * Define PATH_LEN_V3 as the usual value of MAXPATHLEN, just hard-code it in
  * case other systems have different values for MAXPATHLEN.
  *
  * The same must hold for V2 - we want file format compatibility, not anything
@@ -46,7 +48,8 @@ struct cow_header_v2 {
 	__s32 sectorsize;
 } __attribute__((packed));
 
-/* Changes from V2 -
+/*
+ * Changes from V2 -
  *	PATH_LEN_V3 as described above
  *	Explicitly specify field bit lengths for systems with different
  *		lengths for the usual C types.  Not sure whether char or
@@ -70,7 +73,8 @@ struct cow_header_v2 {
  *	Fixed (finally!) the rounding bug
  */
 
-/* Until Dec2005, __attribute__((packed)) was left out from the below
+/*
+ * Until Dec2005, __attribute__((packed)) was left out from the below
  * definition, leading on 64-bit systems to 4 bytes of padding after mtime, to
  * align size to 8-byte alignment.  This shifted all fields above (no padding
  * was present on 32-bit, no other padding was added).
@@ -122,7 +126,7 @@ void cow_sizes(int version, __u64 size, 
 	       int bitmap_offset, unsigned long *bitmap_len_out,
 	       int *data_offset_out)
 {
-	if(version < 3){
+	if (version < 3) {
 		*bitmap_len_out = (size + sectorsize - 1) / (8 * sectorsize);
 
 		*data_offset_out = bitmap_offset + *bitmap_len_out;
@@ -144,46 +148,46 @@ static int absolutize(char *to, int size
 	char save_cwd[256], *slash;
 	int remaining;
 
-	if(getcwd(save_cwd, sizeof(save_cwd)) == NULL) {
+	if (getcwd(save_cwd, sizeof(save_cwd)) == NULL) {
 		cow_printf("absolutize : unable to get cwd - errno = %d\n",
 			   errno);
-		return(-1);
+		return -1;
 	}
 	slash = strrchr(from, '/');
-	if(slash != NULL){
+	if (slash != NULL) {
 		*slash = '\0';
-		if(chdir(from)){
+		if (chdir(from)) {
 			*slash = '/';
 			cow_printf("absolutize : Can't cd to '%s' - "
 				   "errno = %d\n", from, errno);
-			return(-1);
+			return -1;
 		}
 		*slash = '/';
-		if(getcwd(to, size) == NULL){
+		if (getcwd(to, size) == NULL) {
 			cow_printf("absolutize : unable to get cwd of '%s' - "
 			       "errno = %d\n", from, errno);
-			return(-1);
+			return -1;
 		}
 		remaining = size - strlen(to);
-		if(strlen(slash) + 1 > remaining){
+		if (strlen(slash) + 1 > remaining) {
 			cow_printf("absolutize : unable to fit '%s' into %d "
 			       "chars\n", from, size);
-			return(-1);
+			return -1;
 		}
 		strcat(to, slash);
 	}
 	else {
-		if(strlen(save_cwd) + 1 + strlen(from) + 1 > size){
+		if (strlen(save_cwd) + 1 + strlen(from) + 1 > size) {
 			cow_printf("absolutize : unable to fit '%s' into %d "
 			       "chars\n", from, size);
-			return(-1);
+			return -1;
 		}
 		strcpy(to, save_cwd);
 		strcat(to, "/");
 		strcat(to, from);
 	}
 	chdir(save_cwd);
-	return(0);
+	return 0;
 }
 
 int write_cow_header(char *cow_file, int fd, char *backing_file,
@@ -194,22 +198,23 @@ int write_cow_header(char *cow_file, int
 	int err;
 
 	err = cow_seek_file(fd, 0);
-	if(err < 0){
+	if (err < 0) {
 		cow_printf("write_cow_header - lseek failed, err = %d\n", -err);
 		goto out;
 	}
 
 	err = -ENOMEM;
 	header = cow_malloc(sizeof(*header));
-	if(header == NULL){
-		cow_printf("write_cow_header - failed to allocate COW V3 header\n");
+	if (header == NULL) {
+		cow_printf("write_cow_header - failed to allocate COW V3 "
+			   "header\n");
 		goto out;
 	}
 	header->magic = htonl(COW_MAGIC);
 	header->version = htonl(COW_VERSION);
 
 	err = -EINVAL;
-	if(strlen(backing_file) > sizeof(header->backing_file) - 1){
+	if (strlen(backing_file) > sizeof(header->backing_file) - 1) {
 		/* Below, %zd is for a size_t value */
 		cow_printf("Backing file name \"%s\" is too long - names are "
 			   "limited to %zd characters\n", backing_file,
@@ -217,12 +222,12 @@ int write_cow_header(char *cow_file, int
 		goto out_free;
 	}
 
-	if(absolutize(header->backing_file, sizeof(header->backing_file),
+	if (absolutize(header->backing_file, sizeof(header->backing_file),
 		      backing_file))
 		goto out_free;
 
 	err = os_file_modtime(header->backing_file, &modtime);
-	if(err < 0){
+	if (err < 0) {
 		cow_printf("write_cow_header - backing file '%s' mtime "
 			   "request failed, err = %d\n", header->backing_file,
 			   -err);
@@ -230,7 +235,7 @@ int write_cow_header(char *cow_file, int
 	}
 
 	err = cow_file_size(header->backing_file, size);
-	if(err < 0){
+	if (err < 0) {
 		cow_printf("write_cow_header - couldn't get size of "
 			   "backing file '%s', err = %d\n",
 			   header->backing_file, -err);
@@ -244,7 +249,7 @@ int write_cow_header(char *cow_file, int
 	header->cow_format = COW_BITMAP;
 
 	err = cow_write_file(fd, header, sizeof(*header));
-	if(err != sizeof(*header)){
+	if (err != sizeof(*header)) {
 		cow_printf("write_cow_header - write of header to "
 			   "new COW file '%s' failed, err = %d\n", cow_file,
 			   -err);
@@ -254,14 +259,14 @@ int write_cow_header(char *cow_file, int
  out_free:
 	cow_free(header);
  out:
-	return(err);
+	return err;
 }
 
 int file_reader(__u64 offset, char *buf, int len, void *arg)
 {
 	int fd = *((int *) arg);
 
-	return(pread(fd, buf, len, offset));
+	return pread(fd, buf, len, offset);
 }
 
 /* XXX Need to sanity-check the values read from the header */
@@ -278,31 +283,29 @@ int read_cow_header(int (*reader)(__u64,
 	unsigned long version, magic;
 
 	header = cow_malloc(sizeof(*header));
-	if(header == NULL){
+	if (header == NULL) {
 	        cow_printf("read_cow_header - Failed to allocate header\n");
-		return(-ENOMEM);
+		return -ENOMEM;
 	}
 	err = -EINVAL;
 	n = (*reader)(0, (char *) header, sizeof(*header), arg);
-	if(n < offsetof(typeof(header->v1), backing_file)){
+	if (n < offsetof(typeof(header->v1), backing_file)) {
 		cow_printf("read_cow_header - short header\n");
 		goto out;
 	}
 
 	magic = header->v1.magic;
-	if(magic == COW_MAGIC) {
+	if (magic == COW_MAGIC)
 		version = header->v1.version;
-	}
-	else if(magic == ntohl(COW_MAGIC)){
+	else if (magic == ntohl(COW_MAGIC))
 		version = ntohl(header->v1.version);
-	}
 	/* No error printed because the non-COW case comes through here */
 	else goto out;
 
 	*version_out = version;
 
-	if(version == 1){
-		if(n < sizeof(header->v1)){
+	if (version == 1) {
+		if (n < sizeof(header->v1)) {
 			cow_printf("read_cow_header - failed to read V1 "
 				   "header\n");
 			goto out;
@@ -314,8 +317,8 @@ int read_cow_header(int (*reader)(__u64,
 		*align_out = *sectorsize_out;
 		file = header->v1.backing_file;
 	}
-	else if(version == 2){
-		if(n < sizeof(header->v2)){
+	else if (version == 2) {
+		if (n < sizeof(header->v2)) {
 			cow_printf("read_cow_header - failed to read V2 "
 				   "header\n");
 			goto out;
@@ -328,8 +331,8 @@ int read_cow_header(int (*reader)(__u64,
 		file = header->v2.backing_file;
 	}
 	/* This is very subtle - see above at union cow_header definition */
-	else if(version == 3 && (*((int*)header->v3.backing_file) != 0)){
-		if(n < sizeof(header->v3)){
+	else if (version == 3 && (*((int*)header->v3.backing_file) != 0)) {
+		if (n < sizeof(header->v3)) {
 			cow_printf("read_cow_header - failed to read V3 "
 				   "header\n");
 			goto out;
@@ -345,17 +348,18 @@ int read_cow_header(int (*reader)(__u64,
 		*bitmap_offset_out = ROUND_UP(sizeof(header->v3), *align_out);
 		file = header->v3.backing_file;
 	}
-	else if(version == 3){
+	else if (version == 3) {
 		cow_printf("read_cow_header - broken V3 file with"
 			   " 64-bit layout - recovering content.\n");
 
-		if(n < sizeof(header->v3_b)){
+		if (n < sizeof(header->v3_b)) {
 			cow_printf("read_cow_header - failed to read V3 "
 				   "header\n");
 			goto out;
 		}
 
-		/* this was used until Dec2005 - 64bits are needed to represent
+		/*
+		 * this was used until Dec2005 - 64bits are needed to represent
 		 * 2038+. I.e. we can safely do this truncating cast.
 		 *
 		 * Additionally, we must use ntohl() instead of ntohll(), since
@@ -381,7 +385,7 @@ int read_cow_header(int (*reader)(__u64,
 	}
 	err = -ENOMEM;
 	*backing_file_out = cow_strdup(file);
-	if(*backing_file_out == NULL){
+	if (*backing_file_out == NULL) {
 		cow_printf("read_cow_header - failed to allocate backing "
 			   "file\n");
 		goto out;
@@ -389,7 +393,7 @@ int read_cow_header(int (*reader)(__u64,
 	err = 0;
  out:
 	cow_free(header);
-	return(err);
+	return err;
 }
 
 int init_cow_file(int fd, char *cow_file, char *backing_file, int sectorsize,
@@ -402,7 +406,7 @@ int init_cow_file(int fd, char *cow_file
 
 	err = write_cow_header(cow_file, fd, backing_file, sectorsize,
 			       alignment, &size);
-	if(err)
+	if (err)
 		goto out;
 
 	*bitmap_offset_out = ROUND_UP(sizeof(struct cow_header_v3), alignment);
@@ -411,17 +415,18 @@ int init_cow_file(int fd, char *cow_file
 
 	offset = *data_offset_out + size - sizeof(zero);
 	err = cow_seek_file(fd, offset);
-	if(err < 0){
+	if (err < 0) {
 		cow_printf("cow bitmap lseek failed : err = %d\n", -err);
 		goto out;
 	}
 
-	/* does not really matter how much we write it is just to set EOF
+	/*
+	 * does not really matter how much we write it is just to set EOF
 	 * this also sets the entire COW bitmap
 	 * to zero without having to allocate it
 	 */
 	err = cow_write_file(fd, &zero, sizeof(zero));
-	if(err != sizeof(zero)){
+	if (err != sizeof(zero)) {
 		cow_printf("Write of bitmap to new COW file '%s' failed, "
 			   "err = %d\n", cow_file, -err);
 		if (err >= 0)
@@ -429,15 +434,7 @@ int init_cow_file(int fd, char *cow_file
 		goto out;
 	}
 
-	return(0);
-
+	return 0;
  out:
-	return(err);
+	return err;
 }
-
-/*
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/fd.c~uml-arch-um-drivers-formatting arch/um/drivers/fd.c
--- a/arch/um/drivers/fd.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/fd.c
@@ -1,19 +1,18 @@
-/* 
+/*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
-#include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
 #include <errno.h>
 #include <termios.h>
-#include <unistd.h>
 #include "chan_user.h"
+#include "kern_constants.h"
+#include "os.h"
 #include "um_malloc.h"
 #include "user.h"
-#include "os.h"
-#include "kern_constants.h"
 
 struct fd_chan {
 	int fd;
@@ -42,7 +41,7 @@ static void *fd_init(char *str, int devi
 	}
 
 	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
-	if(data == NULL)
+	if (data == NULL)
 		return NULL;
 
 	*data = ((struct fd_chan) { .fd  	= n,
diff -puN arch/um/drivers/hostaudio_kern.c~uml-arch-um-drivers-formatting arch/um/drivers/hostaudio_kern.c
--- a/arch/um/drivers/hostaudio_kern.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/hostaudio_kern.c
@@ -1,16 +1,14 @@
-/* 
- * Copyright (C) 2002 Steve Schmidtke 
+/*
+ * Copyright (C) 2002 Steve Schmidtke
  * Licensed under the GPL
  */
 
+#include "linux/fs.h"
 #include "linux/module.h"
-#include "linux/init.h"
 #include "linux/slab.h"
-#include "linux/fs.h"
 #include "linux/sound.h"
 #include "linux/soundcard.h"
 #include "asm/uaccess.h"
-#include "kern_util.h"
 #include "init.h"
 #include "os.h"
 
@@ -25,7 +23,8 @@ struct hostmixer_state {
 #define HOSTAUDIO_DEV_DSP "/dev/sound/dsp"
 #define HOSTAUDIO_DEV_MIXER "/dev/sound/mixer"
 
-/* Changed either at boot time or module load time.  At boot, this is
+/*
+ * Changed either at boot time or module load time.  At boot, this is
  * single-threaded; at module load, multiple modules would each have
  * their own copy of these variables.
  */
@@ -44,7 +43,7 @@ static char *mixer = HOSTAUDIO_DEV_MIXER
 static int set_dsp(char *name, int *add)
 {
 	dsp = name;
-	return(0);
+	return 0;
 }
 
 __uml_setup("dsp=", set_dsp, "dsp=<dsp device>\n" DSP_HELP);
@@ -52,7 +51,7 @@ __uml_setup("dsp=", set_dsp, "dsp=<dsp d
 static int set_mixer(char *name, int *add)
 {
 	mixer = name;
-	return(0);
+	return 0;
 }
 
 __uml_setup("mixer=", set_mixer, "mixer=<mixer device>\n" MIXER_HELP);
@@ -77,23 +76,23 @@ static ssize_t hostaudio_read(struct fil
 	int err;
 
 #ifdef DEBUG
-	printk("hostaudio: read called, count = %d\n", count);
+	printk(KERN_DEBUG "hostaudio: read called, count = %d\n", count);
 #endif
 
 	kbuf = kmalloc(count, GFP_KERNEL);
-	if(kbuf == NULL)
-		return(-ENOMEM);
+	if (kbuf == NULL)
+		return -ENOMEM;
 
 	err = os_read_file(state->fd, kbuf, count);
-	if(err < 0)
+	if (err < 0)
 		goto out;
 
-	if(copy_to_user(buffer, kbuf, err))
+	if (copy_to_user(buffer, kbuf, err))
 		err = -EFAULT;
 
 out:
 	kfree(kbuf);
-	return(err);
+	return err;
 }
 
 static ssize_t hostaudio_write(struct file *file, const char __user *buffer,
@@ -104,40 +103,40 @@ static ssize_t hostaudio_write(struct fi
 	int err;
 
 #ifdef DEBUG
-	printk("hostaudio: write called, count = %d\n", count);
+	printk(KERN_DEBUG "hostaudio: write called, count = %d\n", count);
 #endif
 
 	kbuf = kmalloc(count, GFP_KERNEL);
-	if(kbuf == NULL)
-		return(-ENOMEM);
+	if (kbuf == NULL)
+		return -ENOMEM;
 
 	err = -EFAULT;
-	if(copy_from_user(kbuf, buffer, count))
+	if (copy_from_user(kbuf, buffer, count))
 		goto out;
 
 	err = os_write_file(state->fd, kbuf, count);
-	if(err < 0)
+	if (err < 0)
 		goto out;
 	*ppos += err;
 
  out:
 	kfree(kbuf);
-	return(err);
+	return err;
 }
 
-static unsigned int hostaudio_poll(struct file *file, 
+static unsigned int hostaudio_poll(struct file *file,
 				   struct poll_table_struct *wait)
 {
 	unsigned int mask = 0;
 
 #ifdef DEBUG
-	printk("hostaudio: poll called (unimplemented)\n");
+	printk(KERN_DEBUG "hostaudio: poll called (unimplemented)\n");
 #endif
 
-	return(mask);
+	return mask;
 }
 
-static int hostaudio_ioctl(struct inode *inode, struct file *file, 
+static int hostaudio_ioctl(struct inode *inode, struct file *file,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct hostaudio_state *state = file->private_data;
@@ -145,7 +144,7 @@ static int hostaudio_ioctl(struct inode 
 	int err;
 
 #ifdef DEBUG
-	printk("hostaudio: ioctl called, cmd = %u\n", cmd);
+	printk(KERN_DEBUG "hostaudio: ioctl called, cmd = %u\n", cmd);
 #endif
 	switch(cmd){
 	case SNDCTL_DSP_SPEED:
@@ -154,8 +153,8 @@ static int hostaudio_ioctl(struct inode 
 	case SNDCTL_DSP_CHANNELS:
 	case SNDCTL_DSP_SUBDIVIDE:
 	case SNDCTL_DSP_SETFRAGMENT:
-		if(get_user(data, (int __user *) arg))
-			return(-EFAULT);
+		if (get_user(data, (int __user *) arg))
+			return EFAULT;
 		break;
 	default:
 		break;
@@ -170,14 +169,14 @@ static int hostaudio_ioctl(struct inode 
 	case SNDCTL_DSP_CHANNELS:
 	case SNDCTL_DSP_SUBDIVIDE:
 	case SNDCTL_DSP_SETFRAGMENT:
-		if(put_user(data, (int __user *) arg))
-			return(-EFAULT);
+		if (put_user(data, (int __user *) arg))
+			return -EFAULT;
 		break;
 	default:
 		break;
 	}
 
-	return(err);
+	return err;
 }
 
 static int hostaudio_open(struct inode *inode, struct file *file)
@@ -187,24 +186,26 @@ static int hostaudio_open(struct inode *
 	int ret;
 
 #ifdef DEBUG
-	printk("hostaudio: open called (host: %s)\n", dsp);
+	printk(KERN_DEBUG "hostaudio: open called (host: %s)\n", dsp);
 #endif
 
 	state = kmalloc(sizeof(struct hostaudio_state), GFP_KERNEL);
-	if(state == NULL)
-		return(-ENOMEM);
+	if (state == NULL)
+		return -ENOMEM;
 
-	if(file->f_mode & FMODE_READ) r = 1;
-	if(file->f_mode & FMODE_WRITE) w = 1;
+	if (file->f_mode & FMODE_READ)
+		r = 1;
+	if (file->f_mode & FMODE_WRITE)
+		w = 1;
 
 	ret = os_open_file(dsp, of_set_rw(OPENFLAGS(), r, w), 0);
-	if(ret < 0){
+	if (ret < 0) {
 		kfree(state);
-		return(ret);
+		return ret;
 	}
 	state->fd = ret;
 	file->private_data = state;
-	return(0);
+	return 0;
 }
 
 static int hostaudio_release(struct inode *inode, struct file *file)
@@ -212,26 +213,26 @@ static int hostaudio_release(struct inod
 	struct hostaudio_state *state = file->private_data;
 
 #ifdef DEBUG
-	printk("hostaudio: release called\n");
+	printk(KERN_DEBUG "hostaudio: release called\n");
 #endif
 	os_close_file(state->fd);
 	kfree(state);
 
-	return(0);
+	return 0;
 }
 
 /* /dev/mixer file operations */
 
-static int hostmixer_ioctl_mixdev(struct inode *inode, struct file *file, 
+static int hostmixer_ioctl_mixdev(struct inode *inode, struct file *file,
 				  unsigned int cmd, unsigned long arg)
 {
 	struct hostmixer_state *state = file->private_data;
 
 #ifdef DEBUG
-	printk("hostmixer: ioctl called\n");
+	printk(KERN_DEBUG "hostmixer: ioctl called\n");
 #endif
 
-	return(os_ioctl_generic(state->fd, cmd, arg));
+	return os_ioctl_generic(state->fd, cmd, arg);
 }
 
 static int hostmixer_open_mixdev(struct inode *inode, struct file *file)
@@ -241,26 +242,29 @@ static int hostmixer_open_mixdev(struct 
 	int ret;
 
 #ifdef DEBUG
-	printk("hostmixer: open called (host: %s)\n", mixer);
+	printk(KERN_DEBUG "hostmixer: open called (host: %s)\n", mixer);
 #endif
 
 	state = kmalloc(sizeof(struct hostmixer_state), GFP_KERNEL);
-	if(state == NULL) return(-ENOMEM);
+	if (state == NULL)
+		return -ENOMEM;
 
-	if(file->f_mode & FMODE_READ) r = 1;
-	if(file->f_mode & FMODE_WRITE) w = 1;
+	if (file->f_mode & FMODE_READ)
+		r = 1;
+	if (file->f_mode & FMODE_WRITE)
+		w = 1;
 
 	ret = os_open_file(mixer, of_set_rw(OPENFLAGS(), r, w), 0);
-        
-	if(ret < 0){
-		printk("hostaudio_open_mixdev failed to open '%s', err = %d\n",
-		       dsp, -ret);
+
+	if (ret < 0) {
+		printk(KERN_ERR "hostaudio_open_mixdev failed to open '%s', "
+		       "err = %d\n", dsp, -ret);
 		kfree(state);
-		return(ret);
+		return ret;
 	}
 
 	file->private_data = state;
-	return(0);
+	return 0;
 }
 
 static int hostmixer_release(struct inode *inode, struct file *file)
@@ -268,13 +272,13 @@ static int hostmixer_release(struct inod
 	struct hostmixer_state *state = file->private_data;
 
 #ifdef DEBUG
-	printk("hostmixer: release called\n");
+	printk(KERN_DEBUG "hostmixer: release called\n");
 #endif
 
 	os_close_file(state->fd);
 	kfree(state);
 
-	return(0);
+	return 0;
 }
 
 /* kernel module operations */
@@ -314,13 +318,13 @@ static int __init hostaudio_init_module(
 	       dsp, mixer);
 
 	module_data.dev_audio = register_sound_dsp(&hostaudio_fops, -1);
-	if(module_data.dev_audio < 0){
+	if (module_data.dev_audio < 0) {
 		printk(KERN_ERR "hostaudio: couldn't register DSP device!\n");
 		return -ENODEV;
 	}
 
 	module_data.dev_mixer = register_sound_mixer(&hostmixer_fops, -1);
-	if(module_data.dev_mixer < 0){
+	if (module_data.dev_mixer < 0) {
 		printk(KERN_ERR "hostmixer: couldn't register mixer "
 		       "device!\n");
 		unregister_sound_dsp(module_data.dev_audio);
diff -puN arch/um/drivers/mconsole_user.c~uml-arch-um-drivers-formatting arch/um/drivers/mconsole_user.c
--- a/arch/um/drivers/mconsole_user.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/mconsole_user.c
@@ -1,25 +1,22 @@
 /*
  * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
- * Copyright (C) 2001 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stdio.h>
-#include <stdlib.h>
 #include <errno.h>
-#include <signal.h>
+#include <string.h>
+#include <unistd.h>
 #include <sys/socket.h>
-#include <sys/types.h>
 #include <sys/uio.h>
 #include <sys/un.h>
-#include <unistd.h>
-#include "user.h"
-#include "sysdep/ptrace.h"
+#include "kern_constants.h"
 #include "mconsole.h"
-#include "os.h"
+#include "user.h"
 
 static struct mconsole_command commands[] = {
-	/* With uts namespaces, uts information becomes process-specific, so
+	/*
+	 * With uts namespaces, uts information becomes process-specific, so
 	 * we need a process context.  If we try handling this in interrupt
 	 * context, we may hit an exiting process without a valid uts
 	 * namespace.
@@ -36,7 +33,7 @@ static struct mconsole_command commands[
 	{ "go", mconsole_go, MCONSOLE_INTR },
 	{ "log", mconsole_log, MCONSOLE_INTR },
 	{ "proc", mconsole_proc, MCONSOLE_PROC },
-        { "stack", mconsole_stack, MCONSOLE_INTR },
+	{ "stack", mconsole_stack, MCONSOLE_INTR },
 };
 
 /* Initialized in mconsole_init, which is an initcall */
@@ -44,21 +41,21 @@ char mconsole_socket_name[256];
 
 int mconsole_reply_v0(struct mc_request *req, char *reply)
 {
-        struct iovec iov;
-        struct msghdr msg;
+	struct iovec iov;
+	struct msghdr msg;
 
-        iov.iov_base = reply;
-        iov.iov_len = strlen(reply);
+	iov.iov_base = reply;
+	iov.iov_len = strlen(reply);
 
-        msg.msg_name = &(req->origin);
-        msg.msg_namelen = req->originlen;
-        msg.msg_iov = &iov;
-        msg.msg_iovlen = 1;
-        msg.msg_control = NULL;
-        msg.msg_controllen = 0;
-        msg.msg_flags = 0;
+	msg.msg_name = &(req->origin);
+	msg.msg_namelen = req->originlen;
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags = 0;
 
-        return sendmsg(req->originating_fd, &msg, 0);
+	return sendmsg(req->originating_fd, &msg, 0);
 }
 
 static struct mconsole_command *mconsole_parse(struct mc_request *req)
@@ -66,10 +63,10 @@ static struct mconsole_command *mconsole
 	struct mconsole_command *cmd;
 	int i;
 
-	for(i = 0; i < ARRAY_SIZE(commands); i++){
+	for (i = 0; i < ARRAY_SIZE(commands); i++) {
 		cmd = &commands[i];
-		if(!strncmp(req->request.data, cmd->command, 
-			    strlen(cmd->command))){
+		if (!strncmp(req->request.data, cmd->command,
+			    strlen(cmd->command))) {
 			return cmd;
 		}
 	}
@@ -94,9 +91,9 @@ int mconsole_get_request(int fd, struct 
 
 	req->originating_fd = fd;
 
-	if(req->request.magic != MCONSOLE_MAGIC){
+	if (req->request.magic != MCONSOLE_MAGIC) {
 		/* Unversioned request */
-		len = MIN(sizeof(req->request.data) - 1, 
+		len = MIN(sizeof(req->request.data) - 1,
 			  strlen((char *) &req->request));
 		memmove(req->request.data, &req->request, len);
 		req->request.data[len] = '\0';
@@ -107,32 +104,33 @@ int mconsole_get_request(int fd, struct 
 
 		mconsole_reply_v0(req, "ERR Version 0 mconsole clients are "
 				  "not supported by this driver");
-		return(0);
+		return 0;
 	}
 
-	if(req->request.len >= MCONSOLE_MAX_DATA){
+	if (req->request.len >= MCONSOLE_MAX_DATA) {
 		mconsole_reply(req, "Request too large", 1, 0);
-		return(0);
+		return 0;
 	}
-	if(req->request.version != MCONSOLE_VERSION){
-		mconsole_reply(req, "This driver only supports version " 
-                               STRING(MCONSOLE_VERSION) " clients", 1, 0);
+	if (req->request.version != MCONSOLE_VERSION) {
+		mconsole_reply(req, "This driver only supports version "
+			       STRING(MCONSOLE_VERSION) " clients", 1, 0);
 	}
-	
+
 	req->request.data[req->request.len] = '\0';
 	req->cmd = mconsole_parse(req);
-	if(req->cmd == NULL){
+	if (req->cmd == NULL) {
 		mconsole_reply(req, "Unknown command", 1, 0);
-		return(0);
+		return 0;
 	}
 
-	return(1);
+	return 1;
 }
 
 int mconsole_reply_len(struct mc_request *req, const char *str, int total,
 		       int err, int more)
 {
-	/* XXX This is a stack consumption problem.  It'd be nice to
+	/*
+	 * XXX This is a stack consumption problem.  It'd be nice to
 	 * make it global and serialize access to it, but there are a
 	 * ton of callers to this function.
 	 */
@@ -147,7 +145,7 @@ int mconsole_reply_len(struct mc_request
 
 		len = MIN(total, MCONSOLE_MAX_DATA - 1);
 
-		if(len == total) reply.more = more;
+		if (len == total) reply.more = more;
 		else reply.more = 1;
 
 		memcpy(reply.data, str, len);
@@ -161,9 +159,10 @@ int mconsole_reply_len(struct mc_request
 		n = sendto(req->originating_fd, &reply, len, 0,
 			   (struct sockaddr *) req->origin, req->originlen);
 
-		if(n < 0) return(-errno);
-	} while(total > 0);
-	return(0);
+		if (n < 0)
+			return -errno;
+	} while (total > 0);
+	return 0;
 }
 
 int mconsole_reply(struct mc_request *req, const char *str, int err, int more)
@@ -187,18 +186,18 @@ int mconsole_notify(char *sock_name, int
 	int n, err = 0;
 
 	lock_notify();
-	if(notify_sock < 0){
+	if (notify_sock < 0) {
 		notify_sock = socket(PF_UNIX, SOCK_DGRAM, 0);
-		if(notify_sock < 0){
+		if (notify_sock < 0) {
 			err = -errno;
-			printk("mconsole_notify - socket failed, errno = %d\n",
-			       err);
+			printk(UM_KERN_ERR "mconsole_notify - socket failed, "
+			       "errno = %d\n", errno);
 		}
 	}
 	unlock_notify();
-	
-	if(err)
-		return(err);
+
+	if (err)
+		return err;
 
 	target.sun_family = AF_UNIX;
 	strcpy(target.sun_path, sock_name);
@@ -212,22 +211,12 @@ int mconsole_notify(char *sock_name, int
 
 	err = 0;
 	len = sizeof(packet) + packet.len - sizeof(packet.data);
-	n = sendto(notify_sock, &packet, len, 0, (struct sockaddr *) &target, 
+	n = sendto(notify_sock, &packet, len, 0, (struct sockaddr *) &target,
 		   sizeof(target));
-	if(n < 0){
+	if (n < 0) {
 		err = -errno;
-		printk("mconsole_notify - sendto failed, errno = %d\n", errno);
+		printk(UM_KERN_ERR "mconsole_notify - sendto failed, "
+		       "errno = %d\n", errno);
 	}
-	return(err);
+	return err;
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
diff -puN arch/um/drivers/mmapper_kern.c~uml-arch-um-drivers-formatting arch/um/drivers/mmapper_kern.c
--- a/arch/um/drivers/mmapper_kern.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/mmapper_kern.c
@@ -9,27 +9,29 @@
  *
  */
 
-#include <linux/init.h> 
-#include <linux/module.h>
-#include <linux/mm.h> 
+#include <linux/stddef.h>
+#include <linux/types.h>
 #include <linux/fs.h>
+#include <linux/init.h>
 #include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mm.h>
 #include <asm/uaccess.h>
 #include "mem_user.h"
- 
+
 /* These are set in mmapper_init, which is called at boot time */
 static unsigned long mmapper_size;
-static unsigned long p_buf = 0;
-static char *v_buf = NULL;
+static unsigned long p_buf;
+static char *v_buf;
 
-static ssize_t
-mmapper_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+static ssize_t mmapper_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
 {
 	return simple_read_from_buffer(buf, count, ppos, v_buf, mmapper_size);
 }
 
-static ssize_t
-mmapper_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t mmapper_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
 {
 	if (*ppos > mmapper_size)
 		return -EINVAL;
@@ -39,48 +41,46 @@ mmapper_write(struct file *file, const c
 
 	if (copy_from_user(&v_buf[*ppos], buf, count))
 		return -EFAULT;
-	
+
 	return count;
 }
 
-static int 
-mmapper_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	 unsigned long arg)
+static int mmapper_ioctl(struct inode *inode, struct file *file,
+			 unsigned int cmd, unsigned long arg)
 {
-	return(-ENOIOCTLCMD);
+	return -ENOIOCTLCMD;
 }
 
-static int 
-mmapper_mmap(struct file *file, struct vm_area_struct * vma)
+static int mmapper_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret = -EINVAL;
 	int size;
 
 	if (vma->vm_pgoff != 0)
 		goto out;
-	
+
 	size = vma->vm_end - vma->vm_start;
-	if(size > mmapper_size) return(-EFAULT);
+	if (size > mmapper_size)
+		return -EFAULT;
 
-	/* XXX A comment above remap_pfn_range says it should only be
+	/*
+	 * XXX A comment above remap_pfn_range says it should only be
 	 * called when the mm semaphore is held
 	 */
 	if (remap_pfn_range(vma, vma->vm_start, p_buf >> PAGE_SHIFT, size,
-			     vma->vm_page_prot))
+			    vma->vm_page_prot))
 		goto out;
 	ret = 0;
 out:
 	return ret;
 }
 
-static int
-mmapper_open(struct inode *inode, struct file *file)
+static int mmapper_open(struct inode *inode, struct file *file)
 {
 	return 0;
 }
 
-static int 
-mmapper_release(struct inode *inode, struct file *file)
+static int mmapper_release(struct inode *inode, struct file *file)
 {
 	return 0;
 }
@@ -95,7 +95,9 @@ static const struct file_operations mmap
 	.release	= mmapper_release,
 };
 
-/* No locking needed - only used (and modified) by below initcall and exitcall. */
+/*
+ * No locking needed - only used (and modified) by below initcall and exitcall.
+ */
 static struct miscdevice mmapper_dev = {
 	.minor		= MISC_DYNAMIC_MINOR,
 	.name		= "mmapper",
@@ -109,13 +111,13 @@ static int __init mmapper_init(void)
 	printk(KERN_INFO "Mapper v0.1\n");
 
 	v_buf = (char *) find_iomem("mmapper", &mmapper_size);
-	if(mmapper_size == 0){
+	if (mmapper_size == 0) {
 		printk(KERN_ERR "mmapper_init - find_iomem failed\n");
 		goto out;
 	}
 
 	err = misc_register(&mmapper_dev);
-	if(err){
+	if (err) {
 		printk(KERN_ERR "mmapper - misc_register failed, err = %d\n",
 		       err);
 		goto out;
@@ -136,9 +138,3 @@ module_exit(mmapper_exit);
 
 MODULE_AUTHOR("Greg Lonnon <glonnon@ridgerun.com>");
 MODULE_DESCRIPTION("DSPLinux simulator mmapper driver");
-/*
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/null.c~uml-arch-um-drivers-formatting arch/um/drivers/null.c
--- a/arch/um/drivers/null.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/null.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
@@ -6,8 +6,8 @@
 #include <stddef.h>
 #include <errno.h>
 #include <fcntl.h>
-#include "os.h"
 #include "chan_user.h"
+#include "os.h"
 
 /* This address is used only as a unique identifer */
 static int null_chan;
diff -puN arch/um/drivers/pty.c~uml-arch-um-drivers-formatting arch/um/drivers/pty.c
--- a/arch/um/drivers/pty.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/pty.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
@@ -6,16 +6,16 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <string.h>
-#include <fcntl.h>
 #include <errno.h>
+#include <fcntl.h>
+#include <string.h>
 #include <termios.h>
 #include <sys/stat.h>
 #include "chan_user.h"
-#include "os.h"
-#include "user.h"
 #include "kern_constants.h"
+#include "os.h"
 #include "um_malloc.h"
+#include "user.h"
 
 struct pty_chan {
 	void (*announce)(char *dev_name, int dev);
@@ -33,7 +33,7 @@ static void *pty_chan_init(char *str, in
 	if (data == NULL)
 		return NULL;
 
-	*data = ((struct pty_chan) { .announce  	= opts->announce, 
+	*data = ((struct pty_chan) { .announce  	= opts->announce,
 				     .dev  		= device,
 				     .raw  		= opts->raw });
 	return data;
@@ -101,7 +101,7 @@ static int getmaster(char *line)
 				*tp = 't';
 				err = access(line, R_OK | W_OK);
 				*tp = 'p';
-				if(!err)
+				if (!err)
 					return master;
 				close(master);
 			}
@@ -130,7 +130,7 @@ static int pty_open(int input, int outpu
 			return err;
 		}
 	}
-	
+
 	if (data->announce)
 		(*data->announce)(dev, data->dev);
 
diff -puN arch/um/drivers/xterm.c~uml-arch-um-drivers-formatting arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~uml-arch-um-drivers-formatting
+++ a/arch/um/drivers/xterm.c
@@ -1,11 +1,11 @@
-/* 
+/*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
@@ -96,8 +96,10 @@ static int xterm_open(int input, int out
 	if (access(argv[4], X_OK) < 0)
 		argv[4] = "port-helper";
 
-	/* Check that DISPLAY is set, this doesn't guarantee the xterm
-	 * will work but w/o it we can be pretty sure it won't. */
+	/*
+	 * Check that DISPLAY is set, this doesn't guarantee the xterm
+	 * will work but w/o it we can be pretty sure it won't.
+	 */
 	if (getenv("DISPLAY") == NULL) {
 		printk(UM_KERN_ERR "xterm_open: $DISPLAY not set.\n");
 		return -ENODEV;
@@ -196,7 +198,7 @@ static int xterm_open(int input, int out
 static void xterm_close(int fd, void *d)
 {
 	struct xterm_chan *data = d;
-	
+
 	if (data->pid != -1)
 		os_kill_process(data->pid, 1);
 	data->pid = -1;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
