From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-new-hugetlb-cgroup-fix-3.patch added to -mm tree
Date: Tue, 26 Jun 2012 16:19:06 -0700
Message-ID: <20120626231906.C43D7A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50463 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2FZXTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 19:19:08 -0400
Received: by vcbfl13 with SMTP id fl13so52770vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 16:19:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com


The patch titled
     Subject: hugetlb/cgroup: remove unnecessary NULL checks
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-new-hugetlb-cgroup-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: remove unnecessary NULL checks

cgroup_subsys_state can never be NULL, so don't check for that in
hugetlb_cgroup_from_css.  Also current task will always be part of some
cgroup.  So hugetlb_cgrop_from_task cannot return NULL.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/hugetlb_cgroup.c~mm-hugetlb-add-new-hugetlb-cgroup-fix-3 mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-add-new-hugetlb-cgroup-fix-3
+++ a/mm/hugetlb_cgroup.c
@@ -32,9 +32,7 @@ struct hugetlb_cgroup *root_h_cgroup __r
 static inline
 struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
 {
-	if (s)
-		return container_of(s, struct hugetlb_cgroup, css);
-	return NULL;
+	return container_of(s, struct hugetlb_cgroup, css);
 }
 
 static inline
_
Subject: Subject: hugetlb/cgroup: remove unnecessary NULL checks

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-3.patch
mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-remove-unnecessary-null-checks.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch
memcg-rename-config-variables.patch

