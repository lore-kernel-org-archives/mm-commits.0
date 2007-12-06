From: akpm@linux-foundation.org
Subject: + uml-miscellaneous-code-cleanups.patch added to -mm tree
Date: Thu, 06 Dec 2007 11:47:32 -0800
Message-ID: <200712061947.lB6JlWn5008670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412AbXLFTrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2007 14:47:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: miscellaneous code cleanups
has been added to the -mm tree.  Its filename is
     uml-miscellaneous-code-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: miscellaneous code cleanups
From: Jeff Dike <jdike@addtoit.com>

Code tidying -
	the pid field of struct irq_fd isn't used, so it is removed
     	os_set_fd_async needed to read flags before changing them, it
doesn't need a pid passed in because it can call getpid itself, and a
block of unused code needed deleting
	os_get_exec_close was unused, so it is removed
	ptrace_child called _exit for historical reasons which are no
longer valid, so just calls exit instead

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/irq_user.h  |    1 
 arch/um/include/os.h        |    3 --
 arch/um/kernel/irq.c        |    6 +----
 arch/um/kernel/ksyms.c      |    1 
 arch/um/kernel/smp.c        |    6 +----
 arch/um/os-Linux/file.c     |   38 +++++++++-------------------------
 arch/um/os-Linux/start_up.c |    3 +-
 7 files changed, 18 insertions(+), 40 deletions(-)

diff -puN arch/um/include/irq_user.h~uml-miscellaneous-code-cleanups arch/um/include/irq_user.h
--- a/arch/um/include/irq_user.h~uml-miscellaneous-code-cleanups
+++ a/arch/um/include/irq_user.h
@@ -14,7 +14,6 @@ struct irq_fd {
 	int fd;
 	int type;
 	int irq;
-	int pid;
 	int events;
 	int current_events;
 };
diff -puN arch/um/include/os.h~uml-miscellaneous-code-cleanups arch/um/include/os.h
--- a/arch/um/include/os.h~uml-miscellaneous-code-cleanups
+++ a/arch/um/include/os.h
@@ -127,7 +127,6 @@ static inline struct openflags of_cloexe
 extern int os_stat_file(const char *file_name, struct uml_stat *buf);
 extern int os_stat_fd(const int fd, struct uml_stat *buf);
 extern int os_access(const char *file, int mode);
-extern int os_get_exec_close(int fd, int *close_on_exec);
 extern int os_set_exec_close(int fd);
 extern int os_ioctl_generic(int fd, unsigned int cmd, unsigned long arg);
 extern int os_get_ifname(int fd, char *namebuf);
