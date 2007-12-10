From: akpm@linux-foundation.org
Subject: + uml-eliminate-setjmp_wrapper.patch added to -mm tree
Date: Mon, 10 Dec 2007 15:52:36 -0800
Message-ID: <200712102352.lBANqbLE025452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbXLJXwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 18:52:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: eliminate setjmp_wrapper
has been added to the -mm tree.  Its filename is
     uml-eliminate-setjmp_wrapper.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: eliminate setjmp_wrapper
From: Jeff Dike <jdike@addtoit.com>

setjmp_wrapper existed to provide setjmp to kernel code when UML used libc's
setjmp and longjmp.  Now that UML has its own implementation, this isn't
needed and kernel code can invoke setjmp directly.

do_buffer_op is massively cleaned up since it is no longer a callback from
setjmp_wrapper and given a va_list from which it must extract its arguments.

The actual setjmp is moved from buffer_op to do_op_one_page because the copy
operation is inside an atomic section (kmap_atomic to kunmap_atomic) and it
shouldn't be longjmp-ed out of.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h          |    1 
 arch/um/kernel/skas/uaccess.c |   73 +++++++++++---------------------
 arch/um/os-Linux/util.c       |   15 ------
 3 files changed, 27 insertions(+), 62 deletions(-)

diff -puN arch/um/include/os.h~uml-eliminate-setjmp_wrapper arch/um/include/os.h
--- a/arch/um/include/os.h~uml-eliminate-setjmp_wrapper
+++ a/arch/um/include/os.h
@@ -235,7 +235,6 @@ extern void stack_protections(unsigned l
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
-extern int setjmp_wrapper(void (*proc)(void *, void *), ...);
 extern void os_dump_core(void) __attribute__ ((noreturn));
 
 /* time.c */
diff -puN arch/um/kernel/skas/uaccess.c~uml-eliminate-setjmp_wrapper arch/um/kernel/skas/uaccess.c
--- a/arch/um/kernel/skas/uaccess.c~uml-eliminate-setjmp_wrapper
+++ a/arch/um/kernel/skas/uaccess.c
@@ -58,9 +58,10 @@ static pte_t *maybe_map(unsigned long vi
 static int do_op_one_page(unsigned long addr, int len, int is_write,
 		 int (*op)(unsigned long addr, int len, void *arg), void *arg)
 {
+	jmp_buf buf;
 	struct page *page;
 	pte_t *pte;
-	int n;
+	int n, faulted;
 
 	pte = maybe_map(addr, is_write);
 	if (pte == NULL)
@@ -70,82 +71,62 @@ static int do_op_one_page(unsigned long 
 	addr = (unsigned long) kmap_atomic(page, KM_UML_USERCOPY) +
 		(addr & ~PAGE_MASK);
 
-	n = (*op)(addr, len, arg);
+	current->thread.fault_catcher = &buf;
+
+	faulted = UML_SETJMP(&buf);
+	if (faulted == 0)
+		n = (*op)(addr, len, arg);
+	else
+		n = -1;
+
+	current->thread.fault_catcher = NULL;
 
 	kunmap_atomic(page, KM_UML_USERCOPY);
 
 	return n;
 }
 
-static void do_buffer_op(void *jmpbuf, void *arg_ptr)
+static int buffer_op(unsigned long addr, int len, int is_write,
+		     int (*op)(unsigned long, int, void *), void *arg)
 {
-	va_list args;
-	unsigned long addr;
-	int len, is_write, size, remain, n;
-	int (*op)(unsigned long, int, void *);
-	void *arg;
-	int *res;
-
-	va_copy(args, *(va_list *)arg_ptr);
-	addr = va_arg(args, unsigned long);
-	len = va_arg(args, int);
-	is_write = va_arg(args, int);
-	op = va_arg(args, void *);
-	arg = va_arg(args, void *);
-	res = va_arg(args, int *);
-	va_end(args);
+	int size, remain, n;
+
 	size = min(PAGE_ALIGN(addr) - addr, (unsigned long) len);
 	remain = len;
 
-	current->thread.fault_catcher = jmpbuf;
 	n = do_op_one_page(addr, size, is_write, op, arg);
 	if (n != 0) {
-		*res = (n < 0 ? remain : 0);
+		remain = (n < 0 ? remain : 0);
 		goto out;
 	}
 
 	addr += size;
 	remain -= size;
-	if (remain == 0) {
-		*res = 0;
+	if (remain == 0)
 		goto out;
-	}
 
-	while(addr < ((addr + remain) & PAGE_MASK)) {
+	while (addr < ((addr + remain) & PAGE_MASK)) {
 		n = do_op_one_page(addr, PAGE_SIZE, is_write, op, arg);
 		if (n != 0) {
-			*res = (n < 0 ? remain : 0);
+			remain = (n < 0 ? remain : 0);
 			goto out;
 		}
 
 		addr += PAGE_SIZE;
 		remain -= PAGE_SIZE;
 	}
-	if (remain == 0) {
-		*res = 0;
+	if (remain == 0)
 		goto out;
-	}
 
 	n = do_op_one_page(addr, remain, is_write, op, arg);
-	if (n != 0)
-		*res = (n < 0 ? remain : 0);
-	else *res = 0;
- out:
-	current->thread.fault_catcher = NULL;
-}
-
-static int buffer_op(unsigned long addr, int len, int is_write,
-		     int (*op)(unsigned long addr, int len, void *arg),
-		     void *arg)
-{
-	int faulted, res;
-
-	faulted = setjmp_wrapper(do_buffer_op, addr, len, is_write, op, arg,
-				 &res);
-	if (!faulted)
-		return res;
+	if (n != 0) {
+		remain = (n < 0 ? remain : 0);
+		goto out;
+	}
 
-	return addr + len - (unsigned long) current->thread.fault_addr;
+	return 0;
+ out:
+	return remain;
 }
 
 static int copy_chunk_from_user(unsigned long from, int len, void *arg)
diff -puN arch/um/os-Linux/util.c~uml-eliminate-setjmp_wrapper arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-eliminate-setjmp_wrapper
+++ a/arch/um/os-Linux/util.c
@@ -88,21 +88,6 @@ void setup_hostinfo(char *buf, int len)
 		 host.release, host.version, host.machine);
 }
 
-int setjmp_wrapper(void (*proc)(void *, void *), ...)
-{
-	va_list args;
-	jmp_buf buf;
-	int n;
-
-	n = UML_SETJMP(&buf);
-	if(n == 0){
-		va_start(args, proc);
-		(*proc)(&buf, &args);
-	}
-	va_end(args);
-	return n;
-}
-
 void os_dump_core(void)
 {
 	int pid;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
update-stale-maintainers-entries.patch
git-kvm.patch
git-x86.patch
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
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-runtime-detection-of-host-vmsplit-on-i386.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
