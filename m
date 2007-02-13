From: akpm@linux-foundation.org
Subject: + broken-config_compat_vdso-on-i386.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:27:17 -0800
Message-ID: <200702130727.l1D7RHF2024946@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57607 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbXBMH27 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:28:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ak@muc.de, mingo@elte.hu, stable@kernel.org, yifeng@google.com


The patch titled
     broken CONFIG_COMPAT_VDSO on i386
has been added to the -mm tree.  Its filename is
     broken-config_compat_vdso-on-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: broken CONFIG_COMPAT_VDSO on i386
From: "Jan Beulich" <jbeulich@novell.com>

After updating several machines to 2.6.20, I can't boot anymore the single
one of them that supports the NX bit and is configured as a 32-bit system.

My understanding is that the VDSO changes in 2.6.20-rc7 were not fully
cooked, in that with that config option enabled VDSO_SYM(x) now equals x,
meaning that an address in the fixmap area is now being passed to apps via
AT_SYSINFO.  However, the page is mapped with PAGE_READONLY rather than
PAGE_READONLY_EXEC.

I'm not certain whether having app code go through the fixmap area is
intended, but in case it is here is the simple patch that makes things work
again.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@muc.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Yi Feng" <yifeng@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/sysenter.c~broken-config_compat_vdso-on-i386 arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~broken-config_compat_vdso-on-i386
+++ a/arch/i386/kernel/sysenter.c
@@ -78,7 +78,7 @@ int __init sysenter_setup(void)
 	syscall_pages[0] = virt_to_page(syscall_page);
 
 #ifdef CONFIG_COMPAT_VDSO
-	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY);
+	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY_EXEC);
 	printk("Compat vDSO mapped to %08lx.\n", __fix_to_virt(FIX_VDSO));
 #endif
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
broken-config_compat_vdso-on-i386.patch
