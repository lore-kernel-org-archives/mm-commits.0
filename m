Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEA93B6C13
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439052; cv=none; b=NAj40/JZxNFtBqidFUDREV5e02DviS0urHr+YjhsjzGIXT+OrUl/40qd/sArt1U80W5PQQu26LJucCaLQ0bl98cgGGesGtiSNm+BaiS2Ofz4Z0mNic4cGupUsR5vGogOyuG1zZEfMxKRG0irs8oFrCEAPbVChFUlpYXoNByYytA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439052; c=relaxed/simple;
	bh=e0r1gKPgWU+i0QeHfRxYdvVyPteyXIwh6nIGPdFpya4=;
	h=Date:To:From:Subject:Message-Id; b=GHFmXBk42gTNpYWMVPpKYgD20x6TGFiFjNjfFVKVZNEBFFAlCEOiIdPrHgP22sk1iUjZMxfCDqI4ltxc1aa4C7j1VbZeWbW9p01G1WpSwtkPO8cDsw4lZefCKFS/mowKOeKJhVHSDDGkBWPv18q9cdZ5EGHeiK9pc819mEmLagg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uVnSPp7J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uVnSPp7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EEE1F00893;
	Tue,  2 Jun 2026 22:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439051;
	bh=eZP+7mzFv+N54qBawTkigQV2TVN6mXYObRd9TyqR4Ig=;
	h=Date:To:From:Subject;
	b=uVnSPp7JJn6CqDdgEf58yWctSFJlIBkMtdjzIME53jBRETuF2wAFJwi7939qQp/Sr
	 x78IG4vM42g3UhEeAu+fdHGqXuH7KOKAprOcKC5uCxXg1j6PYela8i3nqPgJ1PCO8/
	 MwNVDXOCPlSiJ9S+/Jx/KAPdyya9g8VRlPMnTIWw=
Date: Tue, 02 Jun 2026 15:24:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,david@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch removed from -mm tree
Message-Id: <20260602222411.21EEE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page-types: fix ternary operator precedence in sigbus handler
has been removed from the -mm tree.  Its filename was
     tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page-types: fix ternary operator precedence in sigbus handler
Date: Wed, 13 May 2026 10:21:17 +0800

The ternary operator (?:) has lower precedence than addition (+), so the
expression `off + sigbus_addr ?  sigbus_addr - ptr : 0` was parsed as
`(off + sigbus_addr) ?  (sigbus_addr - ptr) : 0` rather than the intended
`off + (sigbus_addr ?  sigbus_addr - ptr : 0)`.  Add explicit parentheses
to ensure the correct evaluation order.

Link: https://lore.kernel.org/20260513022120.58033-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page-types.c~tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler
+++ a/tools/mm/page-types.c
@@ -1000,7 +1000,7 @@ static void walk_file_range(const char *
 			fatal("madvise failed: %s", name);
 
 		if (sigsetjmp(sigbus_jmp, 1)) {
-			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
+			end = off + (sigbus_addr ? sigbus_addr - ptr : 0);
 			fprintf(stderr, "got sigbus at offset %lld: %s\n",
 					(long long)end, name);
 			goto got_sigbus;
_

Patches currently in -mm which might be from liuye@kylinos.cn are


