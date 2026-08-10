Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01967361956
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386297; cv=none; b=IblJIBEUOJko48r1qWuIvO8N9haNCqJ0+tl1Ym3kavTiOTu3wq4R7clt+5Ie8ckPuhX4v5v+ajteOBb8W/1SBwJ1uNIdSz8ENkjpsp9jHvmYTTgD2godpP0O4HTGJVtPAH1ndw/0GpzK5LnoyatQ5WsYHTgYEZzJ+1WRXESK7pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386297; c=relaxed/simple;
	bh=DLwB+IqX+cZjcY2/8p4X536uXAayBE/21IzqmO3em1k=;
	h=Date:To:From:Subject:Message-Id; b=uoPRl8bzzHKNWi8pTkz/WRZmbZz6khn6/rEeue/J8E1C5ozBtiXs+uBxyeyoH9utWGToWvNpSxUi/v4LpFpsMXbNc23vkiy4RIqHOw6QAaDOBjTRAdvNnfaS5RT4e6KzKJ9LIVoIwYj4otpViBrjB0bgy0JiwEHvWPva4wSx6zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=00xBJJ4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="00xBJJ4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6887C1F000E9;
	Mon, 10 Aug 2026 18:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786386295;
	bh=ayOt0/Xe4ihdqGHOGZ6OFRxJJ0oUpz8DnaLBNUtCmL4=;
	h=Date:To:From:Subject;
	b=00xBJJ4B6844fOnUj1/mgZNomdxKZeI8iBnL6tJ/ztpI5qTpIhI6OEO72NfN2/xeA
	 QmG2kPD4S5QCXxMN9YckN2jXY/YsCcTQv0JIm4Ie6jMxoW4jL2g6jCY6YFzcjEhh6A
	 rLHrhZ16K+8Lw2+qkc0cA9/meAgkTsRY7ugRmUXw=
Date: Mon, 10 Aug 2026 11:24:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch added to mm-unstable branch
Message-Id: <20260810182455.6887C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: remove stray newline from auto-generated CMA area name
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/cma: remove stray newline from auto-generated CMA area name
Date: Mon, 10 Aug 2026 17:32:15 +0800

When no name is supplied, cma_new_area() generates names with format
"cma%d\n", introducing an unintended newline character ('\n') in the CMA
name.

Most CMA regions are created with explicit names, so this path is seldom
hit.  The newline only creates cosmetic noise in debug logs, traces and
debugfs with no functional impact.

Link: https://lore.kernel.org/20260810093215.91419-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-remove-stray-newline-from-auto-generated-cma-area-name
+++ a/mm/cma.c
@@ -242,7 +242,7 @@ static int __init cma_new_area(const cha
 	if (name)
 		strscpy(cma->name, name);
 	else
-		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);
 
 	cma->available_count = cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

ksm-update-comments-and-docs-to-reference-folio-mapping.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-mm-fix-read_file-return-value-check.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch
selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

