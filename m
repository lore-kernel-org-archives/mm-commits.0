Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD07842069
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738969622; cv=none; b=efHLO3WmqB2ll4qQeJaHF6Yyu2rZIsDnhVM2w+egd70mAIpauw04OUhYPR/qtKTsfFdGI3tpVBC4hx67zt7vri4821JDYzg8HsrNWMsMHyv3melV1TaNUYJqN3pmHd0MsLpbljYAmnUdsLyol9MTwF8/KsUrOyUzpIu93iPUPHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738969622; c=relaxed/simple;
	bh=Z0X4EvXWU8ynNJNOyLB7G1v7Q43SSzfmceabThHPz+8=;
	h=Date:To:From:Subject:Message-Id; b=aMxvkaiqwaMRSeXi2uV5KAW/IvdxIimVZjUpYuqfRLCfMkX76Yj8xGehDKkWUk0j8iVOmDS59u/bZjMo7pvsHdgm59EtnZwUronqLuM4AhNibWXLX58q9BkMlPgaopVReyi1W4VsABeUyZUEbEpGD8cn3kxtMd5dnvUOMpW4qqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CAQEmm+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CAQEmm+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB49C4CEE4;
	Fri,  7 Feb 2025 23:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738969622;
	bh=Z0X4EvXWU8ynNJNOyLB7G1v7Q43SSzfmceabThHPz+8=;
	h=Date:To:From:Subject:From;
	b=CAQEmm+Ywo1Be/fq00qxV9nHUq9HQNPNElAul5QhM42NCuFhjXZe60JrnkjHU1K/K
	 QzgrzJqLD6b3RGDTApPZTAS2aqKcYa7VoguWVjnzAAFUDpBRvQA9bI5i1LspDkRF6O
	 lmPbxm9I0/Ca5C5zb4+i2GxmzgdHp2R4BmiizSq0=
Date: Fri, 07 Feb 2025 15:07:01 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kho-parsing-support-fix.patch added to mm-unstable branch
Message-Id: <20250207230702.1FB49C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: make kho_init_reserved_pages __init
has been added to the -mm mm-unstable branch.  Its filename is
     kexec-add-kho-parsing-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kho-parsing-support-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: make kho_init_reserved_pages __init
Date: Fri, 7 Feb 2025 09:57:09 +0200

Link: https://lkml.kernel.org/r/Z6W90hz6WaXfZCjQ@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_handover.c~kexec-add-kho-parsing-support-fix
+++ a/kernel/kexec_handover.c
@@ -580,7 +580,7 @@ err_disable_kho:
  * Scan the DT for any memory ranges and make sure they are reserved in
  * memblock, otherwise they will end up in a weird state on free lists.
  */
-static void kho_init_reserved_pages(void)
+static void __init kho_init_reserved_pages(void)
 {
 	const void *fdt = kho_get_fdt();
 	int offset = 0, depth = 0, initial_depth = 0, len;
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch
memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
kexec-add-kexec-handover-kho-generation-helpers-fix.patch
kexec-add-kho-parsing-support-fix.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch

