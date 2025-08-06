Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577DF19DF6A
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754523782; cv=none; b=o0I7nJzzMcOKjK0a23N+G4Mb27rpKSWBo4HlAz/ZD3SbRuAAf3DgyIcXEWQpHglZGEcny9os4i3xR5BCJf47n/g7KkPHC6MXKQ3FRlWMg3UD18IvRCDU/LPcIye/ndAcPCfjtM8N8pdBMiYrmwBdGJD7go7fjIoyu5QSR0Ddld4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754523782; c=relaxed/simple;
	bh=D1778/ynly3C/vXBknXuBv4wPlzbLF9gq9E96+bmlkM=;
	h=Date:To:From:Subject:Message-Id; b=trg8uGv5b91HTQrlrGRACb7vOB2m9nJz/0PYeW9RgFXGiWPxUElyRnQCphwchHYYxrWNGbbzVrCyEMj+gqhP1EqMYXlIi4cd+sxJa2RhaXROdKJbR6/IP9OBetGx2tktWpl3clHANnAdSqbn6ZWuztuZXp+5pf421HCEgN780PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lQ/TpDi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lQ/TpDi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6783C4CEE7;
	Wed,  6 Aug 2025 23:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754523781;
	bh=D1778/ynly3C/vXBknXuBv4wPlzbLF9gq9E96+bmlkM=;
	h=Date:To:From:Subject:From;
	b=lQ/TpDi+ZIWM8fMbanr6pGUW2EsyX+4MVzETjcKWROzPwOUeE0xw3e4rcQAk7ZJNM
	 3vokgwKFcd5FaUwvGDmqO3uJ4SsHQrYyRRbFjfMeId65Q8NXUujJBtxHXAUlhNSKr7
	 doIT4lafocAmiD8xt2anZbY1Ii4pD7HVcErzd0d4=
Date: Wed, 06 Aug 2025 16:43:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rongqianfeng@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-remove-redundant-__gfp_nowarn.patch added to mm-new branch
Message-Id: <20250806234301.D6783C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: remove redundant __GFP_NOWARN
has been added to the -mm mm-new branch.  Its filename is
     xarray-remove-redundant-__gfp_nowarn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-remove-redundant-__gfp_nowarn.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: xarray: remove redundant __GFP_NOWARN
Date: Mon, 4 Aug 2025 21:00:17 +0800

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

No functional changes.

Link: https://lkml.kernel.org/r/20250804130018.484321-1-rongqianfeng@vivo.com
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-remove-redundant-__gfp_nowarn
+++ a/lib/xarray.c
@@ -370,7 +370,7 @@ static void *xas_alloc(struct xa_state *
 	if (node) {
 		xas->xa_alloc = NULL;
 	} else {
-		gfp_t gfp = GFP_NOWAIT | __GFP_NOWARN;
+		gfp_t gfp = GFP_NOWAIT;
 
 		if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
 			gfp |= __GFP_ACCOUNT;
_

Patches currently in -mm which might be from rongqianfeng@vivo.com are

xarray-remove-redundant-__gfp_nowarn.patch
ref_tracker-remove-redundant-__gfp_nowarn.patch

