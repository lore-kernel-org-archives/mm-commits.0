Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804BA4F88C;
	Thu,  8 Feb 2024 21:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707428517; cv=none; b=hPRPvRgEOSNpfPVWeLEz+mmSzJohyiSONv8oHzVidkPK4dwI/kY421vwYlSQudBO/PlHoHwQU41TBf8RcX+05x273aOCPPfUbpM4l1uBUghzFEA1XPWAt5wCIOUn8giiA6Fd66TAnOX4QNVTUwmd2/PPRASy+KHDuZr3UKgVX+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707428517; c=relaxed/simple;
	bh=vmIMnXnxK2Cf+Z/k1r7jjiEAHJh6+kdkm7WV9KxjhzU=;
	h=Date:To:From:Subject:Message-Id; b=Auu+0dRV2LPND7g1CvVR6kA4mU1vbLJd48iT9v3LolZI89ni1MXuKBSxzJ2m+yQUAOLNdo688veyyOExYLarHpMy/cCUBp1qtLRJZ8wxI5eaivd0CeCngUUrCUWnpBst/buD5z8lpOILdPh+gKu7mBOFkqBzIHYs9gKEfLw6Fq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W8PpeEv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W8PpeEv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8F4C433C7;
	Thu,  8 Feb 2024 21:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707428517;
	bh=vmIMnXnxK2Cf+Z/k1r7jjiEAHJh6+kdkm7WV9KxjhzU=;
	h=Date:To:From:Subject:From;
	b=W8PpeEv1Sg36qt9PK/uEd8cM8XGzUHm/lJNuGWrup3GYXGoexh/J2hEa916y14dkl
	 Uyi+kjJO34ViV4kBHQoeNANlz7lbdv4vOc7vepyENdv+b3eqr7wQvIgLXree1ssMNF
	 W51TiVkCRq6Zo3qdc7oJ6eK7mu6+RVzIWlEIM93g=
Date: Thu, 08 Feb 2024 13:41:56 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20240208214156.DB8F4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: invalidate duplicate entry when !zswap_enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: invalidate duplicate entry when !zswap_enabled
Date: Thu, 8 Feb 2024 02:32:54 +0000

We have to invalidate any duplicate entry even when !zswap_enabled since
zswap can be disabled anytime.  If the folio store success before, then
got dirtied again but zswap disabled, we won't invalidate the old
duplicate entry in the zswap_store().  So later lru writeback may
overwrite the new data in swapfile.

Link: https://lkml.kernel.org/r/20240208023254.3873823-1-chengming.zhou@linux.dev
Fixes: 42c06a0e8ebe ("mm: kill frontswap")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-invalidate-duplicate-entry-when-zswap_enabled
+++ a/mm/zswap.c
@@ -1516,7 +1516,7 @@ bool zswap_store(struct folio *folio)
 	if (folio_test_large(folio))
 		return false;
 
-	if (!zswap_enabled || !tree)
+	if (!tree)
 		return false;
 
 	/*
@@ -1531,6 +1531,10 @@ bool zswap_store(struct folio *folio)
 		zswap_invalidate_entry(tree, dupentry);
 	}
 	spin_unlock(&tree->lock);
+
+	if (!zswap_enabled)
+		return false;
+
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch
mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch

