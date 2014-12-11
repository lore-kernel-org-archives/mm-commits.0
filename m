From: akpm@linux-foundation.org
Subject: [merged] frontswap-fix-the-condition-in-bug_on.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:42 -0800
Message-ID: <5489e926.8RNT8UljOv2jvlzc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbaLKS5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: omycle@gmail.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap.c: fix the condition in BUG_ON
has been removed from the -mm tree.  Its filename was
     frontswap-fix-the-condition-in-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Haifeng <omycle@gmail.com>
Subject: mm/frontswap.c: fix the condition in BUG_ON

The largest index of swap device is MAX_SWAPFILES-1.  So the type should
be less than MAX_SWAPFILES.

Signed-off-by: Haifeng Li <omycle@gmail.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/frontswap.c~frontswap-fix-the-condition-in-bug_on mm/frontswap.c
--- a/mm/frontswap.c~frontswap-fix-the-condition-in-bug_on
+++ a/mm/frontswap.c
@@ -182,7 +182,7 @@ void __frontswap_init(unsigned type, uns
 	if (frontswap_ops)
 		frontswap_ops->init(type);
 	else {
-		BUG_ON(type > MAX_SWAPFILES);
+		BUG_ON(type >= MAX_SWAPFILES);
 		set_bit(type, need_init);
 	}
 }
_

Patches currently in -mm which might be from omycle@gmail.com are

origin.patch

