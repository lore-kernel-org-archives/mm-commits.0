From: akpm@linux-foundation.org
Subject: + fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch added
 to -mm tree
Date: Wed, 26 Feb 2014 15:36:33 -0800
Message-ID: <530e7a81.zdxcysPgPpZrmzie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaBZXge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:36:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swhiteho@redhat.com, fabf@skynet.be

Subject: + fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch added to -mm tree
To: fabf@skynet.be,swhiteho@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:36:33 -0800


The patch titled
     Subject: fs/gfs2/quota.c: replace kmalloc - __vmalloc / memset 0
has been added to the -mm tree.  Its filename is
     fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
