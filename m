From: akpm@linux-foundation.org
Subject: + arm-get-rid-of-superfluous-__gfp_repeat.patch added to -mm tree
Date: Tue, 31 May 2016 12:53:19 -0700
Message-ID: <574debaf.9E3NuE347wTQhgiu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbcEaTxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: get rid of superfluous __GFP_REPEAT
has been added to the -mm tree.  Its filename is
     arm-get-rid-of-superfluous-__gfp_repeat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-get-rid-of-superfluous-__gfp_repeat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-get-rid-of-superfluous-__gfp_repeat.patch

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
Subject: arm: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

PGALLOC_GFP uses __GFP_REPEAT but none of the allocation which uses this
flag is for more than order-2.  This means that this flag has never been
actually useful here because it has always been used only for
PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-5-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgalloc.h |    2 +-
 arch/arm/mm/pgd.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/include/asm/pgalloc.h~arm-get-rid-of-superfluous-__gfp_repeat arch/arm/include/asm/pgalloc.h
--- a/arch/arm/include/asm/pgalloc.h~arm-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/arm/include/asm/pgalloc.h
@@ -57,7 +57,7 @@ static inline void pud_populate(struct m
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
 
 static inline void clean_pte_table(pte_t *pte)
 {
diff -puN arch/arm/mm/pgd.c~arm-get-rid-of-superfluous-__gfp_repeat arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~arm-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/arm/mm/pgd.c
@@ -23,7 +23,7 @@
 #define __pgd_alloc()	kmalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL)
 #define __pgd_free(pgd)	kfree(pgd)
 #else
-#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_REPEAT, 2)
+#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
 #define __pgd_free(pgd)	free_pages((unsigned long)pgd, 2)
 #endif
 
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

