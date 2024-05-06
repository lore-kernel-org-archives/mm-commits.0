Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A325E5CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957040; cv=none; b=UOja6EE03sEB8ClStH1gRpRgIJj3MVauFVk8Rj1QsIPvtLXOhNdBuQgyaYEFS+kfN0VbjjR/alFl9z86s+/v3PwDKCBCXF8k8NZ8+Uf+Sd2sycsUnBL/j6DtdbYheh6L3ydb2BmhIL8PZgH7MzlxY1csSYx9APQjNNVbQ7Ugfik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957040; c=relaxed/simple;
	bh=jDgbe7hJVxML6NpdTv/8hwU0LovbiebULptZ/iJ5+ic=;
	h=Date:To:From:Subject:Message-Id; b=AuYH1bcwb8eWEA5mdmBWBf17xtwrkxfoQcPzyXJ3RdDgfka/AEKX3jXftk7NL7s6v181KTZnTf+tm06yr/UleaoZggI3SnfwXrWBWoaqL/EqHXvRIvmSoElkWKHYBDe1BT7DBqlrg7OPryq1aQH+PvquKKADXyU7qnHUt+R8qA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uY4YQ1SN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uY4YQ1SN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78394C113CC;
	Mon,  6 May 2024 00:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957040;
	bh=jDgbe7hJVxML6NpdTv/8hwU0LovbiebULptZ/iJ5+ic=;
	h=Date:To:From:Subject:From;
	b=uY4YQ1SNy0VAaC/zMBIXNXJrRIfgtANqGL185nCYF9Zn3klIdXMgG0IRmsO5PhwN2
	 7+ruRaT7FJKNCCPtZeBMeQUIX1Cw1eqQZrLj7KBucB3V9Bk7GZuApzt/cLhjKFSdkE
	 7YTY30fDCJu/4DweD3vL1DRBPARG1WmHAk29rlWU=
Date: Sun, 05 May 2024 17:57:20 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch removed from -mm tree
Message-Id: <20240506005720.78394C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add docs for per-order mTHP counters and transhuge_page ABI
has been removed from the -mm tree.  Its filename was
     mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: add docs for per-order mTHP counters and transhuge_page ABI
Date: Fri, 12 Apr 2024 23:48:57 +1200

This patch includes documentation for mTHP counters and an ABI file for
sys-kernel-mm-transparent-hugepage, which appears to have been missing for
some time.

[v-songbaohua@oppo.com: fix the name and unexpected indentation]
  Link: https://lkml.kernel.org/r/20240415054538.17071-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240412114858.407208-4-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage |   18 ++++++
 Documentation/admin-guide/mm/transhuge.rst                     |   28 ++++++++++
 2 files changed, 46 insertions(+)

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
--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -447,6 +447,34 @@ thp_swpout_fallback
 	Usually because failed to allocate some continuous swap space
 	for the huge page.
 
+In /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats, There are
+also individual counters for each huge page size, which can be utilized to
+monitor the system's effectiveness in providing huge pages for usage. Each
+counter has its own corresponding file.
+
+anon_fault_alloc
+	is incremented every time a huge page is successfully
+	allocated and charged to handle a page fault.
+
+anon_fault_fallback
+	is incremented if a page fault fails to allocate or charge
+	a huge page and instead falls back to using huge pages with
+	lower orders or small pages.
+
+anon_fault_fallback_charge
+	is incremented if a page fault fails to charge a huge page and
+	instead falls back to using huge pages with lower orders or
+	small pages even though the allocation was successful.
+
+anon_swpout
+	is incremented every time a huge page is swapped out in one
+	piece without splitting.
+
+anon_swpout_fallback
+	is incremented if a huge page has to be split before swapout.
+	Usually because failed to allocate some continuous swap space
+	for the huge page.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


