Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB538F9A;
	Tue, 25 Jun 2024 03:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287559; cv=none; b=tBZEpUDqj1g5ee4EVkN4YpGWlGDfQE+1xs2dA7AdonAFr1ZNjQEv2L1hWEKdR7ROVRTbz9zCL3eqlNFTL2bPe65iKvLc9PPiruew4GUQkCpUYeGFGCDGH1RP2rAZ+CbAm2E0/Jo3ehT1mBgNND4EfGJNQGOQ1oCQEP31WjY72MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287559; c=relaxed/simple;
	bh=FUbMS3OyacUdeYu3I/o4by/lbi0VRe4UA+QVM4sWilE=;
	h=Date:To:From:Subject:Message-Id; b=ljWclOBIbb78r2qJolcMnKVkBR1tJ/lC2YwIscL4CMFJoo/8a+AljcwnMbqpAD5J8EdXc7XSSjCpJxX9XaI5mHz1CxEyAAkHmns9fkAgbfrBWaXK/WvAC3k4GqTJIlBeC70sItnKFFJeCQa2vMe8oxRFWrrQJk5Rg/5zDv2Cymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dgK5dFCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dgK5dFCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD68C32782;
	Tue, 25 Jun 2024 03:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287558;
	bh=FUbMS3OyacUdeYu3I/o4by/lbi0VRe4UA+QVM4sWilE=;
	h=Date:To:From:Subject:From;
	b=dgK5dFCzRMRIYy0LOJ8n0lBvT7Sryh9bmIXo63IcMIF+E4Q0mXtyDkWMN2iM62TEL
	 qQvRXiY9H8cLiU9bXbV6DH31UxMH/BsKOVKRXWA1tNCEGne08V1br15Y87XnlBa98B
	 xucFPZA/7HN7bqrUtd18aPl0u0BkpDK7mG/cTO1Y=
Date: Mon, 24 Jun 2024 20:52:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,spender@grsecurity.net,elver@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-fix-bad-call-to-unpoison_slab_object.patch removed from -mm tree
Message-Id: <20240625035238.BCD68C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: fix bad call to unpoison_slab_object
has been removed from the -mm tree.  Its filename was
     kasan-fix-bad-call-to-unpoison_slab_object.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: fix bad call to unpoison_slab_object
Date: Fri, 14 Jun 2024 16:32:38 +0200

Commit 29d7355a9d05 ("kasan: save alloc stack traces for mempool") messed
up one of the calls to unpoison_slab_object: the last two arguments are
supposed to be GFP flags and whether to init the object memory.

Fix the call.

Without this fix, __kasan_mempool_unpoison_object provides the object's
size as GFP flags to unpoison_slab_object, which can cause LOCKDEP reports
(and probably other issues).

Link: https://lkml.kernel.org/r/20240614143238.60323-1-andrey.konovalov@linux.dev
Fixes: 29d7355a9d05 ("kasan: save alloc stack traces for mempool")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: Brad Spengler <spender@grsecurity.net>
Acked-by: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-fix-bad-call-to-unpoison_slab_object
+++ a/mm/kasan/common.c
@@ -532,7 +532,7 @@ void __kasan_mempool_unpoison_object(voi
 		return;
 
 	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
-	unpoison_slab_object(slab->slab_cache, ptr, size, flags);
+	unpoison_slab_object(slab->slab_cache, ptr, flags, false);
 
 	/* Poison the redzone and save alloc info for kmalloc() allocations. */
 	if (is_kmalloc_cache(slab->slab_cache))
_

Patches currently in -mm which might be from andreyknvl@gmail.com are


