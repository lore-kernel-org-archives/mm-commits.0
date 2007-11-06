From: akpm@linux-foundation.org
Subject: + uml-const-and-other-tidying.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:29:09 -0800
Message-ID: <200711060229.lA62T97U031842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066AbXKFC3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:29:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@linux.intel.com


The patch titled
     uml: const and other tidying
has been added to the -mm tree.  Its filename is
     uml-const-and-other-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: const and other tidying
From: WANG Cong <xiyou.wangcong@gmail.com>

This patch also does some improvements for uml code.  Improvements include
dropping unnecessary cast, killing some unnecessary code and still some
constifying for pointers etc..

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c             |    6 +++---
 arch/um/include/kern_util.h            |    2 +-
 arch/um/kernel/mem.c                   |    2 +-
 arch/um/kernel/process.c               |    4 +---
 arch/um/os-Linux/drivers/tuntap_user.c |    2 +-
 arch/um/os-Linux/mem.c                 |    7 ++++---
 arch/um/os-Linux/sigio.c               |    2 +-
 7 files changed, 12 insertions(+), 13 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-const-and-other-tidying arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-const-and-other-tidying
+++ a/arch/um/drivers/ubd_kern.c
@@ -229,7 +229,7 @@ static int proc_ide_read_media(char *pag
 	return len;
 }
 
-static void make_ide_entries(char *dev_name)
+static void make_ide_entries(const char *dev_name)
 {
 	struct proc_dir_entry *dir, *ent;
 	char name[64];
@@ -244,7 +244,7 @@ static void make_ide_entries(char *dev_n
 	ent->data = NULL;
 	ent->read_proc = proc_ide_read_media;
 	ent->write_proc = NULL;
-	sprintf(name,"ide0/%s", dev_name);
+	snprintf(name, sizeof(name), "ide0/%s", dev_name);
 	proc_symlink(dev_name, proc_ide_root, name);
 }
 
@@ -443,7 +443,7 @@ __uml_help(ubd_setup,
 "    cluster filesystem and inappropriate at almost all other times.\n\n"
 );
 
-static int udb_setup(char *str)
+static int udb_setup(const char *str)
 {
 	printk("udb%s specified on command line is almost certainly a ubd -> "
 	       "udb TYPO\n", str);
diff -puN arch/um/include/kern_util.h~uml-const-and-other-tidying arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-const-and-other-tidying
+++ a/arch/um/include/kern_util.h
@@ -81,7 +81,7 @@ extern void do_uml_exitcalls(void);
 extern int attach_debugger(int idle_pid, int pid, int stop);
 extern int config_gdb(char *str);
 extern int remove_gdb(void);
-extern char *uml_strdup(char *string);
+extern char *uml_strdup(const char *string);
 extern void unprotect_kernel_mem(void);
 extern void protect_kernel_mem(void);
 extern void uml_cleanup(void);
diff -puN arch/um/kernel/mem.c~uml-const-and-other-tidying arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-const-and-other-tidying
+++ a/arch/um/kernel/mem.c
@@ -65,7 +65,7 @@ static void setup_highmem(unsigned long 
 void __init mem_init(void)
 {
 	/* clear the zero-page */
-	memset((void *) empty_zero_page, 0, PAGE_SIZE);
+	memset(empty_zero_page, 0, PAGE_SIZE);
 
 	/* Map in the area just after the brk now that kmalloc is about
 	 * to be turned on.
diff -puN arch/um/kernel/process.c~uml-const-and-other-tidying arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-const-and-other-tidying
+++ a/arch/um/kernel/process.c
@@ -60,8 +60,6 @@ unsigned long alloc_stack(int order, int
 	if (atomic)
 		flags = GFP_ATOMIC;
 	page = __get_free_pages(flags, order);
-	if (page == 0)
-		return 0;
 
 	return page;
 }
@@ -331,7 +329,7 @@ void do_uml_exitcalls(void)
 		(*call)();
 }
 
-char *uml_strdup(char *string)
+char *uml_strdup(const char *string)
 {
 	return kstrdup(string, GFP_KERNEL);
 }
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-const-and-other-tidying arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-const-and-other-tidying
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -148,7 +148,7 @@ static int tuntap_open(void *data)
 		memset(&ifr, 0, sizeof(ifr));
 		ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
 		strlcpy(ifr.ifr_name, pri->dev_name, sizeof(ifr.ifr_name));
-		if (ioctl(pri->fd, TUNSETIFF, (void *) &ifr) < 0) {
+		if (ioctl(pri->fd, TUNSETIFF, &ifr) < 0) {
 			err = -errno;
 			printk(UM_KERN_ERR "TUNSETIFF failed, errno = %d\n",
 			       errno);
diff -puN arch/um/os-Linux/mem.c~uml-const-and-other-tidying arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-const-and-other-tidying
+++ a/arch/um/os-Linux/mem.c
@@ -30,7 +30,7 @@ static char *tempdir = NULL;
 
 static void __init find_tempdir(void)
 {
-	char *dirs[] = { "TMP", "TEMP", "TMPDIR", NULL };
+	const char *dirs[] = { "TMP", "TEMP", "TMPDIR", NULL };
 	int i;
 	char *dir = NULL;
 
@@ -59,9 +59,10 @@ static void __init find_tempdir(void)
  * read the file as needed.  If there's an error, -errno is returned;
  * if the end of the file is reached, 0 is returned.
  */
-static int next(int fd, char *buf, int size, char c)
+static int next(int fd, char *buf, size_t size, char c)
 {
-	int n, len;
+	ssize_t n;
+	size_t len;
 	char *ptr;
 
 	while((ptr = strchr(buf, c)) == NULL){
diff -puN arch/um/os-Linux/sigio.c~uml-const-and-other-tidying arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-const-and-other-tidying
+++ a/arch/um/os-Linux/sigio.c
@@ -407,7 +407,7 @@ static int async_pty(int master, int sla
 	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
 		return -errno;
 
-	return(0);
+	return 0;
 }
 
 static void __init check_one_sigio(void (*proc)(int, int))
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
uml-fix-incompatible-types-warning-in-previous-sg-fix.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
