From: akpm@linux-foundation.org
Subject: [patch 18/19] mm/memcontrol.c: move comments for get_mctgt_type() to proper position
Date: Fri, 27 May 2016 14:27:46 -0700
Message-ID: <5748bbd2.W/H01ty2PZykSNk8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbcE0V1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, roy.qing.li@gmail.com, hannes@cmpxchg.org, mhocko@suse.com

From: Li RongQing <roy.qing.li@gmail.com>
Subject: mm/memcontrol.c: move comments for get_mctgt_type() to proper position

Move the comments for get_mctgt_type() to be before get_mctgt_type()
implementation.

Link: http://lkml.kernel.org/r/1463644638-7446-1-git-send-email-roy.qing.li@gmail.com
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-move-comments-for-get_mctgt_type-to-proper-position mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-move-comments-for-get_mctgt_type-to-proper-position
+++ a/mm/memcontrol.c
@@ -4309,24 +4309,6 @@ static int mem_cgroup_do_precharge(unsig
 	return 0;
 }
 
-/**
- * get_mctgt_type - get target type of moving charge
- * @vma: the vma the pte to be checked belongs
- * @addr: the address corresponding to the pte to be checked
- * @ptent: the pte to be checked
- * @target: the pointer the target page or swap ent will be stored(can be NULL)
- *
- * Returns
- *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
- *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
- *     move charge. if @target is not NULL, the page is stored in target->page
- *     with extra refcnt got(Callers should handle it).
- *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
- *     target for charge migration. if @target is not NULL, the entry is stored
- *     in target->ent.
- *
- * Called with pte lock held.
- */
 union mc_target {
 	struct page	*page;
 	swp_entry_t	ent;
@@ -4515,6 +4497,25 @@ out:
 	return ret;
 }
 
+/**
+ * get_mctgt_type - get target type of moving charge
+ * @vma: the vma the pte to be checked belongs
+ * @addr: the address corresponding to the pte to be checked
+ * @ptent: the pte to be checked
+ * @target: the pointer the target page or swap ent will be stored(can be NULL)
+ *
+ * Returns
+ *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
+ *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
+ *     move charge. if @target is not NULL, the page is stored in target->page
+ *     with extra refcnt got(Callers should handle it).
+ *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
+ *     target for charge migration. if @target is not NULL, the entry is stored
+ *     in target->ent.
+ *
+ * Called with pte lock held.
+ */
+
 static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
_
