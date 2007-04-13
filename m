From: akpm@linux-foundation.org
Subject: + uml-change-remaining-callers-of-os_read_write_file.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:31:55 -0700
Message-ID: <200704131931.l3DJVt0J007650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbXDMTcA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:32:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: change remaining callers of os_{read_write}_file
has been added to the -mm tree.  Its filename is
     uml-change-remaining-callers-of-os_read_write_file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: change remaining callers of os_{read_write}_file
From: Jeff Dike <jdike@addtoit.com>

Convert all remaining os_{read_write}_file users to use the simple
{read,write} wrappers, os_{read_write}_file_k.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |    4 ++--
 arch/um/drivers/cow_sys.h   |    2 +-
 arch/um/drivers/net_user.c  |    6 +++---
 arch/um/drivers/ubd_kern.c  |    2 +-
 arch/um/kernel/initrd.c     |    2 +-
 arch/um/kernel/physmem.c    |    2 +-
 arch/um/sys-i386/bugs.c     |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-change-remaining-callers-of-os_read_write_file arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-change-remaining-callers-of-os_read_write_file
+++ a/arch/um/drivers/chan_kern.c
@@ -98,7 +98,7 @@ int generic_read(int fd, char *c_out, vo
 {
 	int n;
 
-	n = os_read_file(fd, c_out, sizeof(*c_out));
+	n = os_read_file_k(fd, c_out, sizeof(*c_out));
 
 	if(n == -EAGAIN)
 		return 0;
@@ -111,7 +111,7 @@ int generic_read(int fd, char *c_out, vo
 
 int generic_write(int fd, const char *buf, int n, void *unused)
 {
-	return os_write_file(fd, buf, n);
+	return os_write_file_k(fd, buf, n);
 }
 
 int generic_window_size(int fd, void *unused, unsigned short *rows_out,
diff -puN arch/um/drivers/cow_sys.h~uml-change-remaining-callers-of-os_read_write_file arch/um/drivers/cow_sys.h
--- a/arch/um/drivers/cow_sys.h~uml-change-remaining-callers-of-os_read_write_file
+++ a/arch/um/drivers/cow_sys.h
@@ -35,7 +35,7 @@ static inline int cow_file_size(char *fi
 
 static inline int cow_write_file(int fd, void *buf, int size)
 {
-	return(os_write_file(fd, buf, size));
+	return(os_write_file_k(fd, buf, size));
 }
 
 #endif
diff -puN arch/um/drivers/net_user.c~uml-change-remaining-callers-of-os_read_write_file arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-change-remaining-callers-of-os_read_write_file
+++ a/arch/um/drivers/net_user.c
@@ -73,7 +73,7 @@ void read_output(int fd, char *output, i
 
 	while(remain != 0){
 		expected = (remain < len) ? remain : len;
-		ret = os_read_file(fd, output, expected);
+		ret = os_read_file_k(fd, output, expected);
 		if (ret != expected) {
 			str = "data";
 			goto err;
@@ -94,7 +94,7 @@ int net_read(int fd, void *buf, int len)
 {
 	int n;
 
-	n = os_read_file(fd,  buf,  len);
+	n = os_read_file_k(fd,  buf,  len);
 
 	if(n == -EAGAIN)
 		return 0;
@@ -122,7 +122,7 @@ int net_write(int fd, void *buf, int len
 {
 	int n;
 
-	n = os_write_file(fd, buf, len);
+	n = os_write_file_k(fd, buf, len);
 
 	if(n == -EAGAIN)
 		return 0;
diff -puN arch/um/drivers/ubd_kern.c~uml-change-remaining-callers-of-os_read_write_file arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-change-remaining-callers-of-os_read_write_file
+++ a/arch/um/drivers/ubd_kern.c
@@ -1246,7 +1246,7 @@ int read_cow_bitmap(int fd, void *buf, i
 	if(err < 0)
 		return(err);
 
-	err = os_read_file(fd, buf, len);
+	err = os_read_file_k(fd, buf, len);
 	if(err < 0)
 		return(err);
 
diff -puN arch/um/kernel/initrd.c~uml-change-remaining-callers-of-os_read_write_file arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~uml-change-remaining-callers-of-os_read_write_file
+++ a/arch/um/kernel/initrd.c
@@ -55,7 +55,7 @@ int load_initrd(char *filename, void *bu
 		printk("Opening '%s' failed - err = %d\n", filename, -fd);
 		return(-1);
 	}
-	n = os_read_file(fd, buf, size);
+	n = os_read_file_k(fd, buf, size);
 	if(n != size){
 		printk("Read of %d bytes from '%s' failed, err = %d\n", size,
 		       filename, -n);
diff -puN arch/um/kernel/physmem.c~uml-change-remaining-callers-of-os_read_write_file arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-change-remaining-callers-of-os_read_write_file
+++ a/arch/um/kernel/physmem.c
@@ -211,7 +211,7 @@ void physmem_forget_descriptor(int fd)
 			panic("physmem_forget_descriptor - failed to seek "
 			      "to %lld in fd %d, error = %d\n",
 			      offset, fd, -err);
-		err = os_read_file(fd, addr, PAGE_SIZE);
+		err = os_read_file_k(fd, addr, PAGE_SIZE);
 		if(err < 0)
 			panic("physmem_forget_descriptor - failed to read "
 			      "from fd %d to 0x%p, error = %d\n",
diff -puN arch/um/sys-i386/bugs.c~uml-change-remaining-callers-of-os_read_write_file arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-change-remaining-callers-of-os_read_write_file
+++ a/arch/um/sys-i386/bugs.c
@@ -28,7 +28,7 @@ static char token(int fd, char *buf, int
 	ptr = buf;
 	end = &buf[len];
 	do {
-		n = os_read_file(fd, ptr, sizeof(*ptr));
+		n = os_read_file_k(fd, ptr, sizeof(*ptr));
 		c = *ptr++;
 		if(n != sizeof(*ptr)){
 			if(n == 0)
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
