Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C828A2D47E9
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783452022; cv=none; b=qAx+7bU8sfe12BRGYFMNt3lIT1L3qHBnARUEHnumaQk8FOig/Ap+rCUGAT3ilDFLjCDeO3FDQu+c3ceI3z1tP0Sk4z57jkVP7YyQFUBQn5Mo4JKD2CazfxbEKsAZoc8vf39aJoNnoEFYCAK5vSwBwE+Klvo8PnFbsVIHRDODDmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783452022; c=relaxed/simple;
	bh=SUqVjy7wWL4YTU7f1U9yzlJlk3AkH+TfMNt5k1SQ770=;
	h=Date:To:From:Subject:Message-Id; b=NWrzXBvs305QDuD5oMIACU9HJK9tIKl8UseZwxy00IlUYhVpgkPrAYPRUm7M64Nb5iP1LhLWm01RoL/edf8xGTkmV0Qf1JWmDxKHmKueCRkekkbwxZyFveTR4pKUwbYqAhQrTpBFMJ81kp64MXR6mTP1jLuo/d8dl1vCvXX8pXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xEjcqopP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xEjcqopP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939111F000E9;
	Tue,  7 Jul 2026 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783452020;
	bh=vSUV0IgNmkMKKwdBC4L3Ja/wf0GRTNqCLUKcQVXuuhI=;
	h=Date:To:From:Subject;
	b=xEjcqopP66fK/eppV8Eb50eBBMO+Qg5iljIetq/Mwoo07len8IbH7GO4G11IzRwx0
	 ACq/AHFoM7rol5wE90VWxRreBNE3AW6c+LckmGFep1fxJ0cc9+Ut9Yy5Zb+Lsz9yMS
	 7LZjBdBSuDCuiJy4kh18qTiRWJalNyD7dzCXts0I=
Date: Tue, 07 Jul 2026 12:20:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-document-page_owner-filter.patch added to mm-unstable branch
Message-Id: <20260707192020.939111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: document page_owner filter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-document-page_owner-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-document-page_owner-filter.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: document page_owner filter
Date: Tue, 7 Jul 2026 19:54:11 +0800

Add documentation for the page_owner_filter userspace tool and
kernel-level filtering features.

Link: https://lore.kernel.org/20260707115411.1714314-5-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_owner.rst |   77 +++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 2 deletions(-)

--- a/Documentation/mm/page_owner.rst~mm-page_owner-document-page_owner-filter
+++ a/Documentation/mm/page_owner.rst
@@ -65,7 +65,14 @@ un-tracking state.
 Usage
 =====
 
-1) Build user-space helper::
+1) Build user-space helpers::
+
+To filter page_owner output:
+
+	cd tools/mm
+	make page_owner_filter
+
+To sort and analyze page_owner output:
 
 	cd tools/mm
 	make page_owner_sort
@@ -74,7 +81,11 @@ Usage
 
 3) Do the job that you want to debug.
 
-4) Analyze information from page owner::
+4) (Optional) Filter page_owner output::
+
+	./page_owner_filter -m handle -n 0,1,2 > filtered_page_owner.txt
+
+5) Analyze information from page owner::
 
 	cat /sys/kernel/debug/page_owner_stacks/show_stacks > stacks.txt
 	cat stacks.txt
@@ -263,3 +274,65 @@ STANDARD FORMAT SPECIFIERS
 	f		free		whether the page has been released or not
 	st		stacktrace	stack trace of the page allocation
 	ator		allocator	memory allocator for pages
+
+Filtering page_owner output
+============================
+
+page_owner supports filtering output at the kernel level before reading,
+which reduces the amount of data that needs to be processed in userspace.
+
+The page_owner_filter tool provides a convenient interface for this filtering
+capability. It supports two types of filters:
+
+1. **print_mode filter**: Control what information is printed for each page
+	- ``stack``: Print full stack traces (default, compatible with existing usage)
+	- ``handle``: Print only stack handle numbers (much faster, smaller output)
+	- ``stack_handle``: Print both stack traces and handle numbers
+
+	The ``handle`` mode uses numeric identifiers instead of full stack traces.
+	The mapping from handles to actual stack traces can be obtained via the
+	show_stacks_handles interface.
+
+2. **NUMA node filter**: Filter pages by NUMA node ID
+	- Supports single node: ``-n 0``
+	- Multiple nodes: ``-n 0,1,2``
+	- Ranges: ``-n 0-3``
+	- Mixed format: ``-n 0,2-3,5``
+
+Usage examples::
+
+	# Filter by print mode
+	./page_owner_filter -m handle
+	./page_owner_filter -m stack_handle
+
+	# Filter by NUMA node
+	./page_owner_filter -n 0
+	./page_owner_filter -n 0-3
+
+	# Combined filters
+	./page_owner_filter -m stack -n 0,1,2
+	./page_owner_filter -m handle -n 0,2-3
+
+	# Save to file
+	./page_owner_filter -m handle -o filtered_output.txt
+
+The handle mode is particularly useful for monitoring and performance-critical
+scenarios as it dramatically reduces output size. Testing shows handle mode can
+reduce output size by ~66% (84MB vs 244MB) and improve read performance by ~4.4x
+compared to full stack output.
+
+The NUMA node filter is useful for NUMA-aware memory allocation analysis and debugging.
+
+Behind the scenes, page_owner_filter opens /sys/kernel/debug/page_owner and
+writes filter commands before reading the filtered output. The filtering uses
+per-file-descriptor state, allowing each open() to have independent filter settings.
+
+Each file descriptor maintains its own filter state, so you can have multiple
+independent filtering operations running concurrently. For example, in different
+terminals you can run different filters simultaneously::
+
+	# Terminal 1: Filter node 0
+	./page_owner_filter -n 0 > node0_output.txt
+
+	# Terminal 2: Filter node 1 (runs concurrently)
+	./page_owner_filter -n 1 > node1_output.txt
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter.patch
tools-mm-add-page_owner_filter-userspace-tool.patch
mm-page_owner-document-page_owner-filter.patch

