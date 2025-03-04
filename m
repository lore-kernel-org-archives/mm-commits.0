Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8479F5
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062880; cv=none; b=tUzTBrK0+YahGAqUnQclErkDiCCNg/8eIyoBHNt21MJ8v+s0Q5MdEZc8MZIPUsjZFIPGoUClJJwwlIH4eJq1YfDzZREpdjJVVP7Q8UvhDRbXr/KoUhS8hWqTh5b8HfNYly0GSAMOUxSHddNwNSKWbLLCHXpwNZe2taaelQpZbHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062880; c=relaxed/simple;
	bh=H7ugmBXuZiDN+XsTlob6OPhj3g6ASZuzr5bfQeXhOwA=;
	h=Date:To:From:Subject:Message-Id; b=SKowNzVRiHNKM8WPj7A7nr2efCv0dqI/uAe/Zl75z19sNRhrjdPfgNeY+58bvYUZAwMTv1tw5sTP0OUPNjmWxL67ngQEbrWYWLGTq/hEOaFOBlmj2R7InOIQDu672PArPixlZ1G/ZKQWGr3ghX6ZePIWWPwqjmjtKO220Ks7aRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qI6cw9+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qI6cw9+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0A4C4CEE7;
	Tue,  4 Mar 2025 04:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741062880;
	bh=H7ugmBXuZiDN+XsTlob6OPhj3g6ASZuzr5bfQeXhOwA=;
	h=Date:To:From:Subject:From;
	b=qI6cw9+F8HLFZ6/JhNrmrGrocLSr7TnJj0bMVHdUr7mOs/JXge5ZKHysEXRg38Lwp
	 YWYxV7fRRh8bWXyRc2i14B9Dndf9KVIabJuNjFu7o+qKBb3FQlsoE0wMhIQF3o3rHV
	 NHATmDvk75n0vm5SsguhLiSCl2/EwbEKyVzyJNzQ=
Date: Mon, 03 Mar 2025 20:34:39 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + page_counter-reduce-struct-page_counter-size.patch added to mm-unstable branch
Message-Id: <20250304043439.EC0A4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: page_counter: reduce struct page_counter size
has been added to the -mm mm-unstable branch.  Its filename is
     page_counter-reduce-struct-page_counter-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page_counter-reduce-struct-page_counter-size.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: page_counter: reduce struct page_counter size
Date: Thu, 27 Feb 2025 23:58:08 -0800

The struct page_counter has explicit padding for better cache alignment. 
The commit c6f53ed8f213a ("mm, memcg: cg2 memory{.swap,}.peak write
handlers") added a field to the struct page_counter and accidently
increased its size.  Let's move the failcnt field which is v1-only field
to the same cacheline of usage to reduce the size of struct page_counter.

Link: https://lkml.kernel.org/r/20250228075808.207484-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/page_counter.h~page_counter-reduce-struct-page_counter-size
+++ a/include/linux/page_counter.h
@@ -9,10 +9,12 @@
 
 struct page_counter {
 	/*
-	 * Make sure 'usage' does not share cacheline with any other field. The
-	 * memcg->memory.usage is a hot member of struct mem_cgroup.
+	 * Make sure 'usage' does not share cacheline with any other field in
+	 * v2. The memcg->memory.usage is a hot member of struct mem_cgroup.
 	 */
 	atomic_long_t usage;
+	unsigned long failcnt; /* v1-only field */
+
 	CACHELINE_PADDING(_pad1_);
 
 	/* effective memory.min and memory.min usage tracking */
@@ -28,7 +30,6 @@ struct page_counter {
 	unsigned long watermark;
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
-	unsigned long failcnt; /* v1-only field */
 
 	/* Keep all the read most fields in a separete cacheline. */
 	CACHELINE_PADDING(_pad2_);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-dont-call-propagate_protected_usage-for-v1.patch
page_counter-track-failcnt-only-for-legacy-cgroups.patch
page_counter-reduce-struct-page_counter-size.patch

