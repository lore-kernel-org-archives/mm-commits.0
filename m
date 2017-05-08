From: akpm@linux-foundation.org
Subject: [patch 060/114] drivers/md/dm-ioctl.c: use kvmalloc rather
 than opencoded variant
Date: Mon, 08 May 2017 15:57:34 -0700
Message-ID: <20170508225734.dxLUd9xkJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbdEHW5g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, mpatocka@redhat.com, snitzer@redhat.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
@@ -1691,6 +1691,7 @@ static int copy_params(struct dm_ioctl _
 	struct dm_ioctl *dmi;
 	int secure_data;
 	const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
+	unsigned noio_flag;
 
 	if (copy_from_user(param_kernel, user, minimum_data_size))
 		return -EFAULT;
@@ -1713,15 +1714,9 @@ static int copy_params(struct dm_ioctl _
 	 * Use kmalloc() rather than vmalloc() when we can.
 	 */
 	dmi = NULL;
-	if (param_kernel->data_size <= KMALLOC_MAX_SIZE)
-		dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
