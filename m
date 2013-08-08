From: akpm@linux-foundation.org
Subject: + fs-bio-integrity-fix-a-potential-mem-leak.patch added to -mm
 tree
Date: Thu, 08 Aug 2013 12:52:59 -0700
Message-ID: <5203f71b.pF+68WjIUXmEGMLi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966159Ab3HHTw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 15:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, guz.fnst@cn.fujitsu.com

Subject: + fs-bio-integrity-fix-a-potential-mem-leak.patch added to -mm tree
To: guz.fnst@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 12:52:59 -0700


The patch titled
     Subject: fs/bio-integrity: fix a potential mem leak
has been added to the -mm tree.  Its filename is
     fs-bio-integrity-fix-a-potential-mem-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-bio-integrity-fix-a-potential-mem-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-bio-integrity-fix-a-potential-mem-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
