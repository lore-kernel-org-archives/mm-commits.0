Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC287369D7D
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 22:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780006605; cv=none; b=iTt35BMqPBcgz071nwrIbf11Y+ctXzjnPJhM7k0SFXeh/HhFshfrJP7uyEMR6rrnpqKBZjL61xqSkO0fsEO64y+l6srJ4bvk8e3CFiENC7Ru4aZVyo52UmGwM2GdNSg80QnsS33BF70sTcbHZfuIcDrXUNtmz0gcz+EzyLZ3sug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780006605; c=relaxed/simple;
	bh=EXy3rjocSO6GdOCqiajw5HyEB7wkJLkGA/RdlJL6Db0=;
	h=Date:To:From:Subject:Message-Id; b=ZiGNKtLjbDJgnblXpSVh5qXdRHph3PUkATJWTgvoAoDG1vpAYbT+aNGZZdZUPgq7XHMc401vOGqT2cpt946+pXybjeRvkZQSeVs75qOiC5XBsBuWtmRYrQXcGA+2vObIS9snEblJaESs2uMtPZWuI8oOTXP4SqYgjOiaRvMg8X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vnwvJbHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vnwvJbHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9201F000E9;
	Thu, 28 May 2026 22:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780006603;
	bh=pw8sWCGGnbC0Pa+IHghmxfKvQYgGbUPU5JufVXR6HeM=;
	h=Date:To:From:Subject;
	b=vnwvJbHKbQ278WCzyzDTKHpLk89mMwi5Q5wlrp6OB4aPnyd0hurEvae4gWUJ/jf0S
	 AhkzS1v9C/XtVJqYy91kz9Q3mXc6Y5RUE665hkR+DOJroJ8pP4q1WxMh+KmfxrPLU3
	 97Z3m2LG2fWsEEsVEwY0aDUPHeEMpBMYIs2W1dIw=
Date: Thu, 28 May 2026 15:16:42 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-switch-deferred-split-shrinker-to-list_lru-fix.patch added to mm-new branch
Message-Id: <20260528221643.4A9201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-switch-deferred-split-shrinker-to-list_lru-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-switch-deferred-split-shrinker-to-list_lru-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-switch-deferred-split-shrinker-to-list_lru-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-switch-deferred-split-shrinker-to-list_lru-fix
Date: Thu May 28 03:12:45 PM PDT 2026

fix build with CONFIG_TRANSPARENT_HUGEPAGE=n

| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/
Link: https://lore.kernel.org/202605281620.lc3rtkBm-lkp@intel.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-switch-deferred-split-shrinker-to-list_lru-fix
+++ a/include/linux/huge_mm.h
@@ -663,7 +663,15 @@ static inline int folio_split(struct fol
 	return -EINVAL;
 }
 
-static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline int folio_memcg_alloc_deferred(struct folio *folio)
+{
+	return 0;
+}
+
+static inline void deferred_split_folio(struct folio *folio, bool partially_mapped)
+{
+}
+
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
memcgv1-dont-compile-swap-functions-when-config_swap=n.patch
mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

