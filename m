Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3608248D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104499; cv=none; b=J/lezdw+wedDh7LrwoopcplaLkNIqt2B3CCwDxDQK6bzsBOxyfjWRXWypU5GRo71i3MHHBSpvq/+43V1/ablImdgKot5bMxhIHuI4OHJbMRaw8rLnYRXgYsIZiQZLyBRrFKMbjReWPDzGGT4ao80j9foNcQsngimm7ZrVNNarYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104499; c=relaxed/simple;
	bh=dgrDDT7mBsr+KOUTORlBsINfaAcTxq7Mo+WJnN5GPfU=;
	h=Date:To:From:Subject:Message-Id; b=q8Yu4sYyHDwTgSPDN7do5HyEai3MFGNN2rOsHlrPdk2QMFzQG5A6G+Si0t8VIGxznaR6zLOpE/RBEj+g23PGaRxZrh9xcM3+GvHH4ld8FaWbU+nzqwerW2+8m8UIoN/tJ19/+9B8eK83Iw/ejxuboBkjgcuWVEaWwXIv9TwieVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXcIdj6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXcIdj6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C85C113CD;
	Fri, 26 Apr 2024 04:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104499;
	bh=dgrDDT7mBsr+KOUTORlBsINfaAcTxq7Mo+WJnN5GPfU=;
	h=Date:To:From:Subject:From;
	b=XXcIdj6pr/RF58fubyULkyn8FTTtPbSa47tGz51pEJ5CjIwe+H1OH3vdzXw2Qu4ZD
	 bhPNzfndMOxOxxy763UOMR9lA8QN/0nkkividpScs7XlQXI9jjKxxSoSj1rW0WsPm6
	 0oCiEntk3Z0B4I0jlyg23CRfCvUAflXHOtx+noWA=
Date: Thu, 25 Apr 2024 21:08:18 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpumask-delete-unused-reset_cpu_possible_mask.patch removed from -mm tree
Message-Id: <20240426040819.61C85C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cpumask: delete unused reset_cpu_possible_mask()
has been removed from the -mm tree.  Its filename was
     cpumask-delete-unused-reset_cpu_possible_mask.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: cpumask: delete unused reset_cpu_possible_mask()
Date: Wed, 17 Apr 2024 23:11:23 +0300

Link: https://lkml.kernel.org/r/20240417201123.2961-1-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/cpumask.h~cpumask-delete-unused-reset_cpu_possible_mask
+++ a/include/linux/cpumask.h
@@ -1017,11 +1017,6 @@ void init_cpu_present(const struct cpuma
 void init_cpu_possible(const struct cpumask *src);
 void init_cpu_online(const struct cpumask *src);
 
-static inline void reset_cpu_possible_mask(void)
-{
-	bitmap_zero(cpumask_bits(&__cpu_possible_mask), NR_CPUS);
-}
-
 static inline void
 set_cpu_possible(unsigned int cpu, bool possible)
 {
_

Patches currently in -mm which might be from adobriyan@gmail.com are


