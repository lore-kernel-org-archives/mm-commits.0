From: akpm@linux-foundation.org
Subject: + uml-remove-page_size.patch added to -mm tree
Date: Mon, 02 Apr 2007 14:46:26 -0700
Message-ID: <200704022146.l32LkQHr010303@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48369 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965971AbXDBVqa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 17:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: remove page_size()
has been added to the -mm tree.  Its filename is
     uml-remove-page_size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove page_size()
From: Jeff Dike <jdike@addtoit.com>

userspace code used to have to call the kernelspace function page_size() in
order to determine the value of the kernel's PAGE_SIZE.  Since this is now
available directly from kern_constants.h as UM_KERN_PAGE_SIZE, page_size() can
be deleted and calls changed to use the constant.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_user.c               |    3 ++-
 arch/um/drivers/slip_user.c              |    3 ++-
 arch/um/include/kern_util.h              |    1 -
 arch/um/kernel/process.c                 |    5 -----
 arch/um/os-Linux/drivers/ethertap_user.c |    7 ++++---
 arch/um/os-Linux/helper.c                |    5 +++--
 arch/um/os-Linux/process.c               |    2 +-
 arch/um/os-Linux/skas/process.c          |    9 +++++----
 arch/um/os-Linux/tt.c                    |    3 ++-
 arch/um/os-Linux/util.c                  |   11 ++++++-----
 10 files changed, 25 insertions(+), 24 deletions(-)

