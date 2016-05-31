From: akpm@linux-foundation.org
Subject: + sh-get-rid-of-superfluous-__gfp_repeat.patch added to -mm tree
Date: Tue, 31 May 2016 12:53:39 -0700
Message-ID: <574debc3.lKkN4mT8MYofGzIH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbcEaTxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, dalias@libc.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: get rid of superfluous __GFP_REPEAT
has been added to the -mm tree.  Its filename is
     sh-get-rid-of-superfluous-__gfp_repeat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-get-rid-of-superfluous-__gfp_repeat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-get-rid-of-superfluous-__gfp_repeat.patch

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
Subject: sh: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

PGALLOC_GFP uses __GFP_REPEAT but {pgd,pmd}_alloc allocate from
{pgd,pmd}_cache but both caches are allocating up to PAGE_SIZE objects. 
This means that this flag has never been actually useful here because it
has always been used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-15-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/mm/pgtable.c~sh-get-rid-of-superfluous-__gfp_repeat arch/sh/mm/pgtable.c
--- a/arch/sh/mm/pgtable.c~sh-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/sh/mm/pgtable.c
@@ -1,7 +1,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 
-#define PGALLOC_GFP GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO
+#define PGALLOC_GFP GFP_KERNEL | __GFP_ZERO
 
 static struct kmem_cache *pgd_cachep;
 #if PAGETABLE_LEVELS > 2
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

