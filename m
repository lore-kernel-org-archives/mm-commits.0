Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8BF7261E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906305; cv=none; b=Pab0lUf7YXZA8wQXu681/ZTBg6DIrtmqTj/twRZr6VWg7EW2Y9Mcgto2i6X94xGu9w+KM6+HDdJtXdMr4C9rLQ//lF0uO733/wOWBvkDq+DP2USVsjykr1fAMff9indntyRzl67a6/cyXcG8RNL66UWw/juH30tPRQZ0PSgGI4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906305; c=relaxed/simple;
	bh=jNGj5BLrMIN8vYfSbPJCHEf+BiexXKpZWe5zg/d1d98=;
	h=Date:To:From:Subject:Message-Id; b=O2dZ2IOiTCArx4kkSkgOuuJYZILtTSYKi6jpD3xvFAFsDshp8q9YKhKR9riYocQdsTRbRNcW5QFe4lij9m0PrxmhVS535KQpxqhUmIfI6iwWo/lGhgOIyi4Nl4BNfK7tLrA6Y05+1dzUSdc8GdLEEHruolZN43mGvbM3505Vcio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ke9nUbRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ke9nUbRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7327EC116D0;
	Wed, 12 Nov 2025 00:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762906305;
	bh=jNGj5BLrMIN8vYfSbPJCHEf+BiexXKpZWe5zg/d1d98=;
	h=Date:To:From:Subject:From;
	b=ke9nUbRpXRVmKf3KcnSUGYGJwfQWae0LKZZfhXdo7VQaS3m4Ti5snfptOTQr4a6RW
	 Xp6rOxyaX/yRrpgfBIVxjBaf45rznyiLrQxE4cpIbm2PibEeitgHqXHti5b77okZ1Q
	 0RPD0CIacSS4JMX2XTapFQdwMRFnbCsxDm/bRlZ4=
Date: Tue, 11 Nov 2025 16:11:44 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,maddy@linux.ibm.com,gregkh@linuxfoundation.org,donettom@linux.ibm.com,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,christophe.leroy@csgroup.eu,aboorvad@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] drivers-base-node-fold-register_node-into-register_one_node-fix.patch removed from -mm tree
Message-Id: <20251112001145.7327EC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers-base-node-fold-register_node-into-register_one_node-fix
has been removed from the -mm tree.  Its filename was
     drivers-base-node-fold-register_node-into-register_one_node-fix.patch

This patch was dropped because it was folded into drivers-base-node-fold-register_node-into-register_one_node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-base-node-fold-register_node-into-register_one_node-fix
Date: Wed Oct 15 02:17:42 PM PDT 2025

fix kerneldoc, per David

Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/node.c~drivers-base-node-fold-register_node-into-register_one_node-fix
+++ a/drivers/base/node.c
@@ -882,7 +882,7 @@ void register_memory_blocks_under_node_h
 
 /**
  * register_node - Initialize and register the node device.
- * @nid - Node number to use when creating the device.
+ * @nid: Node number to use when creating the device.
  *
  * Return: 0 on success, -errno otherwise
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-base-node-fold-register_node-into-register_one_node.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
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

