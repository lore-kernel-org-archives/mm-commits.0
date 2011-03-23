From: akpm@linux-foundation.org
Subject: [merged] printk-use-%pk-for-proc-kallsyms-and-proc-modules.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:28 -0700
Message-ID: <201103232043.p2NKh4K3028831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933339Ab1CWUzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees.cook@canonical.com, drosenberg@vsecurity.com, eugene@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     printk: use %pK for /proc/kallsyms and /proc/modules
has been removed from the -mm tree.  Its filename was
     printk-use-%pk-for-proc-kallsyms-and-proc-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: use %pK for /proc/kallsyms and /proc/modules
From: Kees Cook <kees.cook@canonical.com>

In an effort to reduce kernel address leaks that might be used to help
target kernel privilege escalation exploits, this patch uses %pK when
displaying addresses in /proc/kallsyms, /proc/modules, and
/sys/module/*/sections/*.

Note that this changes %x to %p, so some legitimately 0 values in
/proc/kallsyms would have changed from 00000000 to "(null)".  To avoid
this, "(null)" is not used when using the "K" format.  Anything that was
already successfully parsing "(null)" in addition to full hex digits
should have no problem with this change.  (Thanks to Joe Perches for the
suggestion.) Due to the %x to %p, "void *" casts are needed since these
addresses are already "unsigned long" everywhere internally, due to their
starting life as ELF section offsets.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: Eugene Teo <eugene@redhat.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |   10 ++++------
 kernel/module.c   |    4 ++--
 lib/vsprintf.c    |    2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN kernel/kallsyms.c~printk-use-%pk-for-proc-kallsyms-and-proc-modules kernel/kallsyms.c
--- a/kernel/kallsyms.c~printk-use-%pk-for-proc-kallsyms-and-proc-modules
+++ a/kernel/kallsyms.c
@@ -477,13 +477,11 @@ static int s_show(struct seq_file *m, vo
 		 */
 		type = iter->exported ? toupper(iter->type) :
 					tolower(iter->type);
-		seq_printf(m, "%0*lx %c %s\t[%s]\n",
-			   (int)(2 * sizeof(void *)),
-			   iter->value, type, iter->name, iter->module_name);
+		seq_printf(m, "%pK %c %s\t[%s]\n", (void *)iter->value,
+			   type, iter->name, iter->module_name);
 	} else
-		seq_printf(m, "%0*lx %c %s\n",
-			   (int)(2 * sizeof(void *)),
-			   iter->value, iter->type, iter->name);
+		seq_printf(m, "%pK %c %s\n", (void *)iter->value,
+			   iter->type, iter->name);
 	return 0;
 }
 
diff -puN kernel/module.c~printk-use-%pk-for-proc-kallsyms-and-proc-modules kernel/module.c
--- a/kernel/module.c~printk-use-%pk-for-proc-kallsyms-and-proc-modules
+++ a/kernel/module.c
@@ -1168,7 +1168,7 @@ static ssize_t module_sect_show(struct m
 {
 	struct module_sect_attr *sattr =
 		container_of(mattr, struct module_sect_attr, mattr);
-	return sprintf(buf, "0x%lx\n", sattr->address);
+	return sprintf(buf, "0x%pK\n", (void *)sattr->address);
 }
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
@@ -3224,7 +3224,7 @@ static int m_show(struct seq_file *m, vo
 		   mod->state == MODULE_STATE_COMING ? "Loading":
 		   "Live");
 	/* Used by oprofile and other similar tools. */
-	seq_printf(m, " 0x%p", mod->module_core);
+	seq_printf(m, " 0x%pK", mod->module_core);
 
 	/* Taints info */
 	if (mod->taints)
diff -puN lib/vsprintf.c~printk-use-%pk-for-proc-kallsyms-and-proc-modules lib/vsprintf.c
--- a/lib/vsprintf.c~printk-use-%pk-for-proc-kallsyms-and-proc-modules
+++ a/lib/vsprintf.c
@@ -991,7 +991,7 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-	if (!ptr) {
+	if (!ptr && *fmt != 'K') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
_

Patches currently in -mm which might be from kees.cook@canonical.com are

origin.patch
net-convert-%p-usage-to-%pk.patch
proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch
proc-protect-mm-start_code-end_code-in-proc-pid-stat.patch
sysctl-restrict-write-access-to-dmesg_restrict.patch

