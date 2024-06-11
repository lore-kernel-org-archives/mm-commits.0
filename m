Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C828120314
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 22:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143734; cv=none; b=SKmLs2794szfw6wU/agp521RJYj6e6aNB8OEQB2w642BeT+6yBKYqTrITVFEXzUKI+BcawJxDHZ9sHI175yPofAVQZ9XWex/AtTHVuRuZlhX+RxkvLUTq7mLBe1nJThmWYpMHFg8ls/LDnL04NAZCrimhbiKZB/b5yTUJnMzU+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143734; c=relaxed/simple;
	bh=Fc5sU3IG85AlMA3gOaCbDg861+9df5MZ1L0dSIdvbCA=;
	h=Date:To:From:Subject:Message-Id; b=mSJ8TG/1narkAEYMuEXh2dFIJvrGtMdG7JdV2UYOPtjasOwDBff0d73qqCdf7tWtBc1jzD2zjpe/uyfzZFs5DLI6CWqNhHi9oUJ0Zsk/WhcVvh3EFTyWy3dr/rdd6Lx1y+1FGgApdQNcgOtHlhBo2UkjNQ8qnfNxofN/nkVMAe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oIkbRDIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oIkbRDIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A5CC2BD10;
	Tue, 11 Jun 2024 22:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718143734;
	bh=Fc5sU3IG85AlMA3gOaCbDg861+9df5MZ1L0dSIdvbCA=;
	h=Date:To:From:Subject:From;
	b=oIkbRDIPu5uiITwE7Sg0djKLoKifIm8Ghc3S5o85DUCA1RsuO6oLLT14/mXfAXipp
	 jJKUcpmYazx7hPbSgC7tEm90TSRpmfk3bJyeoVVwBQ4Ixk+1W5N3BpEuqDUKdD6z+l
	 JEnwbukMVlYwMYYZxGqbkBMzRFld1VT1sgs2ha6M=
Date: Tue, 11 Jun 2024 15:08:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-add-zswap_never_enabled.patch added to mm-unstable branch
Message-Id: <20240611220854.43A5CC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: add zswap_never_enabled()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-add-zswap_never_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-add-zswap_never_enabled.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: add zswap_never_enabled()
Date: Tue, 11 Jun 2024 02:45:15 +0000

Add zswap_never_enabled() to skip the xarray lookup in zswap_load() if
zswap was never enabled on the system.  It is implemented using static
branches for efficiency, as enabling zswap should be a rare event.  This
could shave some cycles off zswap_load() when CONFIG_ZSWAP is used but
zswap is never enabled.

However, the real motivation behind this patch is two-fold:
- Incoming large folio swapin work will need to fallback to order-0
  folios if zswap was ever enabled, because any part of the folio could be
  in zswap, until proper handling of large folios with zswap is added.

- A warning and recovery attempt will be added in a following change in
  case the above was not done incorrectly.  Zswap will fail the read if
  the folio is large and it was ever enabled.

Link: https://lkml.kernel.org/r/20240611024516.1375191-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/zswap.c~mm-zswap-add-zswap_never_enabled
+++ a/mm/zswap.c
@@ -83,6 +83,7 @@ static bool zswap_pool_reached_full;
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
+static DEFINE_STATIC_KEY_MAYBE(CONFIG_ZSWAP_DEFAULT_ON, zswap_ever_enabled);
 static bool zswap_enabled = IS_ENABLED(CONFIG_ZSWAP_DEFAULT_ON);
 static int zswap_enabled_param_set(const char *,
 				   const struct kernel_param *);
@@ -136,6 +137,11 @@ bool zswap_is_enabled(void)
 	return zswap_enabled;
 }
 
+static bool zswap_never_enabled(void)
+{
+	return !static_branch_maybe(CONFIG_ZSWAP_DEFAULT_ON, &zswap_ever_enabled);
+}
+
 /*********************************
 * data structures
 **********************************/
@@ -1557,6 +1563,9 @@ bool zswap_load(struct folio *folio)
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
+	if (zswap_never_enabled())
+		return false;
+
 	/*
 	 * When reading into the swapcache, invalidate our entry. The
 	 * swapcache can be the authoritative owner of the page and
@@ -1735,6 +1744,7 @@ static int zswap_setup(void)
 			zpool_get_type(pool->zpools[0]));
 		list_add(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
+		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch
mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch
mm-swap-remove-synchronous-argument-to-swap_read_folio.patch
mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch
mm-zswap-add-zswap_never_enabled.patch
mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch

