From: akpm@linux-foundation.org
Subject: + efi-remove-unused-variables-in-__map_region.patch added to -mm
 tree
Date: Tue, 10 Dec 2013 15:23:08 -0800
Message-ID: <52a7a25c.uK5ApAhzaD8T692K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LJXXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + efi-remove-unused-variables-in-__map_region.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:08 -0800


The patch titled
     Subject: efi: remove unused variables in __map_region
has been added to the -mm tree.  Its filename is
     efi-remove-unused-variables-in-__map_region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-remove-unused-variables-in-__map_region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-remove-unused-variables-in-__map_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: efi: remove unused variables in __map_region

variables size and end is useless in this function, thus remove them.

Signed-off-by: Dave Young <dyoung@redhat.com>
Reported-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/efi/efi_64.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/x86/platform/efi/efi_64.c~efi-remove-unused-variables-in-__map_region arch/x86/platform/efi/efi_64.c
--- a/arch/x86/platform/efi/efi_64.c~efi-remove-unused-variables-in-__map_region
+++ a/arch/x86/platform/efi/efi_64.c
@@ -148,15 +148,11 @@ void efi_setup_page_tables(void)
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
-	unsigned long pf = 0, size;
-	u64 end;
+	unsigned long pf = 0;
 
 	if (!(md->attribute & EFI_MEMORY_WB))
 		pf |= _PAGE_PCD;
 
-	size = md->num_pages << PAGE_SHIFT;
-	end  = va + size;
