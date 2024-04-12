Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76B9152504
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712963299; cv=none; b=eL4DXZoUcqGp1h2TCHpXeZV7s0Z3OcYzg7uRHarGMy4smWlsRYL+UO2i6EPpWDqvxU4+4l9TwWMYIh4gmdzYjK3Z+2A/Jrho+UZrItTARIC/AydI8X1zrcsqAf/+y8HPYADQ9Zlfw1SUR8KpseKRpQDtgMFO57+jqTFGlGMlZ30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712963299; c=relaxed/simple;
	bh=8HlBqcF/fpVxVJRw8dzWnVuZ5cs6Wci36GdA68d5EGU=;
	h=Date:To:From:Subject:Message-Id; b=sVuJw/Y9e/pIDjBXgBjQCBZRRqBR3lOL0WXNH3zcq22ZGXNY9hdfd3m91jCuEEROzTl0BmSKFUelWjyycNtqScDk9ES7gLQOwGl85HM51c8AdcjDv09/gze9J6tUsPWM3LzcyCU90kh/4h/zx6sYashDnOlW8URXh0vuXt9Re5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u2gJ9Twc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u2gJ9Twc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3F2C113CC;
	Fri, 12 Apr 2024 23:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712963298;
	bh=8HlBqcF/fpVxVJRw8dzWnVuZ5cs6Wci36GdA68d5EGU=;
	h=Date:To:From:Subject:From;
	b=u2gJ9TwcBff7rNloPOuAH8h6LLtzfdMNdReVl10bEi648FAFRr6Qz332SFIbojRvb
	 v3lIaYiatWTidOHg1caoeTguFEXivXBdGOfDCkFjtlRLnei0WqZBXdOyKWn3XBf1HU
	 DHuG+2SfUGB++dAUXdzNK71YJQ0U4dWLjDX/S3kE=
Date: Fri, 12 Apr 2024 16:08:17 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch added to mm-unstable branch
Message-Id: <20240412230818.6C3F2C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add docs for per-order mTHP counters and transhuge_page ABI
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: add docs for per-order mTHP counters and transhuge_page ABI
Date: Fri, 12 Apr 2024 23:48:57 +1200

This patch includes documentation for mTHP counters and an ABI file for
sys-kernel-mm-transparent-hugepage, which appears to have been missing for
some time.

Link: https://lkml.kernel.org/r/20240412114858.407208-4-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
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

 Documentation/ABI/testing/sys-kernel-mm-transparent-hugepage |   17 ++++++
 Documentation/admin-guide/mm/transhuge.rst                   |   28 ++++++++++
 2 files changed, 45 insertions(+)

--- /dev/null
+++ a/Documentation/ABI/testing/sys-kernel-mm-transparent-hugepage
@@ -0,0 +1,17 @@
+What:		/sys/kernel/mm/transparent_hugepage/
+Date:		April 2024
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		/sys/kernel/mm/transparent_hugepage/ contains a number of files and
+		subdirectories,
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

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch
mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

