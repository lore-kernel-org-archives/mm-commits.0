Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4050D28466C;
	Thu, 21 Aug 2025 21:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812655; cv=none; b=CjmwG4PVEFlkhYKE7JU/vIFW9yH+eGUv3t8d+m0qrH+tkBFx8bdGN88CaTfLw7it5rU6Cmnacgtb/UgkQoAD21N1JFNRynN9VwZMTfJvnZniUkbaVCSbqVRBtCC8RTepbBW0IBmHHEeNtTpxko7s+j9VG3Z1UXGRbqCqUXTQS2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812655; c=relaxed/simple;
	bh=Y9dIwT3/TdLQKXD+Up9nmrBUIclqBPLq3HsGH3mXmoc=;
	h=Date:To:From:Subject:Message-Id; b=juyEvoVrixuYMZIuUcG0rN588rZJnq9V6M9kMTKv1kCg8yWaUUsLdBnS0z9elazPEu3Fa2WZxP0VDFygQMRD2bQRnjLae9j+4UZjIAMLR9XOiv/MBUIcdkfYNGaUT/en9DaG/vpHK9g4lJ/mYjYk+7pRWDmoYGvhlkQgDNCqiHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DZzscbEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DZzscbEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868C4C4CEEB;
	Thu, 21 Aug 2025 21:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755812654;
	bh=Y9dIwT3/TdLQKXD+Up9nmrBUIclqBPLq3HsGH3mXmoc=;
	h=Date:To:From:Subject:From;
	b=DZzscbEFw56wd2JHxr+AyuvGZxE9q27LYTJIsqpXMdrWtlEtpsqzuIwlfDnWO738T
	 gvIoXN2Zs7WSApXD3Edn/R/7u2UbzzjOdoa8aiSek7YDjXd/ouWjPkyOtSDYvMNtt9
	 Ck2yPNQIkY6cvCAg40rGaf0wgSG+IJmwaTZKlDaY=
Date: Thu, 21 Aug 2025 14:44:14 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,apanyaki@amazon.com,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota.patch added to mm-hotfixes-unstable branch
Message-Id: <20250821214414.868C4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota.patch

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
From: Quanmin Yan <yanquanmin1@huawei.com>
Subject: mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()
Date: Thu, 21 Aug 2025 20:55:55 +0800

On 32-bit systems, the throughput calculation in
damos_set_effective_quota() is prone to unnecessary multiplication
overflow.  Using mult_frac() to fix it.

Andrew Paniakin also recently found and privately reported this issue, on
64 bit systems.  This can also happen on 64-bit systems, once the charged
size exceeds ~17 TiB.  On systems running for long time in production,
this issue can actually happen.

More specifically, when a DAMOS scheme having the time quota run for
longtime, throughput calculation can overflow and set esz too small.  As a
result, speed of the scheme get unexpectedly slow.

Link: https://lkml.kernel.org/r/20250821125555.3020951-1-yanquanmin1@huawei.com
Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reported-by: Andrew Paniakin <apanyaki@amazon.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>	[5.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota
+++ a/mm/damon/core.c
@@ -2073,8 +2073,8 @@ static void damos_set_effective_quota(st
 
 	if (quota->ms) {
 		if (quota->total_charged_ns)
-			throughput = quota->total_charged_sz * 1000000 /
-				quota->total_charged_ns;
+			throughput = mult_frac(quota->total_charged_sz, 1000000,
+							quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are

mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota.patch

