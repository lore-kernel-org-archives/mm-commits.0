Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46BD33FE0D
	for <mm-commits@vger.kernel.org>; Fri,  5 Dec 2025 18:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764959166; cv=none; b=rxrmgld2lWKBYc5Q1SBCYgs9PNiHY22UG+/R2YW+TL55Xc0h8pCIdB1tJfBac3mI95WadsMzkY9uuwQiO7rwYK0x6AfG2vdrJ4zaEU11GerqfC/41UcFtxwBnMVkaQ8me36Yznm+VazMJ33ti1b7Q88FQxm+4Ig6VN0rxHPDfhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764959166; c=relaxed/simple;
	bh=dzsU8vK2v3DFP3MQqMHnv7GaEpxYUtx6pQBs6W7DZR4=;
	h=Date:To:From:Subject:Message-Id; b=leEmc3BADuLeoFXeCf1WcTVYiiJGmkNT5R4XkaXdfNHJgiWWpCAOg+cyqfM4o1/nr1xWVLTT1ZTzo9VBSgtWniu1UVCTmTxAfh1OPoY2HatuTR3yeXs3KFIZ1fUhSTSm8e+UUV8lSZx+kDio2qrmKTSLjU6CQmPIKuGBHSLsFwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F7ALEK6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F7ALEK6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC50C4CEF1;
	Fri,  5 Dec 2025 18:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764959166;
	bh=dzsU8vK2v3DFP3MQqMHnv7GaEpxYUtx6pQBs6W7DZR4=;
	h=Date:To:From:Subject:From;
	b=F7ALEK6usUx91t3niHU1i/dF/IeSGo6j92lYdEXr6R9wc3v1SrJEwMDmynvr3ZTlG
	 F7C2JcLzR+L1JHcCCFdo3UDUebWEldfPmEIul9jdl2iEzlyOveHg/KAB4FLvZ/Accm
	 UyRbeD1n/F3Mt3A5Z4veXkLFLnk/efyGryFu5os8=
Date: Fri, 05 Dec 2025 10:25:50 -0800
To: mm-commits@vger.kernel.org,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-unpoison-vms-addresses-with-a-common-tag-v4.patch added to mm-hotfixes-unstable branch
Message-Id: <20251205182606.3DC50C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-unpoison-vms-addresses-with-a-common-tag-v4
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-unpoison-vms-addresses-with-a-common-tag-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-unpoison-vms-addresses-with-a-common-tag-v4.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: kasan-unpoison-vms-addresses-with-a-common-tag-v4
Date: Fri, 05 Dec 2025 14:59:26 +0000

remove unneeded pr_warn()

Link: https://lkml.kernel.org/r/919897daaaa3c982a27762a2ee038769ad033991.1764945396.git.m.wieczorretman@pm.me
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag-v4
+++ a/mm/kasan/common.c
@@ -598,10 +598,8 @@ void __kasan_unpoison_vmap_areas(struct
 	 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
 	 * KASAN checks down the line.
 	 */
-	if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG)) {
-		pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be already set!\n");
+	if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG))
 		return;
-	}
 
 	size = vms[0]->size;
 	addr = vms[0]->addr;
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are

kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch
kasan-unpoison-vms-addresses-with-a-common-tag.patch
kasan-unpoison-vms-addresses-with-a-common-tag-v4.patch

