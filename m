Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F6D25C711
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 02:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760494215; cv=none; b=VLMukFVu0xfsyMbfAF5GCVV3WqadtHrYt3m6U4j6Z2LgEfhUEJ3cyaK1iZNSjPGnSa2HOeaYM5Dmxd3+kHqMY/4QM8T5RkeUoxhDtV2ZFXOo19nHm+SY0SAcZennSocyBrpZhElamY4UejmUSH9SLJJFVRxl3ZlCP0QzzLCbaME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760494215; c=relaxed/simple;
	bh=eYYKvQioB82nkP04zrBpBHm6tu3bvRbuZXdmXHDTeQk=;
	h=Date:To:From:Subject:Message-Id; b=QbtvR9dKZvNQnfzeYI02bG6cd5n6ewHoZsTqSX8pfeIFFxs8sEFyTuhEHUdbIvQoE3dPaGhicM0f4OCefFI5G9i9GCYkPitGE4BksBtt7t7To0HHOE5q2S8/l9XugvvcxcMAdPLULP0LzYgA5ovUxxyi4c8N6+V19ZJSB229YmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LLZawChI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LLZawChI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E755BC4CEE7;
	Wed, 15 Oct 2025 02:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760494215;
	bh=eYYKvQioB82nkP04zrBpBHm6tu3bvRbuZXdmXHDTeQk=;
	h=Date:To:From:Subject:From;
	b=LLZawChIW1XqDbMtG5AJoYCyyMBuz0iXuLjSZrqsKFjJ/iM7v4Lx97uNjV/GuL9Xl
	 cH4ZqfoYCcEViCYgULOC2jZldr2aI+UT177h/gXE7LrfzynVxr7u2E0T4kHEP3hdmp
	 A34ukHY5JWVYzWVkaVT8igjkXvl/t4NA3gxIIgwY=
Date: Tue, 14 Oct 2025 19:10:14 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,urezki@gmail.com,lkp@intel.com,dev.jain@arm.com,dan.carpenter@linaro.org,yadong.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned-fix.patch added to mm-new branch
Message-Id: <20251015021014.E755BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: fix uninitialized value issue
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Yadong Qi <yadong.qi@linux.alibaba.com>
Subject: mm: vmalloc: fix uninitialized value issue
Date: Tue, 14 Oct 2025 18:23:37 +0800

Issues reported by LKP:
  mm/vmalloc.c:191 vmap_pmd_range() error: uninitialized symbol 'err'.
  mm/vmalloc.c:243 vmap_pud_range() error: uninitialized symbol 'err'.
  mm/vmalloc.c:295 vmap_p4d_range() error: uninitialized symbol 'err'.

Fix by initailizing err with 0.

Link: https://lkml.kernel.org/r/20251014102337.5453-1-yadong.qi@linux.alibaba.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202510110050.VG9YKMRK-lkp@intel.com/
Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned-fix
+++ a/mm/vmalloc.c
@@ -170,7 +170,7 @@ static int vmap_pmd_range(pud_t *pud, un
 {
 	pmd_t *pmd;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
@@ -222,7 +222,7 @@ static int vmap_pud_range(p4d_t *p4d, un
 {
 	pud_t *pud;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
@@ -274,7 +274,7 @@ static int vmap_p4d_range(pgd_t *pgd, un
 {
 	p4d_t *p4d;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
_

Patches currently in -mm which might be from yadong.qi@linux.alibaba.com are

mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch
mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned-fix.patch

