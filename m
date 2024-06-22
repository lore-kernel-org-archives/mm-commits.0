Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8799B1C32
	for <mm-commits@vger.kernel.org>; Sat, 22 Jun 2024 01:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719019652; cv=none; b=qa/H6bouXTwkXEXJTRf+gJeCpp2UKTQs1L5Mo4ydmfvP3djqXVMQBaTQmI8HDYkK8+CQqSkTmIvnl8iIzE5JGMdfYE2CQ0eHcRLHVQDaQdRL8Ycr611f9lPQB16AbAX1mGawfyq21nO9KCIn5F2JoouaimNQ8L8IcDWXG+f6HJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719019652; c=relaxed/simple;
	bh=IarG7ripXGOGck+v9NGyWTyUI7COm81PdnE/UTVsj+8=;
	h=Date:To:From:Subject:Message-Id; b=j9dhNCZRzT0C+Xudn460rGPEKi+MrOCU64QESaTD6XiVBD/Nxs64BIje3aZnukKcqujDH3suA/For0puHfB7bdtumrNzPbqdeZSf86K5IvU1nTOJDkpSGBW/GCUGSPSr2Wn9v69obrGhNZv7kgAlfXOxHlK3tuoT2Ef2U8ONYSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p/+0cr3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p/+0cr3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0201C2BBFC;
	Sat, 22 Jun 2024 01:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719019652;
	bh=IarG7ripXGOGck+v9NGyWTyUI7COm81PdnE/UTVsj+8=;
	h=Date:To:From:Subject:From;
	b=p/+0cr3pVwK0oeUAKmS3oZ/Mm0eabAD8xNmDj8Z9JQt9MTYCkyGFqjwofNHyY4WkB
	 P1mtBEE8gMCfDq2W2SUl2ur98hTxCBrog4y/SpJOLy+llShKh032diyPCYRo//lY2t
	 hQd3tC7iAHyDdObKgRimpNVNGvTVv9e5ECuNCgjM=
Date: Fri, 21 Jun 2024 18:27:31 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-only-one-pool-in-zswap-v2.patch added to mm-unstable branch
Message-Id: <20240622012731.E0201C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: use only one pool in zswap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-use-only-one-pool-in-zswap-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-only-one-pool-in-zswap-v2.patch

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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zswap: use only one pool in zswap
Date: Fri, 21 Jun 2024 15:15:10 +0800

fix error handling in zswap_pool_create(), per Dan Carpenter

Link: https://lkml.kernel.org/r/20240621-zsmalloc-lock-mm-everything-v2-2-d30e9cd2b793@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-use-only-one-pool-in-zswap-v2
+++ a/mm/zswap.c
@@ -268,7 +268,7 @@ static struct zswap_pool *zswap_pool_cre
 	pool->zpool = zpool_create_pool(type, name, gfp);
 	if (!pool->zpool) {
 		pr_err("%s zpool not available\n", type);
-		goto error;
+		return NULL;
 	}
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-use-only-one-pool-in-zswap.patch
mm-zswap-use-only-one-pool-in-zswap-v2.patch
mm-ksm-refactor-out-try_to_merge_with_zero_page.patch
mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch
mm-ksm-optimize-the-chain-chain_prune-interfaces.patch

