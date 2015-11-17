From: akpm@linux-foundation.org
Subject: + writeback-initialize-m_dirty-to-avoid-compile-warning.patch
 added to -mm tree
Date: Tue, 17 Nov 2015 15:40:04 -0800
Message-ID: <564bbad4.ZRqWBLL3xq30iitn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbKQXkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 18:40:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: initialize m_dirty to avoid compile warning
has been added to the -mm tree.  Its filename is
     writeback-initialize-m_dirty-to-avoid-compile-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-initialize-m_dirty-to-avoid-compile-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-initialize-m_dirty-to-avoid-compile-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Yang Shi <yang.shi@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-initialize-m_dirty-to-avoid-compile-warning mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-initialize-m_dirty-to-avoid-compile-warning
+++ a/mm/page-writeback.c
@@ -1542,7 +1542,7 @@ static void balance_dirty_pages(struct a
 	for (;;) {
 		unsigned long now = jiffies;
 		unsigned long dirty, thresh, bg_thresh;
-		unsigned long m_dirty, m_thresh, m_bg_thresh;
+		unsigned long m_dirty = 0, m_thresh = 0, m_bg_thresh = 0;
 
 		/*
 		 * Unstable writes are a feature of certain networked
_

Patches currently in -mm which might be from yang.shi@linaro.org are

writeback-initialize-m_dirty-to-avoid-compile-warning.patch

