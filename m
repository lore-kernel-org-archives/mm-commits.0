From: akpm@linux-foundation.org
Subject: + mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
 added to -mm tree
Date: Fri, 10 Jun 2016 14:57:15 -0700
Message-ID: <575b37bb.rpyBUNhpe6Yz/X5A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbcFJV5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 17:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: restrict gfp mask in mpage_alloc
has been added to the -mm tree.  Its filename is
     mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch

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
Subject: mm: restrict gfp mask in mpage_alloc

Sergey has reported that we might hit BUG_ON in new_slab() because
unrestricted gfp mask used for the readahead purposes contains
incompatible flags (__GFP_HIGHMEM in his case):
[  429.191962] gfp: 2
[  429.192634] ------------[ cut here ]------------
[  429.193281] kernel BUG at mm/slub.c:1616!
[...]
[  429.217369]  [<ffffffff811ca221>] bio_alloc_bioset+0xbd/0x1b1
[  429.218013]  [<ffffffff81148078>] mpage_alloc+0x28/0x7b
[  429.218650]  [<ffffffff8114856a>] do_mpage_readpage+0x43d/0x545
[  429.219282]  [<ffffffff81148767>] mpage_readpages+0xf5/0x152

Make sure that mpage_alloc always restricts the mask to GFP_KERNEL subset.
This is what was done before "mm, memcg: use consistent gfp flags during
readahead" explicitly by mapping_gfp_constraint(mapping, GFP_KERNEL) in
mpage_readpages.

Link: http://lkml.kernel.org/r/20160610074223.GC32285@dhcp22.suse.cz
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/mpage.c~mm-memcg-use-consistent-gfp-flags-during-readahead-fix fs/mpage.c
--- a/fs/mpage.c~mm-memcg-use-consistent-gfp-flags-during-readahead-fix
+++ a/fs/mpage.c
@@ -71,6 +71,8 @@ mpage_alloc(struct block_device *bdev,
 {
 	struct bio *bio;
 
+	/* Restrict the given (page cache) mask for slab allocations */
+	gfp_flags &= GFP_KERNEL;
 	bio = bio_alloc(gfp_flags, nr_vecs);
 
 	if (bio == NULL && (current->flags & PF_MEMALLOC)) {
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
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch

