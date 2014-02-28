From: akpm@linux-foundation.org
Subject: [merged] fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch
 removed from -mm tree
Date: Fri, 28 Feb 2014 11:20:13 -0800
Message-ID: <5310e16d.KrZHtBM1M6j/BMy7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaB1TUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 14:20:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swhiteho@redhat.com, fabf@skynet.be

Subject: [merged] fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch removed from -mm tree
To: fabf@skynet.be,swhiteho@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 11:20:13 -0800


The patch titled
     Subject: fs/gfs2/quota.c: replace kmalloc - __vmalloc / memset 0
has been removed from the -mm tree.  Its filename was
     fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/gfs2/quota.c: replace kmalloc - __vmalloc / memset 0

Use kzalloc and __vmalloc __GFP_ZERO for clean sd_quota_bitmap allocation.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/quota.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/gfs2/quota.c~fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0 fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0
+++ a/fs/gfs2/quota.c
@@ -1242,14 +1242,13 @@ int gfs2_quota_init(struct gfs2_sbd *sdp
 	bm_size = DIV_ROUND_UP(sdp->sd_quota_slots, 8 * sizeof(unsigned long));
 	bm_size *= sizeof(unsigned long);
 	error = -ENOMEM;
-	sdp->sd_quota_bitmap = kmalloc(bm_size, GFP_NOFS|__GFP_NOWARN);
+	sdp->sd_quota_bitmap = kzalloc(bm_size, GFP_NOFS | __GFP_NOWARN);
 	if (sdp->sd_quota_bitmap == NULL)
-		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS, PAGE_KERNEL);
+		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS |
+						 __GFP_ZERO, PAGE_KERNEL);
 	if (!sdp->sd_quota_bitmap)
 		return error;
 
-	memset(sdp->sd_quota_bitmap, 0, bm_size);