diff -puN arch/um/drivers/net_user.c~uml-remove-page_size arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-remove-page_size
+++ a/arch/um/drivers/net_user.c
@@ -18,6 +18,7 @@
 #include "net_user.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "kern_constants.h"
 
 int tap_open_common(void *dev, char *gate_addr)
 {
@@ -215,7 +216,7 @@ static void change(char *dev, char *what
 	sprintf(netmask_buf, "%d.%d.%d.%d", netmask[0], netmask[1], 
 		netmask[2], netmask[3]);
 
-	output_len = page_size();
+	output_len = UM_KERN_PAGE_SIZE;
 	output = um_kmalloc(output_len);
 	if(output == NULL)
 		printk("change : failed to allocate output buffer\n");
diff -puN arch/um/drivers/slip_user.c~uml-remove-page_size arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-remove-page_size
+++ a/arch/um/drivers/slip_user.c
@@ -15,6 +15,7 @@
 #include "slip_common.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "kern_constants.h"
 
 static int slip_user_init(void *data, void *dev)
 {
@@ -89,7 +90,7 @@ static int slip_tramp(char **argv, int f
 		goto out_close;
 	pid = err;
 
-	output_len = page_size();
+	output_len = UM_KERN_PAGE_SIZE;
 	output = um_kmalloc(output_len);
 	if(output == NULL){
 		printk("slip_tramp : failed to allocate output buffer\n");
diff -puN arch/um/include/kern_util.h~uml-remove-page_size arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-remove-page_size
+++ a/arch/um/include/kern_util.h
@@ -51,7 +51,6 @@ extern void set_tracing(void *t, int tra
 extern int is_tracing(void *task);
 extern int segv_syscall(void);
 extern void kern_finish_exec(void *task, int new_pid, unsigned long stack);
-extern int page_size(void);
 extern unsigned long page_mask(void);
 extern int need_finish_fork(void);
 extern void free_stack(unsigned long stack, int order);
diff -puN arch/um/kernel/process.c~uml-remove-page_size arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-remove-page_size
+++ a/arch/um/kernel/process.c
@@ -217,11 +217,6 @@ void cpu_idle(void)
 	CHOOSE_MODE(init_idle_tt(), init_idle_skas());
 }
 
-int page_size(void)
-{
-	return PAGE_SIZE;
-}
-
 void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
 		      pte_t *pte_out)
 {
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-remove-page_size arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-remove-page_size
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -20,6 +20,7 @@
 #include "etap.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "kern_constants.h"
 
 #define MAX_PACKET ETH_MAX_PACKET
 
@@ -50,10 +51,10 @@ static void etap_change(int op, unsigned
 	n = os_write_file(fd, &change, sizeof(change));
 	if(n != sizeof(change))
 		printk("etap_change - request failed, err = %d\n", -n);
-	output = um_kmalloc(page_size());
+	output = um_kmalloc(UM_KERN_PAGE_SIZE);
 	if(output == NULL)
 		printk("etap_change : Failed to allocate output buffer\n");
-	read_output(fd, output, page_size());
+	read_output(fd, output, UM_KERN_PAGE_SIZE);
 	if(output != NULL){
 		printk("%s", output);
 		kfree(output);
@@ -159,7 +160,7 @@ static int etap_open(void *data)
 
 	err = etap_tramp(pri->dev_name, pri->gate_addr, control_fds[0], 
 			 control_fds[1], data_fds[0], data_fds[1]);
-	output_len = page_size();
+	output_len = UM_KERN_PAGE_SIZE;
 	output = um_kmalloc(output_len);
 	read_output(control_fds[0], output, output_len);
 
diff -puN arch/um/os-Linux/helper.c~uml-remove-page_size arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-remove-page_size
+++ a/arch/um/os-Linux/helper.c
@@ -15,6 +15,7 @@
 #include "kern_util.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "kern_constants.h"
 
 struct helper_data {
 	void (*pre_exec)(void*);
@@ -69,7 +70,7 @@ int run_helper(void (*pre_exec)(void *),
 		goto out_close;
 	}
 
-	sp = stack + page_size() - sizeof(void *);
+	sp = stack + UM_KERN_PAGE_SIZE - sizeof(void *);
 	data.pre_exec = pre_exec;
 	data.pre_data = pre_data;
 	data.argv = argv;
@@ -123,7 +124,7 @@ int run_helper_thread(int (*proc)(void *
 	if (stack == 0)
 		return -ENOMEM;
 
-	sp = stack + (page_size() << stack_order) - sizeof(void *);
+	sp = stack + (UM_KERN_PAGE_SIZE << stack_order) - sizeof(void *);
 	pid = clone(proc, (void *) sp, flags | SIGCHLD, arg);
 	if (pid < 0) {
 		err = -errno;
diff -puN arch/um/os-Linux/process.c~uml-remove-page_size arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-remove-page_size
+++ a/arch/um/os-Linux/process.c
@@ -244,7 +244,7 @@ void init_new_thread_stack(void *sig_sta
 
 	if(sig_stack != NULL){
 		pages = (1 << UML_CONFIG_KERNEL_STACK_ORDER);
-		set_sigstack(sig_stack, pages * page_size());
+		set_sigstack(sig_stack, pages * UM_KERN_PAGE_SIZE);
 		flags = SA_ONSTACK;
 	}
 	if(usr1_handler){
diff -puN arch/um/os-Linux/skas/process.c~uml-remove-page_size arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-remove-page_size
+++ a/arch/um/os-Linux/skas/process.c
@@ -33,6 +33,7 @@
 #include "uml-config.h"
 #include "process.h"
 #include "longjmp.h"
+#include "kern_constants.h"
 
 int is_skas_winch(int pid, int fd, void *data)
 {
@@ -171,7 +172,7 @@ static int userspace_tramp(void *stack)
 		int fd;
 		__u64 offset;
 		fd = phys_mapping(to_phys(&__syscall_stub_start), &offset);
-		addr = mmap64((void *) UML_CONFIG_STUB_CODE, page_size(),
+		addr = mmap64((void *) UML_CONFIG_STUB_CODE, UM_KERN_PAGE_SIZE,
 			      PROT_EXEC, MAP_FIXED | MAP_PRIVATE, fd, offset);
 		if(addr == MAP_FAILED){
 			printk("mapping mmap stub failed, errno = %d\n",
@@ -181,8 +182,8 @@ static int userspace_tramp(void *stack)
 
 		if(stack != NULL){
 			fd = phys_mapping(to_phys(stack), &offset);
-			addr = mmap((void *) UML_CONFIG_STUB_DATA, page_size(),
-				    PROT_READ | PROT_WRITE,
+			addr = mmap((void *) UML_CONFIG_STUB_DATA,
+				    UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 				    MAP_FIXED | MAP_SHARED, fd, offset);
 			if(addr == MAP_FAILED){
 				printk("mapping segfault stack failed, "
@@ -198,7 +199,7 @@ static int userspace_tramp(void *stack)
 				  (unsigned long) stub_segv_handler -
 				  (unsigned long) &__syscall_stub_start;
 
-		set_sigstack((void *) UML_CONFIG_STUB_DATA, page_size());
+		set_sigstack((void *) UML_CONFIG_STUB_DATA, UM_KERN_PAGE_SIZE);
 		sigemptyset(&sa.sa_mask);
 		sigaddset(&sa.sa_mask, SIGIO);
 		sigaddset(&sa.sa_mask, SIGWINCH);
diff -puN arch/um/os-Linux/tt.c~uml-remove-page_size arch/um/os-Linux/tt.c
--- a/arch/um/os-Linux/tt.c~uml-remove-page_size
+++ a/arch/um/os-Linux/tt.c
@@ -31,6 +31,7 @@
 #include "choose-mode.h"
 #include "mode.h"
 #include "tempfile.h"
+#include "kern_constants.h"
 
 int protect_memory(unsigned long addr, unsigned long len, int r, int w, int x,
 		   int must_succeed)
@@ -142,7 +143,7 @@ int outer_tramp(void *arg)
 	int sig = sigkill;
 
 	t = arg;
-	t->pid = clone(t->tramp, (void *) t->temp_stack + page_size()/2,
+	t->pid = clone(t->tramp, (void *) t->temp_stack + UM_KERN_PAGE_SIZE/2,
 		       t->flags, t->tramp_data);
 	if(t->pid > 0) wait_for_stop(t->pid, SIGSTOP, PTRACE_CONT, NULL);
 	kill(os_getpid(), sig);
diff -puN arch/um/os-Linux/util.c~uml-remove-page_size arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-remove-page_size
+++ a/arch/um/os-Linux/util.c
@@ -29,28 +29,29 @@
 #include "uml-config.h"
 #include "os.h"
 #include "longjmp.h"
+#include "kern_constants.h"
 
 void stack_protections(unsigned long address)
 {
 	int prot = PROT_READ | PROT_WRITE | PROT_EXEC;
 
-	if(mprotect((void *) address, page_size(), prot) < 0)
+	if(mprotect((void *) address, UM_KERN_PAGE_SIZE, prot) < 0)
 		panic("protecting stack failed, errno = %d", errno);
 }
 
 void task_protections(unsigned long address)
 {
-	unsigned long guard = address + page_size();
-	unsigned long stack = guard + page_size();
+	unsigned long guard = address + UM_KERN_PAGE_SIZE;
+	unsigned long stack = guard + UM_KERN_PAGE_SIZE;
 	int prot = 0, pages;
 
 #ifdef notdef
-	if(mprotect((void *) stack, page_size(), prot) < 0)
+	if(mprotect((void *) stack, UM_KERN_PAGE_SIZE, prot) < 0)
 		panic("protecting guard page failed, errno = %d", errno);
 #endif
 	pages = (1 << UML_CONFIG_KERNEL_STACK_ORDER) - 2;
 	prot = PROT_READ | PROT_WRITE | PROT_EXEC;
-	if(mprotect((void *) stack, pages * page_size(), prot) < 0)
+	if(mprotect((void *) stack, pages * UM_KERN_PAGE_SIZE, prot) < 0)
 		panic("protecting stack failed, errno = %d", errno);
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-unreasonably-long-udelay.patch
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
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
