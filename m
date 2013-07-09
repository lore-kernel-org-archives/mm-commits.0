From: akpm@linux-foundation.org
Subject: +
 ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch added to -mm tree
Date: Tue, 09 Jul 2013 15:23:49 -0700
Message-ID: <51dc8d75.IL0YynA2sjYKw3J5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3GIWXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 18:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, guz.fnst@cn.fujitsu.com, akpm@linux-foundation.org

Subject: + ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch added to -mm tree
To: akpm@linux-foundation.org,guz.fnst@cn.fujitsu.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 15:23:49 -0700


The patch titled
     Subject: ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix
has been added to the -mm tree.  Its filename is
     ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix

fix layout, per Joel

Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix
+++ a/fs/ocfs2/refcounttree.c
@@ -2970,6 +2970,7 @@ int ocfs2_duplicate_clusters_by_page(han
 			mlog_errno(ret);
 			break;
 		}
+
 		/*
 		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
 		 * can't be dirtied before we CoW it out.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
partitions-add-aix-lvm-partition-support-files.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

