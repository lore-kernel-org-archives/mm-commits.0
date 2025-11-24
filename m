Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53C623D7E3
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024673; cv=none; b=OkKJsLlCoTFdkfCZDvJFX6ZI6Bekf6Em3vrzJQq4vbnA9k2hbT7SVkTqx4IsDmFdb3PmBGv0JWTKWyOvmswKptzWbhTPnydwNcTyg2MR6scakva4iGMZAZqPhYCfOL0RAzRpmwgPC8FQOBDmv9TVUzddibYafndgGq+V8km1a+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024673; c=relaxed/simple;
	bh=bKautC7J/3unFoEGeoTEUMitce2oCE50vsY2PVtfksw=;
	h=Date:To:From:Subject:Message-Id; b=f2J+l8SairLHQjWSKUpgnvk+vYPH3tC5bL005xjMOG64gRR25BiVV4ZtiF9u7KN0/owBKEGdPGl+D14oWAGN07RrznXaygyWU9BzoYujnTOfxtoyN1LJpQOF/HU2e/njVANNXAPvtORiJTjgTz/+C7XpeSQ/4bSEjHO5ytiCseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BvwxOr/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BvwxOr/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46147C4CEF1;
	Mon, 24 Nov 2025 22:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764024671;
	bh=bKautC7J/3unFoEGeoTEUMitce2oCE50vsY2PVtfksw=;
	h=Date:To:From:Subject:From;
	b=BvwxOr/I8hdoay+DxnTGD1Nc/acogEVukuL+dlXv9kkBvf7qQ9x8zZlWEH3relM82
	 YbEEhhCVs/sGOAO+hsEY8T+KTtbpqTFWnWrFxglqk449mvOOipILEq1Rl2YBQXGU9m
	 u+bHLocJpoxbRV0h68oqrfxv9sulP9YugK5hzqNw=
Date: Mon, 24 Nov 2025 14:51:10 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-correctly-handle-uffd-pte-markers-fix.patch removed from -mm tree
Message-Id: <20251124225111.46147C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-correctly-handle-uffd-pte-markers-fix
has been removed from the -mm tree.  Its filename was
     mm-correctly-handle-uffd-pte-markers-fix.patch

This patch was dropped because it was folded into mm-correctly-handle-uffd-pte-markers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-correctly-handle-uffd-pte-markers-fix
Date: Thu Nov 20 01:21:44 PM PST 2025

fix comment typo, per Mike

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/userfaultfd.c~mm-correctly-handle-uffd-pte-markers-fix
+++ a/fs/userfaultfd.c
@@ -312,7 +312,7 @@ again:
 		return true;
 
 	/*
-	 * A race could arise which would result in a softleaf entry such a
+	 * A race could arise which would result in a softleaf entry such as
 	 * migration entry unexpectedly being present in the PMD, so explicitly
 	 * check for this and bail out if so.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-correctly-handle-uffd-pte-markers.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

