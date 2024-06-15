Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3241870;
	Sat, 15 Jun 2024 01:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718415888; cv=none; b=CWLWawow+dyRY1lLif+z9T/UPRQYAXYghdZ13PlX/Xx+mQ8EpvFISa2qlEWy2JJCqfSWsY/0LtNE+QdjHFjtpJlQBmV0lEKEIweOD5lfE0stHIE65wx42ew1+qxEbDOvOmtjnGFkP3EeuQN6uijDJgKeQYFhw/5CxmvH60vuWIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718415888; c=relaxed/simple;
	bh=3GlSVhpcfL60jPqGfsDmotStx4RdNSrzoev9bqMMDyY=;
	h=Date:To:From:Subject:Message-Id; b=U2hTCUwa69W7Fwqhlqr8F//rXxpYwjPPSoDZdbkKY2xAEHWkrF9kUvppnPAfyJv8B+EyLub7Gj6rWrX83G8ohL64hLSP630b6vogpZ/wmqfxXqYzvxDjKu8cmmYNR7p6Qcu4M3FS7kSJ2AxthyUMua/bo5rZOcSXYYDOBJB3664=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JgA2tnZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JgA2tnZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC12C2BD10;
	Sat, 15 Jun 2024 01:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718415888;
	bh=3GlSVhpcfL60jPqGfsDmotStx4RdNSrzoev9bqMMDyY=;
	h=Date:To:From:Subject:From;
	b=JgA2tnZ60NpXAmslHJy3BFfS0OUe1CxSGiqTHDShraQyjV1RbdmUuX8HDZdLc0a7d
	 3mMz/yxqQj+PLv7gDVzhFqNVZP3vBsIyBxz2het69ybRuQG2/kZpBfXGOwXhQ4FNwW
	 SD5T3YB/K8TkQ4jTeVaZ54hDtW993VORDlxW03x8=
Date: Fri, 14 Jun 2024 18:44:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,spender@grsecurity.net,elver@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-bad-call-to-unpoison_slab_object.patch added to mm-hotfixes-unstable branch
Message-Id: <20240615014448.3BC12C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: fix bad call to unpoison_slab_object
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-fix-bad-call-to-unpoison_slab_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-bad-call-to-unpoison_slab_object.patch

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

kasan-fix-bad-call-to-unpoison_slab_object.patch

