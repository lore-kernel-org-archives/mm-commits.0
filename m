Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9433595D;
	Tue, 13 Jan 2026 05:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280983; cv=none; b=d9JALrMyzmo15mJnU7IW1TxnHYQ6s8/QKr7yrlbGt3pyTvB4bxcH+TJ7nAXMhask8o8oC1oilAzCYSCSXuShnyCx6/ltcmxVAsh4sBP4Nym4fpuhZTu987CdGICPMsveg9RUf/juFk4HMQf+TmQNI1A1BMGtZCc1Y5YEzT8IreE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280983; c=relaxed/simple;
	bh=UfvFSyQvMsF+1+H5v1iLg0/p3AR2bqf7nHryvjSdx+o=;
	h=Date:To:From:Subject:Message-Id; b=ZK/XOrf8c/crzL7lTcBb1HfF+xboUyyx7OwYTZSDAP1Tj5tiiG1whNNhNoSs1o8o6r9+puZLP3/pNdre8usEfPXJD//YSbm9UZUt5vjPsN7v3HJBykfCZlt4XjKgAYwbhAO1u8OmYSxmzUk/d9DqLoJ3vSyKjrCnext5yTdo5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cd8FjDae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cd8FjDae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B32C116C6;
	Tue, 13 Jan 2026 05:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280983;
	bh=UfvFSyQvMsF+1+H5v1iLg0/p3AR2bqf7nHryvjSdx+o=;
	h=Date:To:From:Subject:From;
	b=cd8FjDaeuxJwVHFxpEiBIcWMxz0UzbcAnJx54QAg4kyBDp5TbvPsjtw5pDqWw9hYq
	 +RhMNau+9zX+c0xjq1pYeZsk1G1JZlvNGV6y7/exxSuut3L/W6M8hu7JMIvjWqgArQ
	 8BXKAPI/Pr3f9fSG9R5poOaqFsybcBXXsY3OvTa4=
Date: Mon, 12 Jan 2026 21:09:42 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,stable@vger.kernel.org,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,pbutsykin@cloudlinux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-error-pointer-free-in-zswap_cpu_comp_prepare.patch removed from -mm tree
Message-Id: <20260113050943.65B32C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-error-pointer-free-in-zswap_cpu_comp_prepare.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pavel Butsykin <pbutsykin@cloudlinux.com>
Subject: mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
Date: Wed, 31 Dec 2025 11:46:38 +0400

crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
only for NULL and can pass an error pointer to crypto_free_acomp().  Use
IS_ERR_OR_NULL() to only free valid acomp instances.

Link: https://lkml.kernel.org/r/20251231074638.2564302-1-pbutsykin@cloudlinux.com
Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside the lock")
Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-fix-error-pointer-free-in-zswap_cpu_comp_prepare
+++ a/mm/zswap.c
@@ -787,7 +787,7 @@ static int zswap_cpu_comp_prepare(unsign
 	return 0;
 
 fail:
-	if (acomp)
+	if (!IS_ERR_OR_NULL(acomp))
 		crypto_free_acomp(acomp);
 	kfree(buffer);
 	return ret;
_

Patches currently in -mm which might be from pbutsykin@cloudlinux.com are


