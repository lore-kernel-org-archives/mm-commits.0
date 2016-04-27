From: akpm@linux-foundation.org
Subject: + include-linux-hugetlb-clean-up-code.patch added to -mm tree
Date: Wed, 27 Apr 2016 14:05:18 -0700
Message-ID: <5721298e.4OTdo//dqfuiQzlJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbcD0VFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 17:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/hugetlb*.h: clean up code
has been added to the -mm tree.  Its filename is
     include-linux-hugetlb-clean-up-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-hugetlb-clean-up-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-hugetlb-clean-up-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: include/linux/hugetlb*.h: clean up code

Macro HUGETLBFS_SB is clear enough, so one statement is clearer than 3
lines statements.

Remove redundant return statements for non-return functions, which can
save lines, at least.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h        |    4 +---
 include/linux/hugetlb_cgroup.h |    4 ----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN include/linux/hugetlb.h~include-linux-hugetlb-clean-up-code include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~include-linux-hugetlb-clean-up-code
+++ a/include/linux/hugetlb.h
@@ -353,9 +353,7 @@ extern unsigned int default_hstate_idx;
 
 static inline struct hstate *hstate_inode(struct inode *i)
 {
-	struct hugetlbfs_sb_info *hsb;
-	hsb = HUGETLBFS_SB(i->i_sb);
-	return hsb->hstate;
+	return HUGETLBFS_SB(i->i_sb)->hstate;
 }
 
 static inline struct hstate *hstate_file(struct file *f)
diff -puN include/linux/hugetlb_cgroup.h~include-linux-hugetlb-clean-up-code include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~include-linux-hugetlb-clean-up-code
+++ a/include/linux/hugetlb_cgroup.h
@@ -93,20 +93,17 @@ hugetlb_cgroup_commit_charge(int idx, un
 			     struct hugetlb_cgroup *h_cg,
 			     struct page *page)
 {
-	return;
 }
 
 static inline void
 hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages, struct page *page)
 {
-	return;
 }
 
 static inline void
 hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 			       struct hugetlb_cgroup *h_cg)
 {
-	return;
 }
 
 static inline void hugetlb_cgroup_file_init(void)
@@ -116,7 +113,6 @@ static inline void hugetlb_cgroup_file_i
 static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
 					  struct page *newhpage)
 {
-	return;
 }
 
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

include-linux-hugetlb-clean-up-code.patch

