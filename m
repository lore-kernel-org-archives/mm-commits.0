Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E923E8661
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 11:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776943056; cv=none; b=BLpjyjamw+5gSVMmdXB7T/foNkFfOqyRQiWovilSTT4P6TpOMRvF4c9ahyNZlSEuO0IADrMiFrD1PpN2SrwtRNRPEILmly5SR2X5uGL+UGFJ/83+ob9l0sPFHLy7xEmVEu+DSu1GWfzmSS8AtKgVGIZe0kgRxF1qQ2turkuX+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776943056; c=relaxed/simple;
	bh=jaSxc6wdvqXT7boxjCK30/DiVITj8/GjaCaAOnOaLb0=;
	h=Date:To:From:Subject:Message-Id; b=rAG21mPOcfIWXoONIcwdxBc9NaV5AtsftHHcuFDTlAxEQfiYNIGIIhxxZV3iWhQJGainhdoyxUy/bHPuqf2qxl5flJqHbl9uUrNQ+5ynSuPS/UFIeBfQ2/S3Vo/+bEEoQc3ptjjtJt7GOw6BUyQRDtt8E25jahMvOmfQZ/jOBe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nIDxCn7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nIDxCn7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D074CC2BCAF;
	Thu, 23 Apr 2026 11:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776943055;
	bh=jaSxc6wdvqXT7boxjCK30/DiVITj8/GjaCaAOnOaLb0=;
	h=Date:To:From:Subject:From;
	b=nIDxCn7wVJlsOx3Rcgj3KpMeCa9SpuCBpGLtAynIDCYUuNws1PrDTwF2GP+3WdPLj
	 R0DVfJTXzp9gtty7d/Bi3QYsg1ta4wpJlqZhc1LZ1RCQK5qyrUHkxIdoNQQ9tQSUK4
	 Ti7mDDxKytz0gG+KVtjCRJbacip/uxisq2QFHkfk=
Date: Thu, 23 Apr 2026 04:17:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-fix-regex-pattern-in-core-mm-category.patch added to mm-hotfixes-unstable branch
Message-Id: <20260423111735.D074CC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: fix regex pattern in CORE MM category
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-fix-regex-pattern-in-core-mm-category.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-fix-regex-pattern-in-core-mm-category.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Pedro Falcato <pfalcato@suse.de>
Subject: MAINTAINERS: fix regex pattern in CORE MM category
Date: Wed, 22 Apr 2026 13:37:26 +0100

The pattern "include/linux/page[-_]*" matches every file that starts with
"page", because it's a regex and not a glob (so it has the meaning of
include/linux/page + match [-_] 0+ times).

Fix it up into a more regex-correct expression.  Doing so reduces CC's
drastically in patches that touch pagemap.h (which is maintained as part
of PAGE CACHE).

As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
ALLOCATOR.

Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/
Link: https://lore.kernel.org/20260422123726.517220-1-pfalcato@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-fix-regex-pattern-in-core-mm-category
+++ a/MAINTAINERS
@@ -16803,7 +16803,7 @@ F:	mm/sparse.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
-N:	include/linux/page[-_]*
+N:	include\/linux\/page[-_][a-zA-Z]*
 
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -16960,6 +16960,7 @@ S:	Maintained
 F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
+F:	include/linux/pageblock-flags.h
 F:	mm/compaction.c
 F:	mm/debug_page_alloc.c
 F:	mm/debug_page_ref.c
_

Patches currently in -mm which might be from pfalcato@suse.de are

maintainers-fix-regex-pattern-in-core-mm-category.patch

