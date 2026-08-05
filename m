Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B9119D07A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785892329; cv=none; b=Rww17L9SkiOFJcKOaJIAN2WXikceFD2d44fJVn3UXXPNPbA1HjZjAYtNTEItiZ0GrWulQaqboFzShsLTfn34IfvGCwp0fyB2S/0REMvF5chgHoXjMWK5idwi/Z07gFmr2Ypd26Wv24cf16aHyTkwkb1GLhZ65At90OT4bRMLddM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785892329; c=relaxed/simple;
	bh=HxPRBjCwF5xGmdffBZbY/NEvzC0A8ji+wzkcxMnr/58=;
	h=Date:To:From:Subject:Message-Id; b=L1bEbJwNPFzlCZuOZgrDrL1OObojwSRIBtdp1eSTYjIOE/yvW+axhvJeqrktcVHUExX4jxjqsxY3/HTpD3XimXzNUowc4JVXz+WiFfMAf5rdiYwAPBybdO3iwpGTirFSRgSUyGWW9AEsWkyZEv6DSsOA6sWIJIqtqxZz0xHvXlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wd7oSTcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wd7oSTcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF531F000E9;
	Wed,  5 Aug 2026 01:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785892328;
	bh=t+V0hcRynoFIrivU+Ar8K7w7U1mb/ttLZWO5WZ37oiU=;
	h=Date:To:From:Subject;
	b=wd7oSTcZvlNThQtdS9308GoHBVLpOSP6rCdqiDeR9dltZt2daA3gfbIdOWhyO98Li
	 kLqukhtabZtiAZJjboC1Fq/Q7CJbXf8IuRawJopnHLZ9LXPMnajx+wjP/EgKLFmwcw
	 D0r173DYf3qc/7Iatb8ksRBm3nwm4KnsO/rv1lms=
Date: Tue, 04 Aug 2026 18:12:07 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rename-swapc-to-folioc-fix.patch removed from -mm tree
Message-Id: <20260805011208.4DF531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-rename-swapc-to-folioc-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-swapc-to-folioc-fix.patch

This patch was dropped because it was folded into mm-rename-swapc-to-folioc.patch

------------------------------------------------------
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: mm-rename-swapc-to-folioc-fix
Date: Tue, 4 Aug 2026 19:11:09 +0800

move mm/folio.c to MM CORE

mm/folio.c holds generic folio LRU helpers, not MGLRU-specific
code. Move it to MEMORY MANAGEMENT - CORE, next to
folio-compat.c and folio_batch.h, so get_maintainer.pl routes
reviews to the right people.

Link: https://lore.kernel.org/20260804111109.393127-1-wujianyue000@gmail.com
Fixes: 8ed6d702d442 ("mm: rename swap.c to folio.c")
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~mm-rename-swapc-to-folioc-fix
+++ a/MAINTAINERS
@@ -16988,6 +16988,7 @@ F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
 F:	mm/folio-compat.c
+F:	mm/folio.c
 F:	mm/highmem.c
 F:	mm/init-mm.c
 F:	mm/internal.h
@@ -17088,7 +17089,6 @@ F:	Documentation/admin-guide/mm/multigen
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
-F:	mm/folio.c
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
_

Patches currently in -mm which might be from wujianyue000@gmail.com are

mm-swap-colocate-page-cluster-sysctl-with-swap-readahead.patch
mm-rename-swapc-to-folioc.patch
mm-move-reclaim-internal-declarations-out-of-swaph.patch

