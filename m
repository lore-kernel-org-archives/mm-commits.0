Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0592D41C85
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741216369; cv=none; b=n0tJYTmY2vQWMef7pU7JumnVBoZ36eI+4O422y3wn3U5bK8syletsdAviZVCVynOFTXr8vOljuHr9IQ3rEPawILg/VXs0sq1mRPwxPcrR0jMBj1ayj+uuCQjtfbWOTq8bCpo7oNY1sf1vYvL9B/HdJD9OiY9HoSdVtGxe6rVA/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741216369; c=relaxed/simple;
	bh=t4ExQCa3/sf/g1fzmRdTNnTY6OB5kqyUuudWe5aM+BY=;
	h=Date:To:From:Subject:Message-Id; b=kbreNKpAkJ95pfI0gBKnqKgU5ayglcqsKocxT6lKENP1wv7naY/2SrdOlcJKj4GbTExs1xiuKPANiHnnrcdLWJvXdBnlfZGKW9whChvTDJdWxzixkQ1wKusZ4I6/TARq6jtF1RQXRBW7TyJ0TgJO01AemBy/8/pzlTwxT5xkei0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EX2HnbNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EX2HnbNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B38C4CEE0;
	Wed,  5 Mar 2025 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741216368;
	bh=t4ExQCa3/sf/g1fzmRdTNnTY6OB5kqyUuudWe5aM+BY=;
	h=Date:To:From:Subject:From;
	b=EX2HnbNCvwQf5n699EYR5YnLZ2TrSxl7y2hEfM8xWVgxSPDRMWBiLKhbOBkDBMTDN
	 md2dnGIqqSKpEtmfcC4/Eh5o5KwkrTATV03XpD6IRVw7+elg4IIJdfusGuVDuB630S
	 V+U20KiXE1HuGSPQ/EuYSr+CPh+L3KvmoQJuYTDo=
Date: Wed, 05 Mar 2025 15:12:48 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix.patch added to mm-unstable branch
Message-Id: <20250305231248.B3B38C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix.patch

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
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix
Date: Wed, 5 Mar 2025 18:57:51 +0000

update the docs

Link: https://lkml.kernel.org/r/Z8ier-ZZp8T6MOTH@google.com
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/zsmalloc.rst |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/Documentation/mm/zsmalloc.rst~mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix
+++ a/Documentation/mm/zsmalloc.rst
@@ -27,9 +27,8 @@ Instead, it returns an opaque handle (un
 location of the allocated object. The reason for this indirection is that
 zsmalloc does not keep zspages permanently mapped since that would cause
 issues on 32-bit systems where the VA region for kernel space mappings
-is very small. So, before using the allocating memory, the object has to
-be mapped using zs_map_object() to get a usable pointer and subsequently
-unmapped using zs_unmap_object().
+is very small. So, using the allocated memory should be done through the
+proper handle-based APIs.
 
 stat
 ====
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

mm-z3fold-remove-z3fold.patch
mm-zbud-remove-zbud.patch
mm-zpool-add-interfaces-for-object-read-write-apis.patch
mm-zswap-use-object-read-write-apis-instead-of-object-mapping-apis.patch
mm-zpool-remove-object-mapping-apis.patch
mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas.patch
mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix.patch
mm-zpool-remove-zpool_malloc_support_movable.patch