@@ -142,7 +141,7 @@ extern int os_write_file(int fd, const v
 extern int os_file_size(const char *file, unsigned long long *size_out);
 extern int os_file_modtime(const char *file, unsigned long *modtime);
 extern int os_pipe(int *fd, int stream, int close_on_exec);
-extern int os_set_fd_async(int fd, int owner);
+extern int os_set_fd_async(int fd);
 extern int os_clear_fd_async(int fd);
 extern int os_set_fd_block(int fd, int blocking);
 extern int os_accept_connection(int fd);
diff -puN arch/um/kernel/irq.c~uml-miscellaneous-code-cleanups arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-miscellaneous-code-cleanups
+++ a/arch/um/kernel/irq.c
@@ -107,10 +107,9 @@ int activate_fd(int irq, int fd, int typ
 	struct pollfd *tmp_pfd;
 	struct irq_fd *new_fd, *irq_fd;
 	unsigned long flags;
-	int pid, events, err, n;
+	int events, err, n;
 
-	pid = os_getpid();
-	err = os_set_fd_async(fd, pid);
+	err = os_set_fd_async(fd);
 	if (err < 0)
 		goto out;
 
@@ -127,7 +126,6 @@ int activate_fd(int irq, int fd, int typ
 				     .fd 		= fd,
 				     .type 		= type,
 				     .irq 		= irq,
-				     .pid  		= pid,
 				     .events 		= events,
 				     .current_events 	= 0 } );
 
diff -puN arch/um/kernel/ksyms.c~uml-miscellaneous-code-cleanups arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-miscellaneous-code-cleanups
+++ a/arch/um/kernel/ksyms.c
@@ -36,7 +36,6 @@ EXPORT_SYMBOL(uml_strdup);
 EXPORT_SYMBOL(os_stat_fd);
 EXPORT_SYMBOL(os_stat_file);
 EXPORT_SYMBOL(os_access);
-EXPORT_SYMBOL(os_get_exec_close);
 EXPORT_SYMBOL(os_set_exec_close);
 EXPORT_SYMBOL(os_getpid);
 EXPORT_SYMBOL(os_open_file);
diff -puN arch/um/kernel/smp.c~uml-miscellaneous-code-cleanups arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c~uml-miscellaneous-code-cleanups
+++ a/arch/um/kernel/smp.c
@@ -74,8 +74,7 @@ static int idle_proc(void *cpup)
 	if (err < 0)
 		panic("CPU#%d failed to create IPI pipe, err = %d", cpu, -err);
 
-	os_set_fd_async(cpu_data[cpu].ipi_pipe[0],
-		     current->thread.mode.tt.extern_pid);
+	os_set_fd_async(cpu_data[cpu].ipi_pipe[0]);
 
 	wmb();
 	if (cpu_test_and_set(cpu, cpu_callin_map)) {
@@ -128,8 +127,7 @@ void smp_prepare_cpus(unsigned int maxcp
 	if (err < 0)
 		panic("CPU#0 failed to create IPI pipe, errno = %d", -err);
 
-	os_set_fd_async(cpu_data[me].ipi_pipe[0],
-		     current->thread.mode.tt.extern_pid);
+	os_set_fd_async(cpu_data[me].ipi_pipe[0]);
 
 	for (cpu = 1; cpu < ncpus; cpu++) {
 		printk(KERN_INFO "Booting processor %d...\n", cpu);
diff -puN arch/um/os-Linux/file.c~uml-miscellaneous-code-cleanups arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-miscellaneous-code-cleanups
+++ a/arch/um/os-Linux/file.c
@@ -328,19 +328,6 @@ int os_file_modtime(const char *file, un
 	return 0;
 }
 
-int os_get_exec_close(int fd, int *close_on_exec)
-{
-	int ret;
-
-	CATCH_EINTR(ret = fcntl(fd, F_GETFD));
-
-	if(ret < 0)
-		return -errno;
-
-	*close_on_exec = (ret & FD_CLOEXEC) ? 1 : 0;
-	return ret;
-}
-
 int os_set_exec_close(int fd)
 {
 	int err;
@@ -380,30 +367,27 @@ int os_pipe(int *fds, int stream, int cl
 	return err;
 }
 
-int os_set_fd_async(int fd, int owner)
+int os_set_fd_async(int fd)
 {
-	int err;
+	int err, flags;
+
+	flags = fcntl(fd, F_GETFL);
+	if (flags < 0)
+		return -errno;
 
-	/* XXX This should do F_GETFL first */
-	if(fcntl(fd, F_SETFL, O_ASYNC | O_NONBLOCK) < 0){
+	flags |= O_ASYNC | O_NONBLOCK;
+	if (fcntl(fd, F_SETFL, flags) < 0) {
 		err = -errno;
 		printk("os_set_fd_async : failed to set O_ASYNC and "
 		       "O_NONBLOCK on fd # %d, errno = %d\n", fd, errno);
 		return err;
 	}
-#ifdef notdef
-	if(fcntl(fd, F_SETFD, 1) < 0){
-		printk("os_set_fd_async : Setting FD_CLOEXEC failed, "
-		       "errno = %d\n", errno);
-	}
-#endif
 
-	if((fcntl(fd, F_SETSIG, SIGIO) < 0) ||
-	   (fcntl(fd, F_SETOWN, owner) < 0)){
+	if ((fcntl(fd, F_SETSIG, SIGIO) < 0) ||
+	    (fcntl(fd, F_SETOWN, os_getpid()) < 0)) {
 		err = -errno;
 		printk("os_set_fd_async : Failed to fcntl F_SETOWN "
-		       "(or F_SETSIG) fd %d to pid %d, errno = %d\n", fd,
-		       owner, errno);
+		       "(or F_SETSIG) fd %d, errno = %d\n", fd, errno);
 		return err;
 	}
 
diff -puN arch/um/os-Linux/start_up.c~uml-miscellaneous-code-cleanups arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-miscellaneous-code-cleanups
+++ a/arch/um/os-Linux/start_up.c
@@ -60,7 +60,8 @@ static int ptrace_child(void)
 		 * the UML code itself.
 		 */
 		ret = 2;
-	_exit(ret);
+
+	exit(ret);
 }
 
 static void fatal_perror(const char *str)
_

Patches currently in -mm which might be from jdike@addtoit.com are

aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch
git-kvm.patch
uml-add-asm-um-asmh.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-customize-tlbh.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
