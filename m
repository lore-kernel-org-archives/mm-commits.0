Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5E9481A9A
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863214; cv=none; b=RDeClAZgXpmlB2FQjp0b5Qy1JVu6R9GEZrIS2zM+aufG5oj5Ld59t5IvvzftRITCIVdn/I6PFq+boR+dsk12hfdRqQs+JZG7zvVmPghnSXkfEBGbJ/1juJV6MRIDtSKFmKTeIHhst86P8polzYbXnVsEJPT3oVBBEaYVEeAxp90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863214; c=relaxed/simple;
	bh=2/sbI8aXggaN6nlJtRy1rCsxgUE2mlgLt0XcLNQBr5s=;
	h=Date:To:From:Subject:Message-Id; b=UlngxxIw25JbTou4hNSBkDsFY5taVMc8TXEK7VmWw5VRlXzRefpiBsZcrsxAJHcj5GKNcWMk6QCpyEdxOt40h1gDFpwnRAM7E4X9RmtgqVIwu2XHdhEw2AQ1dIfb2kkqk2H/fkWntbmn9BhaBVnH1PCCryaogN9x2T1omwPYuQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cef6ho9D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cef6ho9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE88F1F000E9;
	Tue,  4 Aug 2026 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785863204;
	bh=s1xzc1xW+SM0eBcF5jGMxGyQwzn+yb/wez8e91DrkXQ=;
	h=Date:To:From:Subject;
	b=Cef6ho9DU5loUAo8XghH4Zpbw/Mt1rI73YSQPOebU4fAi0HzwLnWrXWrdLZE+yNPm
	 SYJNkz2GXC6xQrTi7CbcFJIrcmZRCdemUCPFss4mg7ePAEyNOXHS79hp8jHEhux9mG
	 gdFtCXwgIN/HelAQzN9Vzt+7PHDp5mcmWLIPp2tw=
Date: Tue, 04 Aug 2026 10:06:43 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-swapc-to-folioc-fix.patch added to mm-unstable branch
Message-Id: <20260804170643.DE88F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rename-swapc-to-folioc-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-swapc-to-folioc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-swapc-to-folioc-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
mm-rename-swapc-to-folioc-fix.patch
mm-move-reclaim-internal-declarations-out-of-swaph.patch

