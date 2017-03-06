From: akpm@linux-foundation.org
Subject: + md-use-kvmalloc-rather-than-opencoded-variant.patch added to
 -mm tree
Date: Mon, 06 Mar 2017 13:48:17 -0800
Message-ID: <58bdd921.Hz7Fr3C8/K8h1rhm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932524AbdCFWZy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 17:25:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mpatocka@redhat.com, snitzer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/md/dm-ioctl.c: use kvmalloc rather than opencoded variant
has been added to the -mm tree.  Its filename is
     md-use-kvmalloc-rather-than-opencoded-variant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/md-use-kvmalloc-rather-than-opencoded-variant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/md-use-kvmalloc-rather-than-opencoded-variant.patch

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
Subject: drivers/md/dm-ioctl.c: use kvmalloc rather than opencoded variant

copy_params uses kmalloc with vmalloc fallback.  We already have a helper
for that - kvmalloc.  This caller requires GFP_NOIO semantic so it hasn't
been converted with many others by previous patches.  All we need to
achieve this semantic is to use the scope memalloc_noio_{save,restore}
around kvmalloc.

Link: http://lkml.kernel.org/r/20170306103327.2766-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-ioctl.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/md/dm-ioctl.c~md-use-kvmalloc-rather-than-opencoded-variant drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~md-use-kvmalloc-rather-than-opencoded-variant
+++ a/drivers/md/dm-ioctl.c
@@ -1699,6 +1699,7 @@ static int copy_params(struct dm_ioctl _
 	struct dm_ioctl *dmi;
 	int secure_data;
 	const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
+	unsigned noio_flag;
 
 	if (copy_from_user(param_kernel, user, minimum_data_size))
 		return -EFAULT;
@@ -1721,15 +1722,9 @@ static int copy_params(struct dm_ioctl _
 	 * Use kmalloc() rather than vmalloc() when we can.
 	 */
 	dmi = NULL;
-	if (param_kernel->data_size <= KMALLOC_MAX_SIZE)
-		dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
-
-	if (!dmi) {
-		unsigned noio_flag;
-		noio_flag = memalloc_noio_save();
-		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
-		memalloc_noio_restore(noio_flag);
-	}
+	noio_flag = memalloc_noio_save();
+	dmi = kvmalloc(param_kernel->data_size, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
 
 	if (!dmi) {
 		if (secure_data && clear_user(user, param_kernel->data_size))
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

