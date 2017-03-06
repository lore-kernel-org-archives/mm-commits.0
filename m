From: akpm@linux-foundation.org
Subject: + bcache-use-kvmalloc.patch added to -mm tree
Date: Mon, 06 Mar 2017 13:48:19 -0800
Message-ID: <58bdd923./YlkW+fN4lhUeP5G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754791AbdCGD1R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 22:27:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, kent.overstreet@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/md/bcache/super.c: use kvmalloc
has been added to the -mm tree.  Its filename is
     bcache-use-kvmalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bcache-use-kvmalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bcache-use-kvmalloc.patch

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
Subject: drivers/md/bcache/super.c: use kvmalloc

bcache_device_init uses kmalloc for small requests and vmalloc for those
which are larger than 64 pages.  This alone is a strange criterion. 
Moreover kmalloc can fallback to vmalloc on the failure.  Let's simply use
kvmalloc instead as it knows how to handle the fallback properly

Link: http://lkml.kernel.org/r/20170306103327.2766-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/super.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/md/bcache/super.c~bcache-use-kvmalloc drivers/md/bcache/super.c
--- a/drivers/md/bcache/super.c~bcache-use-kvmalloc
+++ a/drivers/md/bcache/super.c
@@ -767,16 +767,12 @@ static int bcache_device_init(struct bca
 	}
 
 	n = d->nr_stripes * sizeof(atomic_t);
-	d->stripe_sectors_dirty = n < PAGE_SIZE << 6
-		? kzalloc(n, GFP_KERNEL)
-		: vzalloc(n);
+	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
 	if (!d->stripe_sectors_dirty)
 		return -ENOMEM;
 
 	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
-	d->full_dirty_stripes = n < PAGE_SIZE << 6
-		? kzalloc(n, GFP_KERNEL)
-		: vzalloc(n);
+	d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
 	if (!d->full_dirty_stripes)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from mhocko@suse.com are

lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
mm-introduce-kvalloc-helpers.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch

