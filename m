Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B87718DF80;
	Fri, 11 Sep 2026 01:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789089923; cv=none; b=C44h4zf1NEMOWCIqRr7wrCqd6h9DPTQe+V6JI9vWMNU5naXiBoWs2Q0F/haEKUV2EEsn+4PeO55b755LY3XHm+iGqCDS7R4xtvZZ0yHjWxEhLWKQDputMlBnKr+QAGKkJvh9ih7lY6hwfmxvgpeHIoD1UjBMK4Z5VxLvUsdukG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789089923; c=relaxed/simple;
	bh=GA2Glh+cFOWUFj+L3pNsG3KYjCJFhT84mbwAP//dcoE=;
	h=Date:To:From:Subject:Message-Id; b=tVDnGOp0BMsrJE9kCCHvbcJ6J3dIUTFITh43ASMF3gkKE/tbhOq7XjEC0qu86PBZtxpbLs68yOUK73ejmWuy1CG7lDVIsqonBYQIH12va4tLykk2zl6AYqfTIERN5I9gRvVDIBGIUZOSQ/nQjtCypm4gQQiI6XFpJegWZT/wDOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IWUffrBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IWUffrBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B854E1F000FF;
	Fri, 11 Sep 2026 01:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789089921;
	bh=UEGs2s1c389A0suiqFVv+21G230K6swXTwPuZaka9So=;
	h=Date:To:From:Subject;
	b=IWUffrBRryjk+IIy4Uru/ayKNqTqzidloBJG69BpWq8G8dCrhz5Eouiv0kkqdUiYi
	 N/dg4P+Nz6v4KHV6s01Ldi2it3J3LnvWug+QO0FuB3cq5H1AflHOnWPZYZsX89cAvV
	 lWNyjAiLM2qkftR+wdA+AOE4q8HZHkd+XJZ0KWF8=
Date: Thu, 10 Sep 2026 18:25:21 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch added to mm-new branch
Message-Id: <20260911012521.B854E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

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
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
Date: Sun, 6 Sep 2026 21:59:38 +0800

If zswap is enabled by default at boot and pool creation fails, then a
pool is later created by updating the compressor, data written to zswap is
corrupted on swapin.

Enable the static key in zswap_pool_create(), covering boot-time and
runtime pool creation with a single site.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Link: https://lore.kernel.org/20260906135938.3568108-1-xialonglong2025@163.com
Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: Nhat Pham <nphamcs@gmail.com>
Assisted-by: Zcode:GLM-5.3
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create
+++ a/mm/zswap.c
@@ -329,6 +329,8 @@ static struct zswap_pool *zswap_pool_cre
 
 	zswap_pool_debug("created", pool);
 
+	static_branch_enable(&zswap_ever_enabled);
+
 	return pool;
 
 ref_fail:
@@ -1818,7 +1820,6 @@ static int zswap_setup(void)
 		pr_info("loaded using pool %s\n", pool->tfm_name);
 		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
-		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch
mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch
mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch
mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch
mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch
mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

