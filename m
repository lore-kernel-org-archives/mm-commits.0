From: akpm@linux-foundation.org
Subject: [patch 07/41] x86/efi: get rid of superfluous __GFP_REPEAT
Date: Fri, 24 Jun 2016 14:48:53 -0700
Message-ID: <576daac5.C7+5hq2vZlRDiUoF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbcFXVsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, matt@codeblueprint.co.uk

From: Michal Hocko <mhocko@suse.com>
Subject: x86/efi: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

efi_alloc_page_tables uses __GFP_REPEAT but it allocates an order-0 page. 
This means that this flag has never been actually useful here because it
has always been used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-4-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/efi/efi_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/platform/efi/efi_64.c~x86-efi-get-rid-of-superfluous-__gfp_repeat arch/x86/platform/efi/efi_64.c
--- a/arch/x86/platform/efi/efi_64.c~x86-efi-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/x86/platform/efi/efi_64.c
@@ -139,7 +139,7 @@ int __init efi_alloc_page_tables(void)
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return 0;
 
-	gfp_mask = GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO;
+	gfp_mask = GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO;
 	efi_pgd = (pgd_t *)__get_free_page(gfp_mask);
 	if (!efi_pgd)
 		return -ENOMEM;
_
