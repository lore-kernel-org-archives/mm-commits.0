From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb_cgroup-align-hugetlb-cgroup-limit-to-hugepage-size.patch added
 to -mm tree
Date: Fri, 08 Aug 2014 15:13:05 -0700
Message-ID: <53e54b71.Z/pc1p2V0LKEZM/S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:35614 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbaHHWNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 18:13:07 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so819305ykb.5
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 15:13:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aneesh.kumar@linux.vnet.ibm.com, lizefan@huawei.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb_cgroup: align hugetlb cgroup limit to hugepage size
has been added to the -mm tree.  Its filename is
     mm-hugetlb_cgroup-align-hugetlb-cgroup-limit-to-hugepage-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb_cgroup-align-hugetlb-cgroup-limit-to-hugepage-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb_cgroup-align-hugetlb-cgroup-limit-to-hugepage-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb_cgroup: align hugetlb cgroup limit to hugepage size

Memcg aligns memory.limit_in_bytes to PAGE_SIZE as part of the resource counter
since it makes no sense to allow a partial page to be charged.

As a result of the hugetlb cgroup using the resource counter, it is also aligned
to PAGE_SIZE but makes no sense unless aligned to the size of the hugepage being
limited.

Align hugetlb cgroup limit to hugepage size.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-align-hugetlb-cgroup-limit-to-hugepage-size mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-align-hugetlb-cgroup-limit-to-hugepage-size
+++ a/mm/hugetlb_cgroup.c
@@ -275,6 +275,7 @@ static ssize_t hugetlb_cgroup_write(stru
 		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
+		val = ALIGN(val, 1ULL << huge_page_shift(&hstates[idx]));
 		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
 		break;
 	default:
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
revert-slab-remove-bad_alien_magic.patch
vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
mm-hugetlb_cgroup-align-hugetlb-cgroup-limit-to-hugepage-size.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

