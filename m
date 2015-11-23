From: akpm@linux-foundation.org
Subject: [merged]
 writeback-initialize-m_dirty-to-avoid-compile-warning.patch removed from
 -mm tree
Date: Mon, 23 Nov 2015 12:15:09 -0800
Message-ID: <565373cd.5RaaiQHC2RB+teAu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbbKWUPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: initialize m_dirty to avoid compile warning
has been removed from the -mm tree.  Its filename was
     writeback-initialize-m_dirty-to-avoid-compile-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm/page-writeback.c: initialize m_dirty to avoid compile warning

When building kernel with gcc 5.2, the below warning is raised:

mm/page-writeback.c: In function 'balance_dirty_pages.isra.10':
mm/page-writeback.c:1545:17: warning: 'm_dirty' may be used uninitialized in this function [-Wmaybe-uninitialized]
   unsigned long m_dirty, m_thresh, m_bg_thresh;

The m_dirty{thresh, bg_thresh} are initialized in the block of "if
(mdtc)", so if mdts is null, they won't be initialized before being used. 
Initialize m_dirty to zero, also initialize m_thresh and m_bg_thresh to
keep consistency.

They are used later by if condition: !mdtc || m_dirty <=
dirty_freerun_ceiling(m_thresh, m_bg_thresh)

If mdtc is null, dirty_freerun_ceiling will not be called at all, so the
initialization will not change any behavior other than just ceasing the
compile warning.

(akpm: the patch actually reduces .text size by ~20 bytes on gcc-4.x.y)

[akpm@linux-foundation.org: add comment]
Signed-off-by: Yang Shi <yang.shi@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-initialize-m_dirty-to-avoid-compile-warning mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-initialize-m_dirty-to-avoid-compile-warning
+++ a/mm/page-writeback.c
@@ -1542,7 +1542,9 @@ static void balance_dirty_pages(struct a
 	for (;;) {
 		unsigned long now = jiffies;
 		unsigned long dirty, thresh, bg_thresh;
-		unsigned long m_dirty, m_thresh, m_bg_thresh;
+		unsigned long m_dirty = 0;	/* stop bogus uninit warnings */
+		unsigned long m_thresh = 0;
+		unsigned long m_bg_thresh = 0;
 
 		/*
 		 * Unstable writes are a feature of certain networked
_

Patches currently in -mm which might be from yang.shi@linaro.org are


