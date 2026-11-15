Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794769170;
	b=tO1vk1fnaWuH5tYCMYT7ESAawJT3Ql6Nw0P5bBgcrOb747WGKgCTdKvf85FrXJoCLbll
	 Gh5xT+2rpsP3NNY9d0DQa+N6gtqCDbwnx+hTj9V3iugIQapC8N4pOPqonxcvfNWbCIlx5
	 H+YKg6rPYVt2HmAgsZQSkGof1P+xWqZuOX62HEPdjrWfoAp81mr2hsa9eu/lbfBa3NyCg
	 xJ/fhS3YORa2+t4iOReHp5DnJ3WeF0URaBgyoLFFvnePEFJ6Ec3WT4K3OqgPemVVTxqL5
	 dXd0qyvqI7e6j0JEY8jcXRolpdzog+VfdhpSSlm5pCs7dxK46Btxko6mpdD8WsYI5Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794769170;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9pKHueDy+TtXfBk1tR9Wh5a9d5174787mpUOF1dIP/U=;
	b=NNUSazl2iuLlYnsOxu4vePP2fQPDJutsizNRRVXB7EHOEYfyRMCOl7qLZKumnQXuodkK
	 NigSfsTWoZBa23RIvZhIM6nbzfADDGb/41E3B5xjntztJgAH8Gmgym2g4tF6bbS1CLW31
	 ARXMZQeVVXuqSbkzFL1ul2QrQS+darxnPpOPuH1lmUeThOQPnoDZDW6kOMobHvEz+Mu2b
	 nx/8o748TpIq6ZOb3JKDpIPE9rIjxCRz1vSRGeQpJFAxAvmZ8t3Ro3Jia1S3kzmtSMUWc
	 2uPv2A9gNGXZ4c0fN0Ms8tDuVywHrWtaoUJc+T+4aqP+jlFBDTsNZS04OtDd97IQv2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bJ4Sg1k+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9BB606A31E
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 18:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bJ4Sg1k+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568A31F000C4;
	Sun, 15 Nov 2026 18:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794769170;
	bh=9pKHueDy+TtXfBk1tR9Wh5a9d5174787mpUOF1dIP/U=;
	h=Date:To:From:Subject;
	b=bJ4Sg1k+HihSuxmFDcRpk0rZLsheRlrUpwfI2qLseMlWdVkRSuVZsA1U3l1zYxPGu
	 T3raByLpg1gGaEycCaE8eHCELMblGVNYuHUN0VyvKy6o2LRQryBiu9sv9gxp73QEcg
	 czMzZ3hXVf/PfN7u6IFLCRWxGOLlY7DXSp8kEvAc=
Date: Sun, 15 Nov 2026 10:59:29 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-cma-simplify-cma_declare_contiguous_multi-fix.patch removed from -mm tree
Message-Id: <20261115185930.568A31F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm-cma-simplify-cma_declare_contiguous_multi-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-simplify-cma_declare_contiguous_multi-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-simplify-cma_declare_contiguous_multi-fix
Date: Fri Nov 13 09:33:48 AM PST 2026

fix typo in comment

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-simplify-cma_declare_contiguous_multi-fix
+++ a/mm/cma.c
@@ -485,7 +485,7 @@ static phys_addr_t __init cma_find_free_
 	phys_addr_t max = 0;
 	u64 i;
 
-	/* no point searching if the system can't addres above 4G */
+	/* no point searching if the system can't address above 4G */
 	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
 		return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

