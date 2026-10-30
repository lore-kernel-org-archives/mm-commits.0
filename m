Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333375;
	b=SSo5IeyyW5HUpc+77BCalos085MpATKdiaDE84Lr4+Z6IjzYbibb+m4rx9vbpKbz/dA5
	 MssmDdukOgp14NlKP0JUFA8xID/S+tEwfVgSABWVdwOUHk9vrXj8MCSkDCum7OeRPUlWo
	 fA3nCOmIlSMpngmdvJ/8fDu+//mLCkR27imHu1xsrWe7qnCjLoEjTMcfR21wfEdVucY7T
	 lHAhWYuYlDVWsC88QO2gdLiagXYLLn/8VBnitTymcJ5ID9JlBh4TMeF1lv31npSV8Egw2
	 NEOKXApANVp6j0xC1AIk1/6Kn86g84Q2E5sm9X9K/5hawRYUvTfuPnusYYUPAVJBruQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333375;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/pbupnqIZz9JFuCLr4mVNEpiZa8t5y0ShmghoruShQk=;
	b=4wDa8MZ9gSL1AbxztPkZhf8rSKZSBai2suuB2IiMxtTj1c553jUeqQXL5TlwaeFIW+ZP
	 MvcuRRsHSIUQwfTVMxwPwVBkyVlPcp3vAVFSWE7DvD1MaqksIl4FfTSf5CHqgRiQWLwME
	 Bja2aW0srexpDtf8GjkL+u5ShXTYBhqwmy3K5a8LS7ouJa4f/vKoXyDXdUFd1RpFPkURF
	 YLIgatbZlwxb4PmqScKp2rDOrGLllRZMpmUWIvMf+GpSdz6kGBqM0nXJ1I0sQnYd2Io/x
	 lgHpNA0AMQQ3Pd3pdOT82geGyoiwjBKNO7L8ss7q+S9xlrUF/kiObozfWUDrkXuNKZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=I+ZIoOwu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A34606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 04:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=I+ZIoOwu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F311F000C1;
	Fri, 30 Oct 2026 04:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793333374;
	bh=/pbupnqIZz9JFuCLr4mVNEpiZa8t5y0ShmghoruShQk=;
	h=Date:To:From:Subject;
	b=I+ZIoOwuwCfEcDEZNRpsCp0M5TSYgdB0yTuZfw7RYJUMhVDebJyfR3eH576Z45Gor
	 mIaS8K3/OfIj6LFPN/sk80tGhoqNUtocSMc+UExDIoseGvWh12czSchHmuMK9+yrgK
	 v7k3/1fqYJ+U9B9SgWDfPsEmRwsPxJTPyGFuAenk=
Date: Thu, 29 Oct 2026 21:09:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,dev.jain@arm.com,
	brendan.jackman@linux.dev,anshuman.khandual@arm.com,zenghui.yu@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-unneeded-forward-declaration-of-__free_pages_ok.patch added to mm-new branch
Message-Id: <20261030040934.93F311F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_alloc: remove unneeded forward declaration of __free_pages_ok()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-remove-unneeded-forward-declaration-of-__free_pages_ok.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-unneeded-forward-declaration-of-__free_pages_ok.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: mm/page_alloc: remove unneeded forward declaration of __free_pages_ok()
Date: Thu, 22 Oct 2026 20:45:04 +0800

All remaining callers of __free_pages_ok() appear after its definition, so
the forward declaration near the top of mm/page_alloc.c is no longer
needed.  Remove it.

Link: https://lore.kernel.org/20261022124504.75642-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unneeded-forward-declaration-of-__free_pages_ok
+++ a/mm/page_alloc.c
@@ -213,8 +213,6 @@ gfp_t gfp_allowed_mask __read_mostly = G
 unsigned int pageblock_order __read_mostly;
 #endif
 
-static void __free_pages_ok(struct page *page, unsigned int order,
-			    fpi_t fpi_flags);
 static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone);
 
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch
selftests-mm-fix-khugepaged_race-build-with-older-glibc.patch
selftests-mm-skip-collapse_compound_extreme-on-thp-allocation-failure.patch
mm-page_alloc-remove-unneeded-forward-declaration-of-__free_pages_ok.patch

