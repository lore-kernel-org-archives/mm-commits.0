Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6AC3101C0
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768244465; cv=none; b=mZjbZRVgzVbTlUL+469AWTpWupV8BiFweaXi99cmdP/RPB5G7BFUvuisTCHjSvMmtxZDNUF6g3HIfqVN+GrwZxFNLwu6Zwa6m68kqXI6tJGX5rePeSi91Ls7Vt24I1UH9bGvgMstOr/5cC/sj0SzrCFkDnjAVjbuP9PSgsuVQo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768244465; c=relaxed/simple;
	bh=pcmljzRCm0djTYg5dkmJMyoTOfYoJXOC/F8jRKhZXNw=;
	h=Date:To:From:Subject:Message-Id; b=XZaQdlxpF8+SseRs+0ToZ7RubuqKPHSvbcnTiNlM+YMAaDF5Eap/cKOsZZKgn68uVjYPSHzPPIyK8CTbo586xelVp1Kd/El1XInwGt3fAZbyNACXEUHHhdUloD4Ae/OV96PcB0B3olAxqnAefQ3ADNSItKag2/+0TImR2ZjEaCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D+9WLKiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D+9WLKiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310A5C116D0;
	Mon, 12 Jan 2026 19:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768244465;
	bh=pcmljzRCm0djTYg5dkmJMyoTOfYoJXOC/F8jRKhZXNw=;
	h=Date:To:From:Subject:From;
	b=D+9WLKiPdfPZaPllQ+imUZ7/xvyJA121HrNtw73Oju+rXCrRH1zT5vD6sl2SI9nt0
	 RtFKuoAvTxL+htqzera4Cs80uczQ2rOWF/kzjzNkE/nxVOuPkE6+kZSeV1cu/9GQhl
	 iFB5sLj8dDHjypQu9DW2xb43qKJrglPTei7WZrKI=
Date: Mon, 12 Jan 2026 11:01:04 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,kasong@tencent.com,kartikey406@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch added to mm-unstable branch
Message-Id: <20260112190105.310A5C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch

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
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
Date: Tue, 13 Jan 2026 02:33:36 +0800

fix cgroup v1 accounting issue

Syzbot, Deepanshu and Johannes helped found there is a problem with
Cgroup V1 accounting here:
https://lore.kernel.org/linux-mm/CAMgjq7CMsAMZZJL1=a=EtfWCOuDFE62RKR_0hUdPC4H+QF5GfQ@mail.gmail.com/

Syzbot have verified this fix:
https://lore.kernel.org/all/69653d31.050a0220.eaf7.00ca.GAE@google.com/

Link: https://lkml.kernel.org/r/CAMgjq7CGUnzOVG7uSaYjzw9wD7w2dSKOHprJfaEp4CcGLgE3iw@mail.gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
+++ a/mm/vmscan.c
@@ -758,8 +758,8 @@ static int __remove_mapping(struct addre
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__swap_cache_del_folio(ci, folio, swap, shadow);
 		memcg1_swapout(folio, swap);
+		__swap_cache_del_folio(ci, folio, swap, shadow);
 		swap_cluster_unlock_irq(ci);
 	} else {
 		void (*free_folio)(struct folio *);
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch

