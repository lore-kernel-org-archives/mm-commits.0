Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A714B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908582; cv=none; b=iW/dCVI6nZ0DzgKGLgBlLG+tbuJBuEBi2nNVmuFwTtUZUi1OoDr7k6pGv6S85r+zzm1dVXPQKbQHg9EY/lCc3iOxlzmAhX+0ZnHlXtA7jns61KOt/DbzX5ZEsBgm3qyvePozDelh9RZOCR+9TkZs8K128PSuNnKyP/R9H1eIeWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908582; c=relaxed/simple;
	bh=XfeN3haK29U8+9jzPSn6ez0KEvDshu7bXtYY5uhAytQ=;
	h=Date:To:From:Subject:Message-Id; b=ebQIU78xMx2nPBZN2IRxaAXIeUjh+YLSJapktDhdVUGu70PthUq3Vr1c0llVX+LHp8aCfdW3Zo0o5ewJ48RqjiDGHGXthKWFPScwkxdvVCJnCyiaSewAq4jzHTFWnebRXLTDI6UMff4Ei4VQuDVwqHyjGG+aUjkOtoq5zrq9Fhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PHfvQo14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PHfvQo14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9294C19423;
	Wed, 12 Nov 2025 00:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908581;
	bh=XfeN3haK29U8+9jzPSn6ez0KEvDshu7bXtYY5uhAytQ=;
	h=Date:To:From:Subject:From;
	b=PHfvQo14+HTIq5Z4T7w4+pCGyAN4e4ehCqPn/ifIJolivd3cNwpMM3Njv/oA//xWo
	 gfdP8raR2NLQAiM/fTA+KsIFpLBONuYkwpH7htWP5OV0IUNbl3hVKw9JZC8essh9sG
	 fgmWAMBuoiFIonKLGfO8vJSuljZ7xAvpVWg7S8x4=
Date: Tue, 11 Nov 2025 16:49:41 -0800
To: mm-commits@vger.kernel.org,luc.vanoostenryck@gmail.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] compiler-remove-arch_sel.patch removed from -mm tree
Message-Id: <20251112004941.A9294C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler.h: remove ARCH_SEL()
has been removed from the -mm tree.  Its filename was
     compiler-remove-arch_sel.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: compiler.h: remove ARCH_SEL()
Date: Mon, 13 Oct 2025 11:12:02 +0200

Its last user was removed in commit 8ea815399c3f ("compiler: remove
__ADDRESSABLE_ASM{_STR,}() again").

Link: https://lkml.kernel.org/r/20251013-arch-sel-v1-1-7eef9b22ceb0@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/compiler.h~compiler-remove-arch_sel
+++ a/include/linux/compiler.h
@@ -269,12 +269,6 @@ static inline void *offset_to_ptr(const
 
 #endif /* __ASSEMBLY__ */
 
-#ifdef CONFIG_64BIT
-#define ARCH_SEL(a,b) a
-#else
-#define ARCH_SEL(a,b) b
-#endif
-
 /*
  * Force the compiler to emit 'sym' as a symbol, so that we can reference
  * it from inline assembler. Necessary in case 'sym' could be inlined
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

mempool-clarify-behavior-of-mempool_alloc_preallocated.patch

