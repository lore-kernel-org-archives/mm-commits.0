Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E4947796
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421773; cv=none; b=Hdj9ILNqRn4MsMcLXJCczQ9r5q9JgcjC+3gLEU4LWA50CzQ1/AmxiJHT1hjonzIozz0k75FAd8a42OUnLt3ZYoPyVtjalK/2ohRAwg44TVuxp5OV5+SPlnwB4Mfjj7bWGlt51ESMA3gP1g6SIAIFSnkvbSCX3SQwg883f7BqDt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421773; c=relaxed/simple;
	bh=0f20+GSnv8/bxtJ+m5dvlVbrxPt3SjgMMB15pWUupCA=;
	h=Date:To:From:Subject:Message-Id; b=BQx26yN4Rl3SI6sOfZGoJk4dSK6nqj8Rh7hUyKZAXzSjjexx7ZPoDwp+vBbxbc049IIYa2jmH1bl7GJSfh/dVJ9GDSQO+13ZnfkY3/VD9pIKhP6Bywpm/B4A+7cQdNsvBnFe9mPrb56eHMDhso3ZJqJpOXKH2eYclji9p+LmYaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1quuZRxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1quuZRxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4EEC4CEC2;
	Wed,  4 Sep 2024 03:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421773;
	bh=0f20+GSnv8/bxtJ+m5dvlVbrxPt3SjgMMB15pWUupCA=;
	h=Date:To:From:Subject:From;
	b=1quuZRxJFufHhfLQ+0zDbMKdY9KmBM63XgX9bzVV5AkU0MTzGDZO2iW1eCsgSMxRW
	 7NXMgeN5mcZGYmunzPpZnydi1gdwtSzJQKcz0sgYqL68UaEdHoHHS3X3ObD2ilVfAZ
	 U3qxEEb81u9hlEX6qoPL2wTXZE5W0wwRFw900uzc=
Date: Tue, 03 Sep 2024 20:49:32 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,david@redhat.com,chrisl@kernel.org,baohua@kernel.org,21cnbao@gmail.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2.patch removed from -mm tree
Message-Id: <20240904034933.2E4EEC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: check all swaps belong to same swap_cgroup in swap_pte_batch() fix
has been removed from the -mm tree.  Its filename was
     mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2.patch

This patch was dropped because it was folded into mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: check all swaps belong to same swap_cgroup in swap_pte_batch() fix
Date: Sun, 25 Aug 2024 13:09:46 -0700 (PDT)

mm-unstable swap_pte_batch() adds a new usage of lookup_swap_cgroup_id(),
which crashes if CONFIG_MEMCG kernel booted with "cgroup_disable=memory":
it now needs a mem_cgroup_disabled() check.

Link: https://lkml.kernel.org/r/33f34a88-0130-5444-9b84-93198eeb50e7@google.com
Fixes: 92b50df44566 ("mm: check all swaps belong to same swap_cgroup in swap_pte_batch()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap_cgroup.c~mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2
+++ a/mm/swap_cgroup.c
@@ -161,6 +161,8 @@ unsigned short swap_cgroup_record(swp_en
  */
 unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
+	if (mem_cgroup_disabled())
+		return 0;
 	return lookup_swap_cgroup(ent, NULL)->id;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order-fix.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch
mm-shmem-support-large-folio-swap-out-fix.patch
mm-restart-if-multiple-traversals-raced-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

