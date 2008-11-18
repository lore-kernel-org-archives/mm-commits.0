From: akpm@linux-foundation.org
Subject: + kernel-modulec-compare-symbol-values-when-marking-symbols-as-exported-in-proc-kallsyms.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:06:09 -0800
Message-ID: <200811182306.mAIN69pe012866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYKRXGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:06:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tabbott@MIT.EDU, rusty@rustcorp.com.autabbott@MIT.EDU


The patch titled
     kernel/module.c: compare symbol values when marking symbols as exported in /proc/kallsyms.
has been added to the -mm tree.  Its filename is
     kernel-modulec-compare-symbol-values-when-marking-symbols-as-exported-in-proc-kallsyms.patch

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
Subject: kernel/module.c: compare symbol values when marking symbols as exported in /proc/kallsyms.
From: Tim Abbott <tabbott@MIT.EDU>

When there are two symbols in a module with the same name, one of which is
exported, both will be marked as exported in /proc/kallsyms.  There aren't
any instances of this in the current kernel, but it is easy to construct a
simple module with two compilation units that exhibits the problem.

$ objdump -j .text -t testmod.ko | grep foo
00000000 l     F .text	00000032 foo
00000080 g     F .text	00000001 foo
$ sudo insmod testmod.ko
$ grep "T foo" /proc/kallsyms
c28e8000 T foo	[testmod]
c28e8080 T foo	[testmod]

Fix this by comparing the symbol values once we've found the exported
symbol table entry matching the symbol name.  Tested using Ksplice:

$ ksplice-create --patch=this_commit.patch --id=bar .
$ sudo ksplice-apply ksplice-bar.tar.gz
Done!
$ grep "T foo" /proc/kallsyms
c28e8080 T foo	[testmod]

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/module.c~kernel-modulec-compare-symbol-values-when-marking-symbols-as-exported-in-proc-kallsyms kernel/module.c
--- a/kernel/module.c~kernel-modulec-compare-symbol-values-when-marking-symbols-as-exported-in-proc-kallsyms
+++ a/kernel/module.c
@@ -1569,15 +1569,15 @@ static const struct kernel_symbol *looku
 	return NULL;
 }
 
-static int is_exported(const char *name, const struct module *mod)
+static int is_exported(const char *name, unsigned long value,
+		       const struct module *mod)
 {
-	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))
-		return 1;
+	const struct kernel_symbol *ks;
+	if (!mod)
+		ks = lookup_symbol(name, __start___ksymtab, __stop___ksymtab);
 	else
-		if (mod && lookup_symbol(name, mod->syms, mod->syms + mod->num_syms))
-			return 1;
-		else
-			return 0;
+		ks = lookup_symbol(name, mod->syms, mod->syms + mod->num_syms);
+	return ks != NULL && ks->value == value;
 }
 
 /* As per nm */
@@ -2363,7 +2363,7 @@ int module_get_kallsym(unsigned int symn
 			strlcpy(name, mod->strtab + mod->symtab[symnum].st_name,
 				KSYM_NAME_LEN);
 			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
-			*exported = is_exported(name, mod);
+			*exported = is_exported(name, *value, mod);
 			preempt_enable();
 			return 0;
 		}
_

Patches currently in -mm which might be from tabbott@MIT.EDU are

kernel-modulec-compare-symbol-values-when-marking-symbols-as-exported-in-proc-kallsyms.patch

