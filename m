Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3998B468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ssn6mkvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068B7C433C7;
	Mon, 11 Dec 2023 00:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256122;
	bh=iGIc3REIMDzXE5QzpTb0fRsMGf7OOWmwK02dnrloseE=;
	h=Date:To:From:Subject:From;
	b=Ssn6mkvK0lmrhQAU6bdX3iCH2qzD1L35tZtHDV9N5JD25m6H70Z2mSQcBkkRY5p3s
	 JlR3qkz7clN/faXcUKsg7mszTNUpWcmNt4jG3Uq30sTPI+WrgHTk4i4uLFwqfRrUbI
	 VX+kAIrbsRgbgJT37h27niMPWnwFHveyF92zLL8E=
Date: Sun, 10 Dec 2023 16:55:21 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,rdunlap@infradead.org,mike.kravetz@oracle.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-kconfig-make-hugetlbfs-a-menuconfig.patch removed from -mm tree
Message-Id: <20231211005522.068B7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/Kconfig: make hugetlbfs a menuconfig
has been removed from the -mm tree.  Its filename was
     fs-kconfig-make-hugetlbfs-a-menuconfig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fs/Kconfig: make hugetlbfs a menuconfig
Date: Fri, 24 Nov 2023 10:19:02 -0500

Hugetlb vmemmap default option (HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON)
is a sub-option to hugetlbfs, but it shows in the same level as hugetlbfs
itself, under "Pesudo filesystems".

Make the vmemmap option a sub-option to hugetlbfs, by changing hugetlbfs
into a menuconfig.  When moving it, fix a typo 'v' spot by Randy.

Link: https://lkml.kernel.org/r/20231124151902.1075697-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/Kconfig~fs-kconfig-make-hugetlbfs-a-menuconfig
+++ a/fs/Kconfig
@@ -254,7 +254,7 @@ config TMPFS_QUOTA
 config ARCH_SUPPORTS_HUGETLBFS
 	def_bool n
 
-config HUGETLBFS
+menuconfig HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	depends on (SYSFS || SYSCTL)
@@ -266,6 +266,17 @@ config HUGETLBFS
 
 	  If unsure, say N.
 
+if HUGETLBFS
+config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
+	bool "HugeTLB Vmemmap Optimization (HVO) defaults to on"
+	default n
+	depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	help
+	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y here to
+	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
+	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
+endif # HUGETLBFS
+
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 	select XARRAY_MULTI
@@ -275,15 +286,6 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
 
-config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
-	bool "HugeTLB Vmemmap Optimization (HVO) defaults to on"
-	default n
-	depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	help
-	  The HugeTLB VmemmapvOptimization (HVO) defaults to off. Say Y here to
-	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
-	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
-
 config ARCH_HAS_GIGANTIC_PAGE
 	bool
 
_

Patches currently in -mm which might be from peterx@redhat.com are


