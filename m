Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93981F5847;
	Sat,  3 Jan 2026 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767463753; cv=none; b=CDsqyvEh3f86dzm6+brIGQcxPs8TJi7pP+/4NLBBCGe/DIm1DdCB980Ho3uAyHUVw9pInjngmXtpm9mA5PeS1RPhiDaqQhgtNpiDjZJdsLqGQ78Yg5q0ueJjIXpcXpF6qxOpp1fTPUfmrEsTY6UnSGGd1czvtp1Q4k11alIWz9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767463753; c=relaxed/simple;
	bh=pfU1FDiDb1uYYzMrFVdLVt+Zfm7Inziq/PSBi5rbVJg=;
	h=Date:To:From:Subject:Message-Id; b=FtkFVCrgR1sXtz88RU6dqsKPPY/QNUZnX03cx5FdqpUwKve7EFjFidb80ik7ccFIDh/ruN5WQx2+dqj02aU0XdVWFtrpffIJOhttlOUyM896p7T6G5lGCssyStfCP42eTpJxLPi+yDcKiw+TuQXmlkHw3mul8jbZ+Yo35uZsybQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v7k2egK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v7k2egK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4F2C113D0;
	Sat,  3 Jan 2026 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767463752;
	bh=pfU1FDiDb1uYYzMrFVdLVt+Zfm7Inziq/PSBi5rbVJg=;
	h=Date:To:From:Subject:From;
	b=v7k2egK5mvoUruE/O4uR/c+oLPJMGyLsK4QZWLjaTxsxjvIOqTpbI20Vhq/k4+QGg
	 WkEn/otOuJGq1gkumSW8mh6EnvAiXDHgHCMlR+lYBCmJcTg7O51PffagtNC6dxLiBe
	 wecx8sGocTTRW+yFjWdtdF2wa8iVJH748MrWEeos=
Date: Sat, 03 Jan 2026 10:09:11 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,stable@vger.kernel.org,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,pbutsykin@cloudlinux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-error-pointer-free-in-zswap_cpu_comp_prepare.patch added to mm-hotfixes-unstable branch
Message-Id: <20260103180912.0B4F2C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-error-pointer-free-in-zswap_cpu_comp_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-error-pointer-free-in-zswap_cpu_comp_prepare.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
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

mm-zswap-fix-error-pointer-free-in-zswap_cpu_comp_prepare.patch

