Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D2033C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293225; cv=none; b=PSdIj79s6d6dcUnDhE64z9jjI8OOuFV5LFETARUXNcazuWItN/DNaucZ2hmvR3lasA+9Qhwd9wTSXlBQD5ZnVC3Ys+wAe0FOsfaqBLCKNizmh923UMuVLJusXHvyTZprHTdmHtNvsC/wuyggU7PcdAUrE3TeyEBZJViN6VTHrME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293225; c=relaxed/simple;
	bh=MqTYHYjw4MXQa15t0UVqWf6nNGw9O9lAoew6L0WLBo8=;
	h=Date:To:From:Subject:Message-Id; b=HSl0mdcVBACfQ1wE1b9q8+fsza8IycO4p4oCZF5FziM99eYpkkRUpSMFCAHPZcbR1rtCrhVN2rpgEGoiXyB+G4ao+uD96WEmkRtifkS92YUb5bnvBZndeGEq2WLPN2Unc56zasmckWS9ETsDEdU0hcF5Txs7rNnGoc7Z3LU4fz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f0bW3CAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f0bW3CAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB07C32782;
	Tue, 25 Jun 2024 05:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293225;
	bh=MqTYHYjw4MXQa15t0UVqWf6nNGw9O9lAoew6L0WLBo8=;
	h=Date:To:From:Subject:From;
	b=f0bW3CAdItEVEQcZwhjmWbUgn++13uncCkMYzND2aoKKqw79iVKlJVW5OG1yPYWVi
	 uEcqC5YdLwml09cNP14dxS/QiX6P79WC2baLIrnOMkA0I58evBZbvsU+iexev4CaqK
	 pGNAXwUT0ocmv2RA8jGztblCvVAZw8owS703yJe0=
Date: Mon, 24 Jun 2024 22:27:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,quic_jjohnson@quicinc.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-testing-radix-tree-add-missing-module_description-definition.patch removed from -mm tree
Message-Id: <20240625052705.3DB07C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/radix-tree: add missing MODULE_DESCRIPTION definition
has been removed from the -mm tree.  Its filename was
     tools-testing-radix-tree-add-missing-module_description-definition.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: tools/testing/radix-tree: add missing MODULE_DESCRIPTION definition
Date: Mon, 17 Jun 2024 12:52:21 -0700

Userspace builds of the radix-tree testing suite fails because of commit
test_maple_tree: add the missing MODULE_DESCRIPTION() macro.  Add the
proper defines to tools/testing/radix-tree/maple.c and
tools/testing/radix-tree/xarray.c so MODULE_DESCRIPTION has a definition. 
This allows the build to succeed.

Link: https://lkml.kernel.org/r/20240617195221.106565-1-sidhartha.kumar@oracle.com
Fixes: 9f8090e8c4d1 ("test_maple_tree: add the missing MODULE_DESCRIPTION() macro")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c  |    1 +
 tools/testing/radix-tree/xarray.c |    1 +
 2 files changed, 2 insertions(+)

--- a/tools/testing/radix-tree/maple.c~tools-testing-radix-tree-add-missing-module_description-definition
+++ a/tools/testing/radix-tree/maple.c
@@ -19,6 +19,7 @@
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
+#define MODULE_DESCRIPTION(X)
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)
 
--- a/tools/testing/radix-tree/xarray.c~tools-testing-radix-tree-add-missing-module_description-definition
+++ a/tools/testing/radix-tree/xarray.c
@@ -10,6 +10,7 @@
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
+#define MODULE_DESCRIPTION(X)
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-use-mas_store_gfp-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-mas_wr_append.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch

