From: akpm@linux-foundation.org
Subject: + alpha-binfmt_aout-fix.patch added to -mm tree
Date: Fri, 24 Apr 2009 13:12:50 -0700
Message-ID: <200904242012.n3OKCoU0006409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728AbZDXUP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net, viro@ZenIV.linux.org.uk


The patch titled
     alpha: binfmt_aout fix
has been added to the -mm tree.  Its filename is
     alpha-binfmt_aout-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: binfmt_aout fix
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

This fixes the problem introduced by commit 3bfacef412 (get rid of
special-casing the /sbin/loader on alpha): osf/1 ecoff binary segfaults
when binfmt_aout built as module.  That happens because aout binary
handler gets on the top of the binfmt list due to late registration, and
kernel attempts to execute the binary without preparatory work that must
be done by binfmt_loader.

Fixed by changing the registration order of the default binfmt handlers
using list_add_tail() and introducing insert_binfmt() function which
places new handler on the top of the binfmt list.  This might be generally
useful for installing arch-specific frontends for default handlers or just
for overriding them.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Henderson <rth@twiddle.net
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/Makefile        |    6 +++++-
 arch/alpha/kernel/binfmt_loader.c |    2 +-
 fs/exec.c                         |    7 ++++---
 include/linux/binfmts.h           |   14 +++++++++++++-
 4 files changed, 23 insertions(+), 6 deletions(-)

diff -puN arch/alpha/kernel/Makefile~alpha-binfmt_aout-fix arch/alpha/kernel/Makefile
--- a/arch/alpha/kernel/Makefile~alpha-binfmt_aout-fix
+++ a/arch/alpha/kernel/Makefile
@@ -8,7 +8,7 @@ EXTRA_CFLAGS	:= -Werror -Wno-sign-compar
 
 obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
-	    alpha_ksyms.o systbls.o err_common.o io.o binfmt_loader.o
+	    alpha_ksyms.o systbls.o err_common.o io.o
 
 obj-$(CONFIG_VGA_HOSE)	+= console.o
 obj-$(CONFIG_SMP)	+= smp.o
@@ -43,6 +43,10 @@ else
 # Misc support
 obj-$(CONFIG_ALPHA_SRM)		+= srmcons.o
 
+ifdef CONFIG_BINFMT_AOUT
+obj-y	+= binfmt_loader.o
+endif
+
 # Core logic support
 obj-$(CONFIG_ALPHA_APECS)	+= core_apecs.o
 obj-$(CONFIG_ALPHA_CIA)		+= core_cia.o
diff -puN arch/alpha/kernel/binfmt_loader.c~alpha-binfmt_aout-fix arch/alpha/kernel/binfmt_loader.c
--- a/arch/alpha/kernel/binfmt_loader.c~alpha-binfmt_aout-fix
+++ a/arch/alpha/kernel/binfmt_loader.c
@@ -46,6 +46,6 @@ static struct linux_binfmt loader_format
 
 static int __init init_loader_binfmt(void)
 {
-	return register_binfmt(&loader_format);
+	return insert_binfmt(&loader_format);
 }
 arch_initcall(init_loader_binfmt);
diff -puN fs/exec.c~alpha-binfmt_aout-fix fs/exec.c
--- a/fs/exec.c~alpha-binfmt_aout-fix
+++ a/fs/exec.c
@@ -69,17 +69,18 @@ int suid_dumpable = 0;
 static LIST_HEAD(formats);
 static DEFINE_RWLOCK(binfmt_lock);
 
-int register_binfmt(struct linux_binfmt * fmt)
+int __register_binfmt(struct linux_binfmt * fmt, int insert)
 {
 	if (!fmt)
 		return -EINVAL;
 	write_lock(&binfmt_lock);
-	list_add(&fmt->lh, &formats);
+	insert ? list_add(&fmt->lh, &formats) :
+		 list_add_tail(&fmt->lh, &formats);
 	write_unlock(&binfmt_lock);
 	return 0;	
 }
 
-EXPORT_SYMBOL(register_binfmt);
+EXPORT_SYMBOL(__register_binfmt);
 
 void unregister_binfmt(struct linux_binfmt * fmt)
 {
diff -puN include/linux/binfmts.h~alpha-binfmt_aout-fix include/linux/binfmts.h
--- a/include/linux/binfmts.h~alpha-binfmt_aout-fix
+++ a/include/linux/binfmts.h
@@ -82,7 +82,19 @@ struct linux_binfmt {
 	int hasvdso;
 };
 
-extern int register_binfmt(struct linux_binfmt *);
+extern int __register_binfmt(struct linux_binfmt *fmt, int insert);
+
+/* Registration of default binfmt handlers */
+static inline int register_binfmt(struct linux_binfmt *fmt)
+{
+	return __register_binfmt(fmt, 0);
+}
+/* Same as above, but adds a new binfmt at the top of the list */
+static inline int insert_binfmt(struct linux_binfmt *fmt)
+{
+	return __register_binfmt(fmt, 1);
+}
+
 extern void unregister_binfmt(struct linux_binfmt *);
 
 extern int prepare_binprm(struct linux_binprm *);
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

linux-next.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
alpha-titan-and-marvel-build-fixes.patch
alpha-exception-table-sorting.patch
alpha-futex-implementation.patch
alpha-binfmt_aout-fix.patch
kmap_types-make-most-arches-use-generic-header-file.patch
make-sure-nobodys-leaking-resources.patch

