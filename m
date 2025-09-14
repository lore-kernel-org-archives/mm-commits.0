Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69307262D
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810104; cv=none; b=UfpXP/YUmlIiu3XgDlJ8EqrskUWJsMPdCl+vDghRbmaj1R2+WZKz8Yd5AeKPHfwWvRTl50Y1XV5xNVy27ZiENoe+LzbfEbpv+cbypBP36vRr5xA1g3OPMtQW0eb6nZzSezHUk9/BhWYyegZtj4qzFB0EIXKXiusCcRhQNwor/wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810104; c=relaxed/simple;
	bh=0nPMnD/K7Px3rdZ31Gx3cE5sW8HHCR1eqVuT2uz3yEc=;
	h=Date:To:From:Subject:Message-Id; b=eMOWEMpj5EGCFlZGLCLqooNQVkzo0Y/VYTL1CXEX9qRYKyNuC2lJkRevlpEEkNU3OTaC66Ii/u+fmkcev29ZSvnnQEP46bXAtePAKxHwA68I/sB2c0CezzA6fv9HZv+H6NdcS4IX6fGTeTG9Vj8PaWeoI7LQKLB8SVqJewlNo0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ooKlo1Yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ooKlo1Yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D7FC4CEEB;
	Sun, 14 Sep 2025 00:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810102;
	bh=0nPMnD/K7Px3rdZ31Gx3cE5sW8HHCR1eqVuT2uz3yEc=;
	h=Date:To:From:Subject:From;
	b=ooKlo1Yuh7QRnK6UREpPpHC0BCwKC4tzZtWr77cEFCdMQcf7FMnEZa7hU0WiQ51r3
	 uWJGlWHTAi4yFvCOgNz9IOwGzheSyhdnMFHZ4OUqZgLlsB+s1rk0q947PcmsDDlCiI
	 auTQwxDcz6XspXg2HOAY115Qtd6kyaIKPRRE4i5s=
Date: Sat, 13 Sep 2025 17:35:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ida-remove-the-ida_simple_xxx-api.patch removed from -mm tree
Message-Id: <20250914003502.59D7FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ida: remove the ida_simple_xxx() API
has been removed from the -mm tree.  Its filename was
     ida-remove-the-ida_simple_xxx-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


