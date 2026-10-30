Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793323815;
	b=lhPUP8bT8wqRIoG4Kszfio7RAnL8Nfp2LP9IF7+DzO5yW2llRl/eBGOnCge3UHGkPlkk
	 b2gsdj/KAfKtcc9ubJ8QQmrSGnRlvxvVno3JxANCMgzfAg8OFD096k8ZImJtzFPBIqRTf
	 6YSwbdiNl/Fzb+X24AyV7bGOjpXi4XMjobrE4kKiad4bY7JY1OskIcerhzntnmmUWvOJJ
	 2/8/7eYmBvQJ0XYNra6dNlm/hXXahq4ZZ/QGfaWJg4Jkd3PQMJNn8h7HE4nmM2EAj3SQI
	 hRq+xt5TpfbG4Durk53fuWo7aeS24tFsIXNbqfSaB6X8bj9ZE4jKi0g3D2Hpb0O61Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793323815;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4woWJ7aYhq+t61jBwDDadTnJQTlBwuYZe5gbYG5JVsA=;
	b=d17XchTLOEbUZF486aiNNpZQBPIzq7QquBw/Vhr0YBVsJI8PorVLjafU5VsgJbsgqxZN
	 ddqvMKYlgfajrr8+EIOLHPSYMhLPkGAQKTgKE46Tf3iEN0uzfjRuVfaxhUH/HDgJy4toW
	 VC6sY4uPLJ4njm8nvOWOI+Hs1lQgKaV0RdVrauovGAq3RxuetrjMT4FxFinnyqyu1X+32
	 FGvWkjc4bPoxO6OQqcZkPNOIHHIliBaVL34tLouSYiMb8uyd8gSKJWPD1Lc3akeqnYPPA
	 H/oCAXJf8/xF4X41q67IC1LrrghNsqNOc/qxvMSB2IiOJC0TTOr5shh+EL2fKuMbWUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Wen3kO5D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12748606A31A;
	Fri, 30 Oct 2026 01:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Wen3kO5D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AD41F000C1;
	Fri, 30 Oct 2026 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793323814;
	bh=4woWJ7aYhq+t61jBwDDadTnJQTlBwuYZe5gbYG5JVsA=;
	h=Date:To:From:Subject;
	b=Wen3kO5DKfmaMiiw31dfWGavScxQiWHuhGFC24Q/8JGY/RPdgzcPTIn3ka5OVqBP9
	 z8f70jDb/kT3lAvJ+L19+aYd17FLh9Lo3LdIHtw6RDT4Z3qfBaEhpXqAPR5jrsC3OI
	 Qgk+kUTQUE+s8krmDHOuoNju00CBsUMWrDRjLdbw=
Date: Thu, 29 Oct 2026 18:30:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pjw@kernel.org,
	muchun.song@linux.dev,glider@google.com,elver@google.com,dvyukov@google.com,
	aou@eecs.berkeley.edu,alex@ghiti.fr,liuyun01@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-fix-pool-cleanup-on-metadata-allocation-failure.patch added to mm-new branch
Message-Id: <20261030013014.47AD41F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kfence: fix pool cleanup on metadata allocation failure
has been added to the -mm mm-new branch.  Its filename is
     kfence-fix-pool-cleanup-on-metadata-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-fix-pool-cleanup-on-metadata-allocation-failure.patch

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
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: kfence: fix pool cleanup on metadata allocation failure
Date: Thu, 29 Oct 2026 10:57:41 +0800

Patch series "kfence: fix pool allocation failure handling", v2.

Fix the cleanup address and page reuse window in failed late KFENCE
initialization. Also let RISC-V boot if the early pool reservation fails.

Patch 2 depends on patch 1. Patch 3 can be applied independently.


This patch (of 3):

kfence_init_late() saves __kfence_pool in addr before allocating the pool,
so addr is still NULL if metadata allocation fails. The error path then
tries to free pages using that address.

Set addr after pool allocation so cleanup frees the allocated pool.

Link: https://lore.kernel.org/cover.1793242457.git.liuyun01@kylinos.cn
Link: https://lore.kernel.org/7e0fc28c73fbb594c296f6121ca506392511ba5e.1793242457.git.liuyun01@kylinos.cn
Fixes: cabdf74e6b31 ("mm: kfence: allocate kfence_metadata at runtime")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: AlexandreGhiti <alex@ghiti.fr>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/kfence/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~kfence-fix-pool-cleanup-on-metadata-allocation-failure
+++ a/mm/kfence/core.c
@@ -999,7 +999,7 @@ static int kfence_init_late(void)
 {
 	const unsigned long nr_pages_pool = KFENCE_POOL_SIZE / PAGE_SIZE;
 	const unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
-	unsigned long addr = (unsigned long)__kfence_pool;
+	unsigned long addr;
 	unsigned long free_size = KFENCE_POOL_SIZE;
 	int err = -ENOMEM;
 
@@ -1032,6 +1032,7 @@ static int kfence_init_late(void)
 						 GFP_KERNEL | __GFP_SKIP_KASAN);
 #endif
 
+	addr = (unsigned long)__kfence_pool;
 	if (!kfence_metadata_init)
 		goto free_pool;
 
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are

kfence-fix-pool-cleanup-on-metadata-allocation-failure.patch
kfence-clear-the-pool-pointer-before-freeing-pages.patch
riscv-keep-booting-if-kfence-pool-reservation-fails.patch

