Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532E02459ED
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386861; cv=none; b=rZXJxWz4nm6maM4H/Smaj5PqfebEofCnNyaD1Et2rEIRuMgZuhJitF1AHhtNorouG8hCY/3In6azJekBzZXy4ONPcePfE7eVQMEYpUFcoNAgM/SZJnB+n+lbo64Zjxurb3tGvNAvko8ubu3GeZcvL9rmubKrg8x1qa/Oc47GmTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386861; c=relaxed/simple;
	bh=ZO0xjGOz0Q3x80TlzX/SjE2XosiZFWsEeqMyDNubQKs=;
	h=Date:To:From:Subject:Message-Id; b=Bwt21ZMcJUFaQz8Fe751dsGfV3DQq4JrGd59LgWhVLZUvOvH7vdvxg8dMHsb1INTAz3pXp1rEWkrrJo23yrmQBsz9aG5N94+/wdpP6irj5lcQisNTKZqhsuG57rRnRypiqS1qedtXJ668EplU5Rtba76Yl2LyawuZFYPBf3dpZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uRVvx1r8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uRVvx1r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8CEC19424;
	Tue, 24 Mar 2026 21:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386861;
	bh=ZO0xjGOz0Q3x80TlzX/SjE2XosiZFWsEeqMyDNubQKs=;
	h=Date:To:From:Subject:From;
	b=uRVvx1r8w7t9H33e9+pntW9HaUU7NglPRPJFj5vW3B6yivHMOEVdsTf3m+VpqZLZ1
	 y5TRGlwtJSuBJzEhHkXqp9CNV1egNn49CdutidJMZnd87LjyyjNdTJMBmtkgIi9Lqc
	 Ov1qKlUBVCoRUUls8YewqOrXJM3pKinqM6L40iAk=
Date: Tue, 24 Mar 2026 14:14:20 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,rientjes@google.com,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,jasonmiu@google.com,graf@amazon.com,dmatlack@google.com,changyuanl@google.com,bhe@redhat.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-adopt-radix-tree-for-preserved-memory-tracking-fix.patch removed from -mm tree
Message-Id: <20260324211420.EB8CEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix child node parsing for debugfs in/sub_fdts
has been removed from the -mm tree.  Its filename was
     kho-adopt-radix-tree-for-preserved-memory-tracking-fix.patch

This patch was dropped because it was folded into kho-adopt-radix-tree-for-preserved-memory-tracking.patch

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho: fix child node parsing for debugfs in/sub_fdts
Date: Mon, 9 Mar 2026 03:35:30 +0000

Commit e0c1731f5d57 ("kho: adopt radix tree for preserved memory
tracking") changed KHO_FDT_SUB_TREE_PROP_NAME from "fdt" to
"preserved-data".  However, kho debugfs code still hard-coded the "fdt"
string when parsing the device tree, causing the debugfs node
/debugfs/kho/in/sub_fdts/ fail to parse child nodes correctly.

Fix this by including the header file and using KHO_FDT_SUB_TREE_PROP_NAME
instead of the hard-coded string.

Link: https://lkml.kernel.org/r/20260309033530.244508-1-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Miu <jasonmiu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover_debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover_debugfs.c~kho-adopt-radix-tree-for-preserved-memory-tracking-fix
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/libfdt.h>
 #include <linux/mm.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include "kexec_handover_internal.h"
 
 static struct dentry *debugfs_root;
@@ -139,7 +140,7 @@ __init void kho_in_debugfs_init(struct k
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *fdt_phys;
 
-		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
+		fdt_phys = fdt_getprop(fdt, child, KHO_FDT_SUB_TREE_PROP_NAME, &len);
 		if (!fdt_phys)
 			continue;
 		if (len != sizeof(*fdt_phys)) {
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-adopt-radix-tree-for-preserved-memory-tracking.patch

