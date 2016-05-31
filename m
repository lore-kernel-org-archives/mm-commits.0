From: akpm@linux-foundation.org
Subject: + x86-efi-get-rid-of-superfluous-__gfp_repeat.patch added to -mm
 tree
Date: Tue, 31 May 2016 12:53:17 -0700
Message-ID: <574debad.IC2wOOeJO4a3Kus9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbcEaTxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, matt@codeblueprint.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/efi: get rid of superfluous __GFP_REPEAT
has been added to the -mm tree.  Its filename is
     x86-efi-get-rid-of-superfluous-__gfp_repeat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-efi-get-rid-of-superfluous-__gfp_repeat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch
tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch

