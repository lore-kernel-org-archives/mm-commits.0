Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92337535DC;
	Sat, 30 Nov 2024 02:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732935186; cv=none; b=cPBHX0knY4cQ61A55Qp6v4mcW+rSi2rpFQFg7kNxnhNRQLkobow1S8hLdAPWzk4HeTsQTwt0DeR5msQqZ/Z8v1ALKjW43yfZZQanatGblEHcyJS4g4Y+soePQ+cq+SNlF6/N6oNWnpnLP3nqzvit8TAIrAM9GmbhHILrvksi5eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732935186; c=relaxed/simple;
	bh=wVwFWRx1weNHXCajM53uUVQ3VpCckJ+++WQkCk7fLDA=;
	h=Date:To:From:Subject:Message-Id; b=ndR/sFP1nj7oTLMyLcT+IkkO1PxKS4AkjluX+NKSMyuqaek14UCtCtcsMXtH4Sxc+AjEJ24Q5mY/+d2gfJH+lRuUXtBxLQdtZl0OSBFBkQI9JiQIQLLitOkEkCptDng/SPTv8eMq0im5Z6z3qqJ8eXxtU1bORmMefykn4RklCjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DkpJNVxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DkpJNVxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFD0C4CECF;
	Sat, 30 Nov 2024 02:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732935186;
	bh=wVwFWRx1weNHXCajM53uUVQ3VpCckJ+++WQkCk7fLDA=;
	h=Date:To:From:Subject:From;
	b=DkpJNVxcJTOq0IihHNWmkfusAb7dd/yKIAZwfnmi/FA2U09z3cdPlO5nJ8O5RUOlK
	 N0h92nS8bqdtZhNmgaxgUzEmb8hsV/6euF6waVab+zM+Sz0Vit9f3MsK3LsTrXUaKZ
	 5JiNPzr1UbB5oXgPTgTEF0v6n6Wd6JCcKQDJLXiI=
Date: Fri, 29 Nov 2024 18:53:05 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,souravpanda@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch added to mm-hotfixes-unstable branch
Message-Id: <20241130025306.1FFD0C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix set_codetag_empty() when !CONFIG_MEM_ALLOC_PROFILING_DEBUG
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: fix set_codetag_empty() when !CONFIG_MEM_ALLOC_PROFILING_DEBUG
Date: Fri, 29 Nov 2024 16:14:23 -0800

It was recently noticed that set_codetag_empty() might be used not only to
mark NULL alloctag references as empty to avoid warnings but also to reset
valid tags (in clear_page_tag_ref()).  Since set_codetag_empty() is
defined as NOOP for CONFIG_MEM_ALLOC_PROFILING_DEBUG=n, such use of
set_codetag_empty() leads to subtle bugs.  Fix set_codetag_empty() for
CONFIG_MEM_ALLOC_PROFILING_DEBUG=n to reset the tag reference.

Link: https://lkml.kernel.org/r/20241130001423.1114965-2-surenb@google.com
Fixes: a8fc28dad6d5 ("alloc_tag: introduce clear_page_tag_ref() helper function")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/lkml/20241124074318.399027-1-00107082@163.com/
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug
+++ a/include/linux/alloc_tag.h
@@ -63,7 +63,12 @@ static inline void set_codetag_empty(uni
 #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
 static inline bool is_codetag_empty(union codetag_ref *ref) { return false; }
-static inline void set_codetag_empty(union codetag_ref *ref) {}
+
+static inline void set_codetag_empty(union codetag_ref *ref)
+{
+	if (ref)
+		ref->ct = NULL;
+}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

