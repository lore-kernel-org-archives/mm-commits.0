From: akpm@linux-foundation.org
Subject: - modules-handle-symbols-that-have-a-zero-value-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:37:01 -0800
Message-ID: <200802080836.m188ag3T015867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756543AbYBHIhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:37:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ak@suse.de, clameter@sgi.com, kay.sievers@vrfy.org, mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     module: fix __find_symbl() error checks
has been removed from the -mm tree.  Its filename was
     modules-handle-symbols-that-have-a-zero-value-fix.patch

This patch was dropped because it was folded into modules-handle-symbols-that-have-a-zero-value.patch

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
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
