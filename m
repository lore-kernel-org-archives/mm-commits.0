From: akpm@linux-foundation.org
Subject: +
 slab-make-gfp_slab_bug_mask-information-more-human-readable.patch added to
 -mm tree
Date: Fri, 10 Jun 2016 15:01:00 -0700
Message-ID: <575b389c.qvb/c+34lTbvjnUj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbcFJWBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 18:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: make GFP_SLAB_BUG_MASK information more human readable
has been added to the -mm tree.  Its filename is
     slab-make-gfp_slab_bug_mask-information-more-human-readable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-make-gfp_slab_bug_mask-information-more-human-readable.patch

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
Subject: slab: make GFP_SLAB_BUG_MASK information more human readable

printk offers %pGg for quite some time so let's use it to get a human
readable list of invalid flags.

The original output would be
[  429.191962] gfp: 2

after the change
[  429.191962] Unexpected gfp: 0x2 (__GFP_HIGHMEM)

Link: http://lkml.kernel.org/r/1465548200-11384-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 mm/slub.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-make-gfp_slab_bug_mask-information-more-human-readable mm/slab.c
--- a/mm/slab.c~slab-make-gfp_slab_bug_mask-information-more-human-readable
+++ a/mm/slab.c
@@ -2686,7 +2686,8 @@ static struct page *cache_grow_begin(str
 	 * critical path in kmem_cache_alloc().
 	 */
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
+		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
 		BUG();
 	}
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
diff -puN mm/slub.c~slab-make-gfp_slab_bug_mask-information-more-human-readable mm/slub.c
--- a/mm/slub.c~slab-make-gfp_slab_bug_mask-information-more-human-readable
+++ a/mm/slub.c
@@ -1612,7 +1612,8 @@ out:
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
+		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
 		BUG();
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.com are

tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
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
arm-get-rid-of-superfluous-__gfp_repeat.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch

