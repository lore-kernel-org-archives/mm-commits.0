From: akpm@linux-foundation.org
Subject: + module-fix-crash-in-get_ksymbol-when-oopsing-in-module-init.patch added to -mm tree
Date: Wed, 14 Jul 2010 16:43:00 -0700
Message-ID: <201007142343.o6ENh1Xn029716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757525Ab0GNXnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jul 2010 19:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, akpm@linux-foundation.org


The patch titled
     module: fix crash in get_ksymbol() when oopsing in module init
has been added to the -mm tree.  Its filename is
     module-fix-crash-in-get_ksymbol-when-oopsing-in-module-init.patch

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
Subject: module: fix crash in get_ksymbol() when oopsing in module init
From: Rusty Russell <rusty@rustcorp.com.au>

Andrew had the sole pleasure of tickling this bug in linux-next; when we
set up "info->strtab" it's pointing into the temporary copy of the module.
 For most uses that is fine, but kallsyms keeps a pointer around during
module load (inside mod->strtab).

If we oops for some reason inside a module's init function, kallsyms will
use the mod->strtab pointer into the now-freed temporary module copy.

(Later oopses work fine: after init we overwrite mod->strtab to point to a
compacted core-only strtab).

Reported-by: Andrew "Grumpy" Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty "Buggy" Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/module.c~module-fix-crash-in-get_ksymbol-when-oopsing-in-module-init kernel/module.c
--- a/kernel/module.c~module-fix-crash-in-get_ksymbol-when-oopsing-in-module-init
+++ a/kernel/module.c
@@ -2003,7 +2003,8 @@ static void add_kallsyms(struct module *
 
 	mod->symtab = (void *)symsec->sh_addr;
 	mod->num_symtab = symsec->sh_size / sizeof(Elf_Sym);
-	mod->strtab = info->strtab;
+	/* Make sure we get permanent strtab: don't use info->strtab. */
+	mod->strtab = (void *)info->sechdrs[info->index.str].sh_addr;
 
 	/* Set types up while we still have access to sections. */
 	for (i = 0; i < mod->num_symtab; i++)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

linux-next.patch
module-fix-crash-in-get_ksymbol-when-oopsing-in-module-init.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
modpost-support-objects-with-more-than-64k-sections.patch
kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
init-mainc-fix-warning-calltimetv64-may-be-used-uninitialized.patch
init-mainc-mark-do_one_initcall-as-__init_or_module.patch
reiser4.patch

