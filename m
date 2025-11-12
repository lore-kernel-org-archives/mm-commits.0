Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A54217C77
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906432; cv=none; b=Oz0mN35f73C59va8HPm1bMNm09fxRvx8Y0x79oNP+XACEmj10LeMC7snNURbkAD9rQFfcd7GCoyj7tKefgZ9UDUySlyaftkASBEs3BQdj7At8qn0IrOni4hIZLgC93ox0LTuDlBHRwsyit2jQ4XpK0++J7uilkhNgTaQbz/AaBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906432; c=relaxed/simple;
	bh=O36oK8jM9JdevAEBTGXsS335GQ0j+UeQ57Bmypb5upc=;
	h=Date:To:From:Subject:Message-Id; b=s7GvvNCTLtH+qMJ7tKaFq292NCWBuaC6mRqkNbn3ycBycC1TLJp9SziXuDPDOx8WG9E+M5yPo5TjsWgpaR5M3aexAut0akW7oKQlDGS8luJOjR7CpQVld4laq2eJyy6QTFBK/Bl1Clc3hvTnD8TeNOAl6ihg+45ZlXLd2WozH18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yQFL6ojT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yQFL6ojT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B822C16AAE;
	Wed, 12 Nov 2025 00:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762906432;
	bh=O36oK8jM9JdevAEBTGXsS335GQ0j+UeQ57Bmypb5upc=;
	h=Date:To:From:Subject:From;
	b=yQFL6ojTTDlfsAC/1enkjmUu11qyVtagcBSsFDfvxQH7qHCxNuMpyletcwJI4MY7s
	 M/xFMH8Q+ZcU9kNaAnOTO+EqW7P+yqDkMbxW1l80sLQNBQx7u9mnWZT174sageDfS7
	 5fM06+jMzhF/TbdmxsPfp+/tbyBOI1Ru7MhKPays=
Date: Tue, 11 Nov 2025 16:13:51 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jingsusu@didiglobal.com,donettom@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch removed from -mm tree
Message-Id: <20251112001352.3B822C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmstat-fix-indentation-in-fold_diff-function-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch

This patch was dropped because it was folded into mm-vmstat-fix-indentation-in-fold_diff-function.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstat-fix-indentation-in-fold_diff-function-fix
Date: Tue Oct 21 12:45:37 PM PDT 2025

add braces, per Vlastimil & Liam

Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jing Su <jingsusu@didiglobal.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-fix-indentation-in-fold_diff-function-fix
+++ a/mm/vmstat.c
@@ -778,17 +778,19 @@ static int fold_diff(int *zone_diff, int
 	int i;
 	bool changed = false;
 
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 		if (zone_diff[i]) {
 			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
 			changed = true;
 		}
+	}
 
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 		if (node_diff[i]) {
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
 			changed = true;
 		}
+	}
 
 	return changed;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmstat-fix-indentation-in-fold_diff-function.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
liveupdate-luo_file-implement-file-systems-callbacks-fix.patch
mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

