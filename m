From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-memcontrol-convert-anon-and-file-thp-to-new-mem=5Fcgr?=
 =?US-ASCII?Q?oup=5Fcharge-api-fix.patch?= added to -mm tree
Date: Wed, 13 May 2020 15:00:20 -0700
Message-ID: <20200513220020.mlJqzy-rb%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730124AbgEMWAV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 May 2020 18:00:21 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, hannes@cmpxchg.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix

Fix crash.  If you have CONFIG_NUMA and the allocation fails, *hpage could
contain an ERR_PTR instead of being NULL.

Link: http://lkml.kernel.org/r/20200512215813.GA487759@cmpxchg.org
Reported-by: Qian Cai <cai@lca.pw>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix
+++ a/mm/khugepaged.c
@@ -1097,7 +1097,7 @@ static void collapse_huge_page(struct mm
 out_up_write:
 	up_write(&mm->mmap_sem);
 out_nolock:
-	if (*hpage)
+	if (!IS_ERR_OR_NULL(*hpage))
 		mem_cgroup_uncharge(*hpage);
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
@@ -1834,7 +1834,7 @@ xa_unlocked:
 	unlock_page(new_page);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	if (*hpage)
+	if (!IS_ERR_OR_NULL(*hpage))
 		mem_cgroup_uncharge(*hpage);
 	/* TODO: tracepoints */
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch
mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-shmem-remove-rare-optimization-when-swapin-races-with-hole-punching.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
