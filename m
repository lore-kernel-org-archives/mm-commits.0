Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832352;
	b=hYibOttNx5vUxxgeQKC3lJSD+4TRYK7hnPSoWeHAShr0OagQ8M4q/++8f5nx1XljaqEz
	 ofkMPO/8R2WRsnHyE5x1/DPkaTxubralyeew097ramuzDujSpheoYYxKpFEAc2a6Z3HxC
	 jt1CmOcylsGYibniA857N1jr52a5ZImvI6lD5g7QKunvT36h1awwmc3XYAhsIO9nrHtk9
	 oELdKq6pg9qSbuHbcR60sFP6WtG7AGStuxpUqFE7pEkFq61Zg/I3eDCXIu4NWBCWDEtq9
	 Mj9TJmjwltDQsOQCJynkzhs+JeP/8NzqysEmKcS7SauFR9mWugcqS7PSMuAoYauPp8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832352;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=H6J/v+XmJZQ1TYfoOk1Saj6gtDXB9CjVzv/sFpDopGA=;
	b=2IVaCNwvMizO4iozPrPoLyV0y07G2cVt7Jh4txomdS7uGawG01pkUQRGj6OQXNoRau3z
	 3aCdiNqlgYv3E/vkfhibD54Po2imgbFDN8zCXB/3GXrz0cwFbECe8j3GCc1JtCTZhP+NW
	 JGtj+4v0prWpj4qo+BqC4GSvPwpLkxdX/wSunsF1xwSBB6QQUatsbZY5om1mCbCuUfWyr
	 cHb2zOJjJKXDiKyCsKe+NCYb/39o/z7Jpwv1DOykJ3ywsqKl3VJy9EF7vtzYlroaBvbFR
	 HbO+QSWbtGrVBj1inNmgNc9qwzIddxFX6t+gfOUoXwnLl5q4QKl5gCP8KYR1Ww8tLIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0mnajcWN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EBF606A31E
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0mnajcWN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DF21F01828;
	Sat, 24 Oct 2026 08:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832352;
	bh=H6J/v+XmJZQ1TYfoOk1Saj6gtDXB9CjVzv/sFpDopGA=;
	h=Date:To:From:Subject;
	b=0mnajcWN86iqmRXeh5t/PTAVOZxq5y5W1TwxB/5Abej7i21rn/tAZbxwUYBt1P7w9
	 PupDvvUcg2Yu36W0fl/ndZ5crmVByg/XU0ytoQb33wSb3YVZzWcTozMJfeEnEIwMpW
	 MeXCoIjREJ54D+e3PGmLme0R5zh7K2zpXowYR/ww=
Date: Sat, 24 Oct 2026 01:59:11 -0700
To: mm-commits@vger.kernel.org,tiwai@suse.de,perex@perex.cz,hnkz.64@gmail.com,devnexen@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alsa-us122l-mark-hwdep-mappings-vm_mixedmap.patch removed from -mm tree
Message-Id: <20261024085912.52DF21F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
has been removed from the -mm tree.  Its filename was
     alsa-us122l-mark-hwdep-mappings-vm_mixedmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
Date: Fri, 23 Oct 2026 11:21:31 +0100

mm has recently moved to a strict model which requires any driver which
clears VMA_MAYWRITE_BIT to be mapping non-mm-managed memory
(VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT), failing any such mmap() with an
error and a kernel warning - see "mm/vma: only allow mmap to clear
VMA_MAYWRITE_BIT if not mm-managed".

However, simultaneous to this, commit 71c610aeb177 ("ALSA: us122l: Prevent
write upgrades for read mappings") updated us122l to clear
VMA_MAYWRITE_BIT without marking the region with either VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT.

vm_insert_pages() and friends set this automatically, however this driver
maps its pre-allocated pages from a fault handler, so never calls these.

Simply set the flag in usb_stream_hwdep_mmap() to resolve the issue.  This
correctly marks the mapping as one whose pages core mm does not manage,
which has no meaningful impact for this driver beyond preventing the
mmap() from failing.

Link: https://lore.kernel.org/20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org
Fixes: 71c610aeb177 ("ALSA: us122l: Prevent write upgrades for read mappings")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: David Carlier <devnexen@gmail.com>
Closes: https://lore.kernel.org/20261018025905.201296-1-devnexen@gmail.com
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Kazuki Hanai <hnkz.64@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
---

 sound/usb/usx2y/us122l.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/usx2y/us122l.c~alsa-us122l-mark-hwdep-mappings-vm_mixedmap
+++ a/sound/usb/usx2y/us122l.c
@@ -193,7 +193,7 @@ static int usb_stream_hwdep_mmap(struct
 	}
 
 	area->vm_ops = &usb_stream_hwdep_vm_ops;
-	vm_flags_set(area, VM_DONTDUMP);
+	vm_flags_set(area, VM_MIXEDMAP | VM_DONTDUMP);
 	if (!read)
 		vm_flags_set(area, VM_DONTEXPAND);
 	area->vm_private_data = us122l;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

