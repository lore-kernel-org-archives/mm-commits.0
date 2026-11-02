Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640261;
	b=B0nSuMgVf1E4YTVMs9mbWS9P2L1VfNAlDNr2Uy8tooc+W2y4QtCNoWDasyDCHKzovVmf
	 L3wa6jQJJEJGIQNNecLEJjnFlSF7Ge0sHXlm/0+K00jggp5MRHd08a57iat6Vzp/K9xKk
	 Ct2/Bpvbd5EJECwJbt479Z5LwkwXKDTkdI8eiyczOOLkFpn4MXKF7s5POoz2AwB8zLYl/
	 HPROdJhv6oHl8xYK4DSFzLDhtlApEiuhzcKJce9KBzad8wW+z8RfMgFXPM8U7IFReZHpq
	 j6G6Gqa99O/nOLy1zGnhi/M22unfXnyGRvi9Bi7WiKfJ5fsVKofq9zUfD13EnOqbteg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640261;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=V0y3pblMCGJB7OhfHnbp7uIOIWxIURz99gvb2tR2Xzg=;
	b=MqDFVVPfYsFnTzG356iKSrkmyGBse+bgXLIVsjMwUaQoxuyGuwi+Hlnows276CWQf+Ax
	 8bFvpRWb735qzWvVWJ76rnbpiRnwn5RbekDU6Q3XBtJuyW91viNrYrpGY5/5nZKyR9IFu
	 bMAUlHnhAg7pf9fXfh/p225U4LeJ1jx3jA+mB8oc4XvDSZROadRfXKSk87rcbfWJS/wpt
	 wHiPUnw/1eVCqKwJP3rriXc3dTRTUx0YcGoaIya2V03vTouxbGg89bO4PuluuKNButDLj
	 eiaSg0ICWhkSNBIWT5hwHMcTQduzm+xZZwj3I8oeB3Xn2uyosv1wu5tG9T4raGcsl8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GKIG590B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECF7606B1F1
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GKIG590B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A971F00A26;
	Mon,  2 Nov 2026 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640260;
	bh=V0y3pblMCGJB7OhfHnbp7uIOIWxIURz99gvb2tR2Xzg=;
	h=Date:To:From:Subject;
	b=GKIG590BvCIgaF9jxKpSNwYOXDZvWqaKn2vaNyESB5geWysiWlNcYLWzHIYeKx9kf
	 w31AJjHRT+SnoTRFbUaB9NizMvpzUG1Ur8MVEoH55XcpiAG5g14YIwW0qEB5G5K2uH
	 hmW4iM8l4t+ZPVaG6CMnYpPX2KzcilwyNgTEcgBQ=
Date: Mon, 02 Nov 2026 09:24:18 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,sh@gentwo.org,
	ruanjinjie@huawei.com,manuelebnerli@mailbox.org,lienze@kylinos.cn,
	jm5905938@gmail.com,jaeyeon.lee.dev@gmail.com,adrianhuang0701@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch added to mm-new branch
Message-Id: <20261102172420.44A971F00A26@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: remove unnecessary zero-initialization in damon_new_ctx()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch

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
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: mm/damon/core: remove unnecessary zero-initialization in damon_new_ctx()
Date: Mon, 02 Nov 2026 07:07:48 -0800

Patch series "mm/damon: various fixes and cleanup of code, test, and docs".

Fix and cleanup various parts of DAMON including its code, test, and
documentation.

Optimize the efficiency and monitoring accuracy of DAMON code with the
first five patches.  Remove unnecessary initializations in
damon_new_ctx() with patch 1 from Adrian Huang (Lenovo).  Align MMU
notifier ranges when clearing PTE/PMD young bits with patches 2 and 3
from Shubhang Kaushik (Ampere) and Aveline Noir.  Avoid DAMON_STAT idle
time percentile overflow on 32-bit architectures, and optimize out
unnecessary folio LRU isolation from DAMOS_MIGRATE action, with
patches 4 and 5 from Aveline Noir, respectively.

Fix and cleanup tests and documents with remaining four patches.  Let
sysfs.py test does not hang when it is executed under interactive
terminal with patch 6 from Jaeyeong Lee.  Fix typos, grammatical errors
and styles in DAMON_RECLAIM comments and DAMON_LRU_SORT user documents
with patches 7 and 8 from Manuel.  Finally, document how to disable
watermarks of DAMON_RECLAIM with patch 9 from Jinjie Ruan.

Reviewer notes.  This is a collection of DAMON patches that are posted
by individual contributors and resposted as an mm.git merge request.
Each patch has its own changelog.


This patch (of 9):

damon_new_ctx() allocates the context structure using kzalloc(),
which already initializes all fields to zero.

The explicit initialization of passed_sample_intervals,
next_aggregation_sis, and next_ops_update_sis is therefore redundant.
In addition, they are later initialized by kdamond_init_ctx() before use.

Remove the unnecessary assignments to simplify the code.

Link: https://lore.kernel.org/20261102150757.93058-1-sj@kernel.org
Link: https://lore.kernel.org/20261102150757.93058-2-sj@kernel.org
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Aveline Noir <jm5905938@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
---

 mm/damon/core.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx
+++ a/mm/damon/core.c
@@ -918,11 +918,6 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.aggr_interval = 100 * 1000;
 	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
 
-	ctx->passed_sample_intervals = 0;
-	/* These will be set from kdamond_init_ctx() */
-	ctx->next_aggregation_sis = 0;
-	ctx->next_ops_update_sis = 0;
-
 	mutex_init(&ctx->kdamond_lock);
 	INIT_LIST_HEAD(&ctx->call_controls);
 	mutex_init(&ctx->call_controls_lock);
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch

