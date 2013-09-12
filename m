From: akpm@linux-foundation.org
Subject: [merged] fs-bio-integrity-fix-a-potential-mem-leak.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:46:11 -0700
Message-ID: <52321a03.RJl+SPFtBotoF3VF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3ILTqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, guz.fnst@cn.fujitsu.com

Subject: [merged] fs-bio-integrity-fix-a-potential-mem-leak.patch removed from -mm tree
To: guz.fnst@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:46:11 -0700


The patch titled
     Subject: fs/bio-integrity: fix a potential mem leak
has been removed from the -mm tree.  Its filename was
     fs-bio-integrity-fix-a-potential-mem-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: fs/bio-integrity: fix a potential mem leak

Free the bio_integrity_pool in the fail path of biovec_create_pool in
function bioset_integrity_create().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio-integrity.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/bio-integrity.c~fs-bio-integrity-fix-a-potential-mem-leak fs/bio-integrity.c
--- a/fs/bio-integrity.c~fs-bio-integrity-fix-a-potential-mem-leak
+++ a/fs/bio-integrity.c
@@ -716,13 +716,14 @@ int bioset_integrity_create(struct bio_s
 		return 0;
 
 	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size, bip_slab);
