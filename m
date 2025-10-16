Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7462367D9
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 05:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760593122; cv=none; b=VweGiPeqZzrkn+NLb1G1SDyTK61JOvc+ux0clw6JKrowS0fbNh5aJUjyGpsIBs1OQVbu6fWmQ2yLAQ1BHZNKKHPjezoCDqC4xO0CpqSkN55Xk2bo1GrZAWPR1/PdpaLln3dqb0ntgIUvr4IyhBTRympjX5cLRmp8WgVyK9E0F1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760593122; c=relaxed/simple;
	bh=6IqeVVG/ZQTHdzcW4GuPlewYHBOvZ41HvVFinmOwqaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hguQvfsyM2pshzjc8/2dTi1I793AhIuVRu9kSXVptkgDtSm5xYOrGS3B6rcDa+GDVsOMIu7oWWiRGBS6OGQezPrbXbQIBb9lhYCfed+ZJEoKYGF0S9nHYbpHB/P0UdzhMpaqUAbkitHd1JTBP6keYbOa/fg9AG/2q7GY3O3b6XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YV6nA0Ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YV6nA0Ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFD1C4CEF1;
	Thu, 16 Oct 2025 05:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760593121;
	bh=6IqeVVG/ZQTHdzcW4GuPlewYHBOvZ41HvVFinmOwqaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YV6nA0EfGex9VexWhyBIKnwuebwSnpnNcDMPIBOGpxXmnkRTRZn0Zy33z0vxw6o+J
	 sNCwiGq3+btcHfxhl7stUweVk30oHiG4rQ7S2g+cAnMHOgOPfbS4OqbhhEsGxdo0sQ
	 3G3Ib/G/eWg4nKajJw67gN9vgsSd5gVXPPH0p4Wbby1Dti79OL6hX2ABz2HAXGfcRP
	 hfG9chGFbgi3vun4QnTq5PxdoOsXH94Opy5Uo2QIGMFmxkLL4OB766XkgUVFRODrin
	 8lNmR1+ZbdmcS+gbg+8N7cfhLMhMD30tWpmKvGvOIPKH0EgE6T+KDK4uCSNQQlyKog
	 2zYndiHlyM2PA==
Date: Thu, 16 Oct 2025 08:38:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, mm-commits@vger.kernel.org,
	guoren@kernel.org,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: Re: + csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aPCE238oxAB9QcZa@kernel.org>
References: <20251015215059.D610BC4CEFB@smtp.kernel.org>
 <aPAZAVMunRWb-QHk@casper.infradead.org>
 <20251015151016.bf3f31797dea74558dc00c67@linux-foundation.org>
 <aPAgR6FNizJTKGJu@casper.infradead.org>
 <20251015153646.d7730fe119c0895dfcd06e21@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251015153646.d7730fe119c0895dfcd06e21@linux-foundation.org>

On Wed, Oct 15, 2025 at 03:36:46PM -0700, Andrew Morton wrote:
> On Wed, 15 Oct 2025 23:29:27 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > > > Again, it seems churlish to merge Mike's patch insteaad of Thomas' that
> > > > was sent two weeks ago.
> > > 
> > > I can't find such a patch from Thomas and the message-id you sent
> > > didn't work for me  - what was the Subject:?
> > 
> > Date: Mon, 06 Oct 2025 14:13:37 +0200
> > From: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> > To: Guo Ren <guoren@kernel.org>, "Matthew Wilcox (Oracle)"
> >         <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Andrew Morton
> >         <akpm@linux-foundation.org>
> > Cc: linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Weiﬂschuh
> >         <thomas.weissschuh@linutronix.de>
> > Subject: [PATCH] csky: abiv2: Adapt to new folio flags field
> 
> Ah, thanks, I expect "^csky: abiv2" was as far as my filter got ;)
> 
> I'll adopt Thomas's version.

Here's Thomas's version with additional fix in
arch/csky/abiv2/cacheflush.c:

From 022c7e7c4a9ff413f283ffc442c14a96f8f91b81 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Date: Mon, 6 Oct 2025 14:13:37 +0200
Subject: [PATCH] csky: abiv2: Adapt to new folio flags field
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Recent changes require the raw folio flags to be accessed via ".f".
The merge commit introducing this change adapted most architecture code
but forgot the csky abiv2.

Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
Acked-by: Guo Ren <guoren@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
[rppt: added fix for arch/csky/abiv2/cacheflush.c]
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/csky/abiv2/cacheflush.c         | 2 +-
 arch/csky/abiv2/inc/abi/cacheflush.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/csky/abiv2/cacheflush.c b/arch/csky/abiv2/cacheflush.c
index 876028b1083f..064b0f0f95ca 100644
--- a/arch/csky/abiv2/cacheflush.c
+++ b/arch/csky/abiv2/cacheflush.c
@@ -21,7 +21,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 
 	folio = page_folio(pfn_to_page(pfn));
 
-	if (test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		return;
 
 	icache_inv_range(address, address + nr*PAGE_SIZE);
diff --git a/arch/csky/abiv2/inc/abi/cacheflush.h b/arch/csky/abiv2/inc/abi/cacheflush.h
index 6513ac5d2578..da51a0f02391 100644
--- a/arch/csky/abiv2/inc/abi/cacheflush.h
+++ b/arch/csky/abiv2/inc/abi/cacheflush.h
@@ -20,8 +20,8 @@
 
 static inline void flush_dcache_folio(struct folio *folio)
 {
-	if (test_bit(PG_dcache_clean, &folio->flags))
-		clear_bit(PG_dcache_clean, &folio->flags);
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define flush_dcache_folio flush_dcache_folio
 
-- 
2.50.1


-- 
Sincerely yours,
Mike.
