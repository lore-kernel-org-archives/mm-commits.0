Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640350;
	b=YciyRfnQlA5AMLNTKKV4sUhE6936XqSCJyIIYmgqmKej9ASsCZOubTT3PkV2q52aeRXG
	 8fpaUMR2i9JMarvZEScf3JbzizQLxK3NwZ8JZpV6GdpN2DiBRLk20tOQAeXq5m2GAqgAY
	 ubheN5M1/WphJyrt8MjKe9t9brQfM5CYEcwl49I79m00WqFsiw3Swm+PLvncl/QVJdrtU
	 x1YMsYIPcBzHyZYH70lL4/vM8TVkEXgbF5sOPvqX9YMxAY/qfmTcpEd0ney2NjM5f9VfS
	 gWTTX3NXYjjf0F+CnIuBzhbVSNZPPN1E3g57bGmfyvZAIGz2k5VvX3V0Xqw8glCrY4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640350;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gK2cd0iytFDyOGQSyjmNZe4zDRwemN4RkYmRuNumiv0=;
	b=qY8RH9APDk0sYBAfYH+jOLjVYaUAuRsdktEavX3Vw2CDVFkW2U97ODZsa9eMZGuTtU76
	 S7/Xe5LiXfZ59p+eKxqUf0Hy6dVgLGGOEBn0Zoi7TusQqaR9rE6F+lrC76SomIb6nurbh
	 ouATL1se3sDKHGafG+KtBFpnqb01KVYl0VnA6MIHYxw4LQSe6y8mv4PTn7UoWK7jq+K8n
	 d7TK42VT+/JcwGFCHq1x3PcQMkxLNgWMbjGi1CnUaROC+ySUntHNJ8RDYmzwNb6B9bgcl
	 aXcGnfR4xt30rJ5rXbBOypOUT12t6MHI4QJrhsB/0jUctqn8KTyzJCoVpA6eqi2mZJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WLcjP4kb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DAD606A329
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WLcjP4kb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0031F00A18;
	Mon,  2 Nov 2026 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640350;
	bh=gK2cd0iytFDyOGQSyjmNZe4zDRwemN4RkYmRuNumiv0=;
	h=Date:To:From:Subject;
	b=WLcjP4kbNBZ1a9gGs7bmWkJWh2e1Y0FlGFm7eo3ZKYM64aAorcBXtacFJjm6PNeGE
	 7+dZljUf4Aaw3v/WzPZ+ETC/9YffTET6BxTU8e4n1h1r0OTg5DxC/fQaz3+xshPAHt
	 7ppxIj8K+puHBChqyOqPNc0tT1W3Aq3zb7M4ilrY=
Date: Mon, 02 Nov 2026 09:25:49 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,corbet@lwn.net,adrianhuang0701@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch added to mm-new branch
Message-Id: <20261102172549.DD0031F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix incorrect option syntax in perf example
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch

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
Subject: Docs/admin-guide/mm/damon/usage: fix incorrect option syntax in perf example
Date: Mon, 02 Nov 2026 07:28:47 -0800

The kill command in the DAMON documentation uses an incorrect
option syntax in the perf example.

Use kill -9 instead of kill 9 to correctly send SIGKILL to
the perf process.

Link: https://lore.kernel.org/20261102152849.96057-4-sj@kernel.org
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -749,7 +749,7 @@ show results using tracepoint supporting
     # echo on > kdamonds/0/state
     # perf record -e damon:damon_aggregated &
     # sleep 5
-    # kill 9 $(pidof perf)
+    # kill -9 $(pidof perf)
     # echo off > kdamonds/0/state
     # perf script
     kdamond.0 46568 [027] 79357.842179: damon:damon_aggregated: target_id=0 nr_regions=11 122509119488-135708762112: 0 864
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch
docs-admin-guide-mm-damon-fix-various-typos.patch
docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch
docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch

