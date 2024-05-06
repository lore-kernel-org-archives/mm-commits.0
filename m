Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138DC19BA6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957043; cv=none; b=KPZt9IyEPFHA3UAAg1U8PYUU1pCRZRFSjMo73n8yc0DBu9Ql9Nf+UZ4sQINS2CkDvtp5U9PmW29FHkiKiwES536AhOHGCZC/+nxwgsbknFQHANEF3mAWJ8n0fDJ4OvFU6CFNFb8+30gRlPhbCJtb56quXUejtyNKZWdFlcs0THs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957043; c=relaxed/simple;
	bh=UsKdWBBTm1h/tlDCHUscUxxXnumWyJUXUIuSRfkSziA=;
	h=Date:To:From:Subject:Message-Id; b=irLmryVykvQOzni7DI8Ccj7RAOMg7l8UGQ/PWJdGVL7Ux8YoberFVo1X8pvOAHLPGjR1UBjLrC3D+DIqDyXPsEFMny50nm+R3ERGll0AhzaYgW4mCvudVhA72bC4GnRCYp42+1vKqxbeigTfnPxMcU4KRjHAB3usc4MRnpt/+VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EUJ5cpPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EUJ5cpPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD173C113CC;
	Mon,  6 May 2024 00:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957042;
	bh=UsKdWBBTm1h/tlDCHUscUxxXnumWyJUXUIuSRfkSziA=;
	h=Date:To:From:Subject:From;
	b=EUJ5cpPdWzgQldsA6HjuFSbx/P2pzwf97TFfpFD58KAYIvyzhYZqrrB6FRg4UW4Xr
	 U5XmNvZodgFwAgczXvKui352Aflofg/BQylNfHeeKrc75ukq9UxXsDd3EGkEh4NFBC
	 uBZ1wetqQlEZSZTFj1lolAmxIdm7yJKsAm4SYFeo=
Date: Sun, 05 May 2024 17:57:22 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch removed from -mm tree
Message-Id: <20240506005722.DD173C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: correct the docs for thp_fault_alloc and thp_fault_fallback
has been removed from the -mm tree.  Its filename was
     mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: correct the docs for thp_fault_alloc and thp_fault_fallback
Date: Fri, 12 Apr 2024 23:48:58 +1200

The documentation does not align with the code.  In
__do_huge_pmd_anonymous_page(), THP_FAULT_FALLBACK is incremented when
mem_cgroup_charge() fails, despite the allocation succeeding, whereas
THP_FAULT_ALLOC is only incremented after a successful charge.

Link: https://lkml.kernel.org/r/20240412114858.407208-5-21cnbao@gmail.com
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

 Documentation/admin-guide/mm/transhuge.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -369,7 +369,7 @@ monitor how successfully the system is p
 
 thp_fault_alloc
 	is incremented every time a huge page is successfully
-	allocated to handle a page fault.
+	allocated and charged to handle a page fault.
 
 thp_collapse_alloc
 	is incremented by khugepaged when it has found
@@ -377,7 +377,7 @@ thp_collapse_alloc
 	successfully allocated a new huge page to store the data.
 
 thp_fault_fallback
-	is incremented if a page fault fails to allocate
+	is incremented if a page fault fails to allocate or charge
 	a huge page and instead falls back to using small pages.
 
 thp_fault_fallback_charge
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


