Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACCA63CB
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956220; cv=none; b=cghLTXx0D8Hfi8RTBEnqbxSlwvXNoXQfG2V0FTuTWuZWmkSEuCtGwuMyzWtKe6qznXtIdsljD5W0SIU820dtdRJT/qUa1WkGJWTcyW0SOkKqgT/ZLCvdy2V0hHhVLmmUBjGkoVmaUUUvqA2Pzl5qssFrmqRhAEim5x6WL4bF7iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956220; c=relaxed/simple;
	bh=HcpK1cxZPYoNl9hTn3pThD1Re8rVf8ilfgJugeJhBg0=;
	h=Date:To:From:Subject:Message-Id; b=PDF504hIuNOW3CqkgAZAoGkLjsd2sILdDYIjMWDi+MACFMQBvpvXebwDB+WP+OVJBKAGER9FvLPkwV58TdhWbZHeYL9HDcXWCbGnIpEak+nWcC6TjnI5SG86NxXv6cvGdkQCuNSXfTHQzgCeIB7hsgXHofHj71mJJOxd/67uu7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/GI1gnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/GI1gnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6BEC113CC;
	Mon,  6 May 2024 00:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956219;
	bh=HcpK1cxZPYoNl9hTn3pThD1Re8rVf8ilfgJugeJhBg0=;
	h=Date:To:From:Subject:From;
	b=A/GI1gnLlixtsthVBjlWZFgo0SV4yKb2HvS4dwgagy78AML0xQZIGruhay6uhA0Tc
	 ln9H/6mQnD5A1KGcdkZRWLp2d5aw7QnB3WdS+/1NEjFG+Yvxckb2En3lYDO87diU93
	 rPP1VsJGTKnAMNQL5+R2YsToU77Z3kNIsnvtvSIM=
Date: Sun, 05 May 2024 17:43:39 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi-fix.patch removed from -mm tree
Message-Id: <20240506004339.AE6BEC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sysfs-kernel-mm-transparent-hugepage: fix the name and unexpected indentation
has been removed from the -mm tree.  Its filename was
     mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi-fix.patch

This patch was dropped because it was folded into mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: sysfs-kernel-mm-transparent-hugepage: fix the name and unexpected indentation
Date: Mon, 15 Apr 2024 17:37:04 +1200

Link: https://lkml.kernel.org/r/20240415054538.17071-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sys-kernel-mm-transparent-hugepage   |   17 ---------
 Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage |   18 ++++++++++
 2 files changed, 18 insertions(+), 17 deletions(-)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
@@ -0,0 +1,18 @@
+What:		/sys/kernel/mm/transparent_hugepage/
+Date:		April 2024
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		/sys/kernel/mm/transparent_hugepage/ contains a number of files and
+		subdirectories,
+
+			- defrag
+			- enabled
+			- hpage_pmd_size
+			- khugepaged
+			- shmem_enabled
+			- use_zero_page
+			- subdirectories of the form hugepages-<size>kB, where <size>
+			  is the page size of the hugepages supported by the kernel/CPU
+			  combination.
+
+		See Documentation/admin-guide/mm/transhuge.rst for details.
--- a/Documentation/ABI/testing/sys-kernel-mm-transparent-hugepage
+++ /dev/null
@@ -1,17 +0,0 @@
-What:		/sys/kernel/mm/transparent_hugepage/
-Date:		April 2024
-Contact:	Linux memory management mailing list <linux-mm@kvack.org>
-Description:
-		/sys/kernel/mm/transparent_hugepage/ contains a number of files and
-		subdirectories,
-			- defrag
-			- enabled
-			- hpage_pmd_size
-			- khugepaged
-			- shmem_enabled
-			- use_zero_page
-			- subdirectories of the form hugepages-<size>kB, where <size>
-			  is the page size of the hugepages supported by the kernel/CPU
-			  combination.
-
-		See Documentation/admin-guide/mm/transhuge.rst for details.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch
mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

