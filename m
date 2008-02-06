From: akpm@linux-foundation.org
Subject: + modules-handle-symbols-that-have-a-zero-value-fix.patch added to -mm tree
Date: Wed, 06 Feb 2008 09:51:55 -0800
Message-ID: <200802061751.m16HpaP9022815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828AbYBFRwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 12:52:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, ak@suse.de, clameter@sgi.com, kay.sievers@vrfy.org, mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au


The patch titled
     module: fix __find_symbl() error checks
has been added to the -mm tree.  Its filename is
     modules-handle-symbols-that-have-a-zero-value-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: module: fix __find_symbl() error checks
From: Akinobu Mita <akinobu.mita@gmail.com>

The patch:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/broken-out/modules-handle-symbols-that-have-a-zero-value.patch

changes the return value of __find_symbol() so that it can handle symbols
that are zero and now it returns -errno for failure.

But some __find_symbl() error checks remain unchanged.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/module.c~modules-handle-symbols-that-have-a-zero-value-fix kernel/module.c
--- a/kernel/module.c~modules-handle-symbols-that-have-a-zero-value-fix
+++ a/kernel/module.c
@@ -982,7 +982,7 @@ static unsigned long resolve_symbol(Elf_
 
 	ret = __find_symbol(name, &owner, &crc,
 			!(mod->taints & TAINT_PROPRIETARY_MODULE));
-	if (ret) {
+	if (!IS_ERR_VALUE(ret)) {
 		/* use_module can fail due to OOM,
 		   or module initialization or unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
@@ -1382,7 +1382,9 @@ void *__symbol_get(const char *symbol)
 
 	preempt_disable();
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	if (value && strong_try_module_get(owner) != 0)
+	if (IS_ERR_VALUE(value))
+		value = 0;
+	else if (strong_try_module_get(owner))
 		value = 0;
 	preempt_enable();
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fs-use-hlist_unhashed.patch
fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
ext-fix-comment-for-nonexistent-variable.patch
ext-use-ext_get_group_desc.patch
ext-remove-unused-argument-for-ext_find_goal.patch
ext-cleanup-ext_bg_num_gdb.patch
git-dvb.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
