Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828035;
	b=IqzTjnO3Bh8NgkulXXdWK+Ristig3AfDMxv2jrixl8sYgXn9u8zD5gCWJRQGqHLu4Xt2
	 /0FBembCxONDey1ltALG2ExRfi4irv4LCqaDVZs8IQMtMOE6lnnJNATfmbhzTTRyVgEsF
	 jKG1yiK+t5ZLwqX6nLeCd5z4T377iabCGFDaKLUNMM6gPKA0Jp+V4095kJ3pgZUjxZ9+n
	 6Ycnuoqa6z11K1gfowCT492UtrkfzUS8iXKUF4va1bZA1dVIPqGdDlNMAcVQGhHa1v40o
	 AGsVLRbBwZA3tCoBljnsj8MI4oIzCFFSnoQvpam9GD7YhebAt+3jnlMric+GfERLQnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828035;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JSQWoU+FaOvRC0Ltx/x/TGxxtUa2qsVC/JmcNBe3uwc=;
	b=g3d1I0FHuECmOQaolmokgzGLI6aCHEHsJd0dLluHb2gLeeQ7rUdYPygbcfIq4yUQ1xzC
	 JwdGg6iTXoEoCRBVriV5DgMTyJ1qNvxTVgGfQ8/zAIMsPCFNtv+gbHuZlLxKFp4jSF7Up
	 SGnnB7UvaDKDG2m+osmuAL19dtEai7LAIaxKVM6/Ogcmvthb8++agOnTL5J8Sv5Gsw+Wm
	 90O8DoJeFJDP0+48KoQrQCn94C1xBpINGJdVrqVKu2aCtpFdOttcAD5nUE2Ckpv0Nr6Sn
	 eDShpuvUAYATP5ye82rA+Kk8KimCCMtKVQN/sPNNYNjw4jrHn2Bpv5Zy4hpX5L73TuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sUrftLMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4CA606A322;
	Sat, 24 Oct 2026 07:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sUrftLMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78B01F01828;
	Sat, 24 Oct 2026 07:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828035;
	bh=JSQWoU+FaOvRC0Ltx/x/TGxxtUa2qsVC/JmcNBe3uwc=;
	h=Date:To:From:Subject;
	b=sUrftLMVwYdvnSkf1TtSPu4ZDbbJKSWEu6bc30OoDWU5mOIxvrfakoxPhqUHlTCHa
	 SDwfz+i0kszIQ3EQVrFQFd1/xJ5+UG2u0GxBzPMfyEF5IL674L/owsmAy/BgQMlAGt
	 maes+SS9lDYeBIqvJs6fnBXOU+EG+GUcM69Sn7kY=
Date: Sat, 24 Oct 2026 00:47:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,mikhail.v.gavrilov@gmail.com,mfleming@cloudflare.com,glider@google.com,elver@google.com,dvyukov@google.com,calebkan1106@gmail.com,andreyknvl@gmail.com,ckan@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] stackdepot-stop-preallocating-after-the-final-pool.patch removed from -mm tree
Message-Id: <20261024074714.D78B01F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: stackdepot: stop preallocating after the final pool
has been removed from the -mm tree.  Its filename was
     stackdepot-stop-preallocating-after-the-final-pool.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


