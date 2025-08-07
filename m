Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C7B4AEE2
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 04:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754540479; cv=none; b=Nk0S1p+pa78PndHFCf6yXbA1gvAJS2W+NkIc9TreoWqONM2R7apw/bkoirPxyq2/99/Yuq2hh2iSz83GKyaaWG4gzcfnLEnsvttE1zfThmy6djvnVo4U15LU8QG8+z14UptEr62+CKNhxCm0kKX9xmHfF3T9t52Zgdf/uhDcwZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754540479; c=relaxed/simple;
	bh=KFOL3b5HeJZTux0yAzwi6ytv19gtG/h92Ex6+Iir2r8=;
	h=Date:To:From:Subject:Message-Id; b=D04GpqZ9UBOffdVDyO85ug2GjcaP/JUFCoXjapAUDHYOS7OBXuFMi3BPFkq62oD0om+RhAeBU/38EVenzrgGPFA80/R8YAeaXSDWrky75HaYLMFOyAeqLEhjHctfcVtxaQq3C9xzh4SFQmv1XGIvzRbOZgM259n+MdEfrGNb4RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kR52dAaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kR52dAaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420B9C4CEEB;
	Thu,  7 Aug 2025 04:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754540478;
	bh=KFOL3b5HeJZTux0yAzwi6ytv19gtG/h92Ex6+Iir2r8=;
	h=Date:To:From:Subject:From;
	b=kR52dAaUOQ+JxxvBhEhfcFBfDFre2jARDRrLbq62k4z7WmPx+VbfTGfD3T3ZP4H3H
	 p6rHapVER6GqACxHR1JfyUJdzh3ZS4S+7wMD8S6L2dQyhiufsbB352otGb1w+hIEz5
	 bZ572Y9pE9JIpSPsOv91csykfrT2QIv7pTElyTfY=
Date: Wed, 06 Aug 2025 21:21:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ida-remove-the-ida_simple_xxx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20250807042118.420B9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ida: remove the ida_simple_xxx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ida-remove-the-ida_simple_xxx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ida-remove-the-ida_simple_xxx-api.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ida: remove the ida_simple_xxx() API
Date: Mon, 14 Jul 2025 10:17:09 +0200

All users of the ida_simple_xxx() have been converted.  In Linux 6.11-rc2,
the only callers are in tools/testing/.

So it is now time to remove the definition of this old and deprecated
ida_simple_get() and ida_simple_remove().

Link: https://lkml.kernel.org/r/aa205f45fef70a9c948b6a98bad06da58e4de776.1752480043.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/idr.h~ida-remove-the-ida_simple_xxx-api
+++ a/include/linux/idr.h
@@ -334,14 +334,6 @@ static inline void ida_init(struct ida *
 	xa_init_flags(&ida->xa, IDA_INIT_FLAGS);
 }
 
-/*
- * ida_simple_get() and ida_simple_remove() are deprecated. Use
- * ida_alloc() and ida_free() instead respectively.
- */
-#define ida_simple_get(ida, start, end, gfp)	\
-			ida_alloc_range(ida, start, (end) - 1, gfp)
-#define ida_simple_remove(ida, id)	ida_free(ida, id)
-
 static inline bool ida_is_empty(const struct ida *ida)
 {
 	return xa_empty(&ida->xa);
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
ida-remove-the-ida_simple_xxx-api.patch
nvmem-update-a-comment-related-to-struct-nvmem_config.patch

