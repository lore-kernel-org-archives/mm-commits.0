Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640273;
	b=Ilfn/ySmj3KPygbb6wK2iVMk5jZfUAHVeFBNS+wItfWN825nynZnSOen5TDS1c0+nDvk
	 dYGFpIHcpECn63w30zgjfLQlrn5YQ1S686b7LXfgO8Ejkc/ZRzK7Ki8cWpOkzzbjGIR65
	 WkKmwgcL7nxMm6FJFIZ495BdSFcVN0RzND3l1oYPFL4qCC3XVmrEH0dsn4HJl1PwO7k30
	 Qtry43nPDEfLPKcwCrHFS+kg+rLNQY/ePf5geUuFnu4XcOg7vcIZe9Gv4Z2yS6LiF6X56
	 sbvtEsooehTtP9O21bZDIr9LknJX14lwy+vlzuUN8h+neBGdYvAWl0WV32rvsihBPqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640273;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2oUf05ehlL8YWzBiFq4Jlm4BwwNhTvFuvDBgcAS5iKg=;
	b=0hVgxmdD1roZ1Qh3D4EevOQJL6+/jZaO/pZEndUg7ohbJlhfpG8b3iIT5nbYb7q6DKr5
	 wsH4UNmT3wvtOpavpiGRR55eAXwfsz5mOyy/N8IxbLlWoGF9oFQJwAjpQYCWp16Oomk/l
	 p7IEJfLF7dpNX/JhEvY4s1ui2IJ9xlwmy9/8aOf6OpFbZNhIBCV07v/oXOlwqp4jmU/Jj
	 bQwWWvcbIkDOYx3daNLSuQ42H0SKUzOKJap23hCgIYgPw9ot6sXIKBsIRepYc4aa69Kbw
	 EHl6FQJSZQp/V96a0i1v3dZhZui7zCJwKvWfydKZQVRJBLyVSf3C7mQcgsBonoKy7Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="cry/lNP4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6E1606B922
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cry/lNP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8D31F00A16;
	Mon,  2 Nov 2026 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640272;
	bh=2oUf05ehlL8YWzBiFq4Jlm4BwwNhTvFuvDBgcAS5iKg=;
	h=Date:To:From:Subject;
	b=cry/lNP4oR2Rg6lMK+lcLERqkMad3vUS6X13ejIP7+sz5CSZZV7OJwyq+6f7FeKxZ
	 jpLISo27kgZ0ZGGhurM9sKnex8GwPVHwcwyVyfU0fD7JV0VF46BlSZlen2LIRFU/Ql
	 XHzGg+2v3R2s/iW46JUqAT+5eosFOu/0vmiFxV0k=
Date: Mon, 02 Nov 2026 09:24:31 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,sh@gentwo.org,
	ruanjinjie@huawei.com,lienze@kylinos.cn,jm5905938@gmail.com,
	jaeyeon.lee.dev@gmail.com,adrianhuang0701@gmail.com,
	manuelebnerli@mailbox.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-fix-typo-and-grammar.patch added to mm-new branch
Message-Id: <20261102172432.4A8D31F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/reclaim: fix typo and grammar
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-fix-typo-and-grammar.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-fix-typo-and-grammar.patch

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
From: Manuel Ebner <manuelebnerli@mailbox.org>
Subject: mm/damon/reclaim: fix typo and grammar
Date: Mon, 02 Nov 2026 07:07:54 -0800

DAMON_RCLAIM -> DAMON_RECLAIM
set as -> set to

Link: https://lore.kernel.org/20261102150757.93058-8-sj@kernel.org
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
CC: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Cc: Aveline Noir <jm5905938@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
---

 mm/damon/reclaim.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-fix-typo-and-grammar
+++ a/mm/damon/reclaim.c
@@ -19,8 +19,8 @@
 /*
  * Enable or disable DAMON_RECLAIM.
  *
- * You can enable DAMON_RCLAIM by setting the value of this parameter as ``Y``.
- * Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could
+ * You can enable DAMON_RECLAIM by setting the value of this parameter to ``Y``.
+ * Setting it to ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could
  * do no real monitoring and reclamation due to the watermarks-based activation
  * condition.  Refer to below descriptions for the watermarks parameter for
  * this.
@@ -31,9 +31,9 @@ static bool enabled __read_mostly;
  * Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
  *
  * Input parameters that updated while DAMON_RECLAIM is running are not applied
- * by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+ * by default.  Once this parameter is set to ``Y``, DAMON_RECLAIM reads values
  * of parameters except ``enabled`` again.  Once the re-reading is done, this
- * parameter is set as ``N``.  If invalid parameters are found while the
+ * parameter is set to ``N``.  If invalid parameters are found while the
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
@@ -92,11 +92,11 @@ module_param(quota_autotune_feedback, ul
 /*
  * Auto-tune monitoring intervals.
  *
- * If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+ * If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAMON's
  * sampling and aggregation intervals.  The auto-tuning aims to capture
  * meaningful amount of access events in each DAMON-snapshot, while keeping the
  * sampling intervals 5 milliseconds in minimum, and 10 seconds in maximum.
- * Setting this as ``N`` disables the auto-tuning.
+ * Setting this to ``N`` disables the auto-tuning.
  *
  * Disabled by default.
  */
@@ -151,7 +151,7 @@ static unsigned long addr_unit __read_mo
 /*
  * Skip anonymous pages reclamation.
  *
- * If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+ * If this parameter is set to ``Y``, DAMON_RECLAIM does not reclaim anonymous
  * pages.  By default, ``N``.
  */
 static bool skip_anon __read_mostly;
_

Patches currently in -mm which might be from manuelebnerli@mailbox.org are

mm-damon-reclaim-fix-typo-and-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-grammar-and-stlye.patch

