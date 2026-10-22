Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684098;
	b=cS35Q18qULYTyaciCRYpTnkkAzmUgFa+xAmI4TkOc0s4KbOC4OJDqBV+0vJTxmOZC0PS
	 71bzHFhLtRzoXGnMl5C6AORyw+scvPorQIDuVyHL1dh1n6etFrMakgJnq4Jh9KCOUxMLu
	 4w8gubkPio9Nt7GxV8L7RkT9n15PtasPdAqgsSl+xdCUyQaG4MImTJgx1NkhihWtkGgwf
	 lvOpyzMF+bSe+jbB0uvk5p7yck+nhEELFPZBP8LwYey34ecD0epU0KaFCFSf9NLtFHywt
	 P9+0VUShzaOHo4RxrVjoGfhntu3SFuYRuHpUNB0KKkjEQA365eMVDOpcZ+m6hL/PoJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684098;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DJHu0ZqSeQG53m4MCCOO/gTd2CumbIeF9AY98lmFF5A=;
	b=BfiKhtCoougGlS/d+MACh00dpCZaOQGzAqoB2FB0nojh/8jEkCqimCcEYNAF88fXNVOY
	 gTmvivpqRKx0jNI9wCf/MeXt0amU3bUNaIpo/wdZjzAMW9mzmCt/lfrq5yp87WRJPmSNF
	 +zkeUzfF27hYz9DJRhc6T3jT1ji8nxmTKeyzvLrBj2N/8ltwcmOpy7IzH/f/N1WYbMuwP
	 A9GC4f26MoEJavxnBXl+zDn5cKnGsYlYB3qG1Gf1/77xgjO20rAqpCR2G6s2YgOfqFZCM
	 wJrWaD1GcyJ/SE7q2GvFjKE+f4jyBzLaY1w3MbcFVshs7UxBGMI+x/bAeLvdZbk8+Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A266D606A326;
	Thu, 22 Oct 2026 15:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407161F01825;
	Thu, 22 Oct 2026 15:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792684097;
	bh=DJHu0ZqSeQG53m4MCCOO/gTd2CumbIeF9AY98lmFF5A=;
	h=Date:To:From:Subject;
	b=i1u6oPOpKnXWIue+BZCJKdVQPa0AIzc4em+PfgcbI1eIEhNeg65a4C7ElVCxU22vi
	 QsJHP99Y2Pn29z7r9SbAQu3l2hiCG29kIhs3p0wo9OuZ41Tx9zWnii3WouE1shGHBf
	 PFiGkGPAKBhrdJaM1zrgV8+ReLjocaWt878LP5A4=
Date: Thu, 22 Oct 2026 08:48:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,mikhail.v.gavrilov@gmail.com,mfleming@cloudflare.com,glider@google.com,elver@google.com,dvyukov@google.com,calebkan1106@gmail.com,andreyknvl@gmail.com,ckan@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-stop-preallocating-after-the-final-pool.patch added to mm-nonmm-unstable branch
Message-Id: <20261022154817.407161F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: stackdepot: stop preallocating after the final pool
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     stackdepot-stop-preallocating-after-the-final-pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-stop-preallocating-after-the-final-pool.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Caleb Kan <ckan@cloudflare.com>
Subject: stackdepot: stop preallocating after the final pool
Date: Thu, 22 Oct 2026 09:33:30 +0100

depot_init_pool() decides whether another pool is needed before it
increments pools_num. When it registers the last allowed pool, pools_num
is still one below stack_max_pools, so the existing comparison clears
new_pool.

With new_pool cleared, stack_depot_save_flags() can allocate another
order-2 pool after a lookup miss. depot_keep_new_pool() retains its pointer
in the global new_pool, so the allocation is not lost. However, pools_num
has already reached stack_max_pools, and depot_init_pool() rejects every
attempt to register the pool. It remains allocated and unusable until
reboot. The non-NULL pointer prevents later saves from allocating more
spare pools.

Account for the pool being registered in the limit check so registering
the final pool installs STACK_DEPOT_POISON and prevents the extra
allocation.

Link: https://lore.kernel.org/20261022083330.3159793-1-matt@readmodwrite.com
Fixes: 31639fd6cebd ("stackdepot: use variable size records for non-evictable entries")
Signed-off-by: Caleb Kan <ckan@cloudflare.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Caleb Kan <calebkan1106@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~stackdepot-stop-preallocating-after-the-final-pool
+++ a/lib/stackdepot.c
@@ -323,7 +323,7 @@ static bool depot_init_pool(void **preal
 	 * NULL; do not reset to NULL if we have reached the maximum number of
 	 * pools.
 	 */
-	if (pools_num < stack_max_pools)
+	if (pools_num + 1 < stack_max_pools)
 		WRITE_ONCE(new_pool, NULL);
 	else
 		WRITE_ONCE(new_pool, STACK_DEPOT_POISON);
_

Patches currently in -mm which might be from ckan@cloudflare.com are

stackdepot-stop-preallocating-after-the-final-pool.patch

