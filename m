Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126C12857F0
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966057; cv=none; b=YJbBqFCno7W8fCrkwc1F2k72VnZJCo0xYa4K7rg58A1TgTdV8gZARXxZJjMvp89qQucrU49IWHYOKRG7oCv+iPbLCsHSscLh8yasUCG/JtzV9Bc81NuHXFRqcyyT/e1xBbQP0+fD9v8njlGBquSTTyPStZjrn3mCZm9hHTaZuTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966057; c=relaxed/simple;
	bh=osACmxrsCFDSFl4OwsiQ6ORdooaaUI5NPLyDMszG2tg=;
	h=Date:To:From:Subject:Message-Id; b=eWZuu5u2FEimebyyoIRv1Ya46QqMXCMSlv9DKiQC3RzpdprnhAx6oPnnlVH/FRQDOdqbqbxX+V5OzsacW51OzsrrEqDY3OnGw3I3KPlivtb+TZvgtrDt7yNgybYDr98lSIk3uJvpvgM8RAzxgXHjYGFccn8rYFSRnUg6DH6BbyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2UGxl05W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2UGxl05W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D01C16AAE;
	Wed, 21 Jan 2026 03:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966056;
	bh=osACmxrsCFDSFl4OwsiQ6ORdooaaUI5NPLyDMszG2tg=;
	h=Date:To:From:Subject:From;
	b=2UGxl05WnRxGh2XP1U+RfiUNFc2teI5FpKK79zl/W0ikUQZjVZ7DK+xpyvs61R5of
	 2BsRkwLuHpqOypABbhrCqZ7AURcpkqYQFbsZ1mHH1t/T+I+Utj2JQdm/REse67mCBF
	 AmGbH5HkHqkxmSA2YnrcC60NdPeuGdsizCbgIBdU=
Date: Tue, 20 Jan 2026 19:27:36 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,chengming.zhou@linux.dev,anshuman.khandual@arm.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-delete-unused-acomp-is_sleepable.patch removed from -mm tree
Message-Id: <20260121032736.99D01C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: delete unused acomp->is_sleepable
has been removed from the -mm tree.  Its filename was
     mm-zswap-delete-unused-acomp-is_sleepable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: delete unused acomp->is_sleepable
Date: Wed, 10 Dec 2025 21:56:45 -0500

This hasn't been used since 7d4c9629b74f ("mm: zswap: use object
read/write APIs instead of object mapping APIs").  Drop it.

Link: https://lkml.kernel.org/r/20251211025645.820517-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-delete-unused-acomp-is_sleepable
+++ a/mm/zswap.c
@@ -141,7 +141,6 @@ struct crypto_acomp_ctx {
 	struct crypto_wait wait;
 	u8 *buffer;
 	struct mutex mutex;
-	bool is_sleepable;
 };
 
 /*
@@ -781,7 +780,6 @@ static int zswap_cpu_comp_prepare(unsign
 
 	acomp_ctx->buffer = buffer;
 	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 	acomp_ctx->req = req;
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


