Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CD329AF
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628182; cv=none; b=UQeKml/utIX8//6quvsmGX7gl1LKMl3xgO64VmHwrzYOBzONcwUB6jNTi8EGVRyyB/ss54KwNjdhc6T9jMMu15rNq+87NoE7rxZy/RxK6mzbLHcLpxW9oufOK2IRI5Lq/Z6FfTagxJM9QjTWSdAjxfqT1CBZ7PDDV82L7yQK7lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628182; c=relaxed/simple;
	bh=DekKJHmp4iSuydv68p9drM8juuN0k0Bc2LANoHZ2Szk=;
	h=Date:To:From:Subject:Message-Id; b=FLncOmqnuMcAG2INK4O4JwHBKMq/OYDQBcDCX4o4JoRuAjA/mGWOY8wju0N4qZB9c3UH0SIRRylm+PcbaTyRg9dGFpsYfzfL8bqK3AXb30DSRtemryO+5YaZdI80EzcHILUEJKL+EyKfCou1Syja0s6C1DxvWbfjsuTsaOlEhAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bo8VmgdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bo8VmgdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41350C2BD11;
	Wed,  5 Jun 2024 22:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628182;
	bh=DekKJHmp4iSuydv68p9drM8juuN0k0Bc2LANoHZ2Szk=;
	h=Date:To:From:Subject:From;
	b=bo8VmgdHD64Aczce7VyHfJTI0WSGbStSjpw0+G6HajFNYm7BT9EIw8FSfWqyP+4lH
	 cab7tUZILkVBOyeubpSJt59F4oYiAmVJnBAxLtmGkB454JJccCpTWjPminFxDXht7i
	 YQhLuY2mQX+2i8Jfj10Og3Yd7S46nj8bF2gkkcIM=
Date: Wed, 05 Jun 2024 15:56:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pasha.tatashin@soleen.com,oliver.sang@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch added to mm-hotfixes-unstable branch
Message-Id: <20240605225622.41350C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/alloc_tag: fix RCU imbalance in pgalloc_tag_get()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch

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
Subject: lib/alloc_tag: fix RCU imbalance in pgalloc_tag_get()
Date: Sat, 1 Jun 2024 16:38:40 -0700

put_page_tag_ref() should be called only when get_page_tag_ref() returns a
valid reference because only in that case get_page_tag_ref() enters RCU
read section while put_page_tag_ref() will call rcu_read_unlock() even if
the provided reference is NULL.  Fix pgalloc_tag_get() which does not
follow this rule causing RCU imbalance.  Add a warning in
put_page_tag_ref() to catch any future mistakes.

Link: https://lkml.kernel.org/r/20240601233840.617458-1-surenb@google.com
Fixes: cc92eba1c88b ("mm: fix non-compound multi-order memory accounting in __free_pages")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202405271029.6d2f9c4c-lkp@intel.com
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/pgalloc_tag.h~lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get
+++ a/include/linux/pgalloc_tag.h
@@ -37,6 +37,9 @@ static inline union codetag_ref *get_pag
 
 static inline void put_page_tag_ref(union codetag_ref *ref)
 {
+	if (WARN_ON(!ref))
+		return;
+
 	page_ext_put(page_ext_from_codetag_ref(ref));
 }
 
@@ -102,9 +105,11 @@ static inline struct alloc_tag *pgalloc_
 		union codetag_ref *ref = get_page_tag_ref(page);
 
 		alloc_tag_sub_check(ref);
-		if (ref && ref->ct)
-			tag = ct_to_alloc_tag(ref->ct);
-		put_page_tag_ref(ref);
+		if (ref) {
+			if (ref->ct)
+				tag = ct_to_alloc_tag(ref->ct);
+			put_page_tag_ref(ref);
+		}
 	}
 
 	return tag;
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-xyz_noprof-functions-calling-profiled-functions.patch
lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch

