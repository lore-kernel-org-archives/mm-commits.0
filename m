Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40381369208;
	Fri,  3 Apr 2026 06:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198547; cv=none; b=TC8/62KI9t3eG+Zs7h9E1FrwuaJMdbex0+Mj4DuIxxazgIfGS7NF8Gm50qnCM42Q6wGop0xz131VXLnE/PFxQQgycd/XS/Cdjbb7EIr2tYy2B2zicR+2vZoaiMtd3MhGKJPat3GaFs+di3uRUeYhemmnn2PVDS4xu0K9jEtFiwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198547; c=relaxed/simple;
	bh=Equ1gp+Yk/e1i/YwFCxtqXvnKXIQ1ZQV2xf8usVI3A8=;
	h=Date:To:From:Subject:Message-Id; b=qutyZcSq/OiIHGcgb2KZTHWWHSnmzL0JpYVk5FbVIlJL252esW7EvAd+JEhTBYHuQa13ceZ7dUuWyYtVpZ9rX1NfmsJs5O02MsUuPWypyC7EJE8WKe0bCvUbxTcq41RixMozmB97pY6MExZqNgXX0uDHs+xbKu8/5FcOuREx/GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wnt34ypD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wnt34ypD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185B6C4CEF7;
	Fri,  3 Apr 2026 06:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198547;
	bh=Equ1gp+Yk/e1i/YwFCxtqXvnKXIQ1ZQV2xf8usVI3A8=;
	h=Date:To:From:Subject:From;
	b=wnt34ypDzM01Kn8vw7xg/q12kSLVDU8QrhAIFyU/CRlZxvy9sG9XmPwoQnfXLwGbb
	 1ll6lmRQDPiDblsbzcSL+7dB/JozXuKVVpMZwppmjgn73O193pyEuF7IFqezEOFc0m
	 ZoPkb0+g/Xzbv80tfGsn3kAm4aV95cqSLHY+r1OI=
Date: Thu, 02 Apr 2026 23:42:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch removed from -mm tree
Message-Id: <20260403064227.185B6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/scatterlist: fix temp buffer in extract_user_to_sg()
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib/scatterlist: fix temp buffer in extract_user_to_sg()
Date: Thu, 26 Mar 2026 22:49:02 +0100

Instead of allocating a temporary buffer for extracted user pages
extract_user_to_sg() uses the end of the to be filled scatterlist as a
temporary buffer.

Fix the calculation of the start address if the scatterlist already
contains elements.  The unused space starts at sgtable->sgl +
sgtable->nents not directly at sgtable->nents and the temporary buffer is
placed at the end of this unused space.

A subsequent commit will add kunit test cases that demonstrate that the
patch is necessary.

Pointed out by sashiko.dev on a previous iteration of this series.

Link: https://lkml.kernel.org/r/20260326214905.818170-3-lk@c--e.de
Fixes: 018584697533 ("netfs: Add a function to extract an iterator into a scatterlist")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Howells <dhowells@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>	[v6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/scatterlist.c~lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg
+++ a/lib/scatterlist.c
@@ -1123,8 +1123,7 @@ static ssize_t extract_user_to_sg(struct
 	size_t len, off;
 
 	/* We decant the page list into the tail of the scatterlist */
-	pages = (void *)sgtable->sgl +
-		array_size(sg_max, sizeof(struct scatterlist));
+	pages = (void *)sg + array_size(sg_max, sizeof(struct scatterlist));
 	pages -= sg_max;
 
 	do {
_

Patches currently in -mm which might be from lk@c--e.de are


