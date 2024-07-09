Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAD71B86D4
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 21:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720560953; cv=none; b=aXaAQs68e2Xo4ZxBaC3IqsvIWLGceeVOSUEzV9xVmqX2fukIIE6IwKARi/YJC6sMFgRXAgaFpH5/Y+r1Et8mdrgq/2qMJwFVU/lgVmyCaUF1Znzhz9J+dg8P+jka5HMpzk+fmc+SPYLHRtO/o7meIOdOxhqAcf1c7Yaov4FkunI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720560953; c=relaxed/simple;
	bh=cJDMrDD16Fa9v6n2qtggRAkeEnkzt4evjs3j6H3Rk+Q=;
	h=Date:To:From:Subject:Message-Id; b=KkyX83RMY67dIiPV45yk2+xNsMctM9w+hLLEaPWi2jfNrC7GVQjAdD9U2A2ThTIhWJF+4rrQS6YCYdJ/sHagn3kUrX29Mgw5QlHIbkxn+4H8PCvILcsyAzxZMSnFdo1NS3FDs2IdH6MOF7rq3dwmBRPJlsIiCBrbmhZFL/ToreM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D9mY8QFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D9mY8QFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEFBC3277B;
	Tue,  9 Jul 2024 21:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720560952;
	bh=cJDMrDD16Fa9v6n2qtggRAkeEnkzt4evjs3j6H3Rk+Q=;
	h=Date:To:From:Subject:From;
	b=D9mY8QFcxjHUy9d3pYvL//3Nh/PY8EcuzEGhI4pTxjWmSKU2NKLKdYfdTwVb7fQj7
	 c9/zvVsueJatvXTHtPL8O0sOhpDUNgxFEs0/tr/9S4wrtiN0+kcdF9xHJXvdCsi5xb
	 P7+3zAf0wY6FyVagZmXQsJ0NjD5lSK9sx64iToa0=
Date: Tue, 09 Jul 2024 14:35:52 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_state-use-folio_alloc_mpol-in-__read_swap_cache_async.patch added to mm-unstable branch
Message-Id: <20240709213552.DFEFBC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap_state: use folio_alloc_mpol() in __read_swap_cache_async()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_state-use-folio_alloc_mpol-in-__read_swap_cache_async.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_state-use-folio_alloc_mpol-in-__read_swap_cache_async.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: swap_state: use folio_alloc_mpol() in __read_swap_cache_async()
Date: Tue, 9 Jul 2024 18:55:08 +0800

Convert to use folio_alloc_mpol() helper() in __read_swap_cache_async().

Link: https://lkml.kernel.org/r/20240709105508.3933823-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap_state-use-folio_alloc_mpol-in-__read_swap_cache_async
+++ a/mm/swap_state.c
@@ -470,8 +470,7 @@ struct folio *__read_swap_cache_async(sw
 		 * before marking swap_map SWAP_HAS_CACHE, when -EEXIST will
 		 * cause any racers to loop around until we add it to cache.
 		 */
-		folio = (struct folio *)alloc_pages_mpol(gfp_mask, 0,
-						mpol, ilx, numa_node_id());
+		folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
 		if (!folio)
                         goto fail_put_swap;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-swap_state-use-folio_alloc_mpol-in-__read_swap_cache_async.patch

