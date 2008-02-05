From: akpm@linux-foundation.org
Subject: - uml-eliminate-setjmp_wrapper.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:30 -0800
Message-ID: <200802052237.m15MbBBv012833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762504AbYBEWlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: eliminate setjmp_wrapper
has been removed from the -mm tree.  Its filename was
     uml-eliminate-setjmp_wrapper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
