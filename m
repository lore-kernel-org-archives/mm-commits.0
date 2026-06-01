Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C032594B9;
	Mon,  1 Jun 2026 20:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780344585; cv=none; b=qxhhCGsZ5Pw7PE7+RVBg+DD8bihfyP3NZCckUL9FKm1jU+5SCbDpo1ek0Ke+UG/WQXCgiUlZ/+c3eFDGdiBusl13yOSEV3kcdmVya++HrIVcgLWMln2A2dFIHoHeOjJ17Hvs6y42Z6YSgPUeeUWbt46AY++zBr9bM/8a0eiD7Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780344585; c=relaxed/simple;
	bh=cxEjWbnC92cSU1KoyID8L3aOf/9G23AtI3T+WEeuGPk=;
	h=Date:To:From:Subject:Message-Id; b=UdykABbee2CsgawSRQiFiDXlTUXNx0l6K8DEKqWdhe2UOyg+DpZoRwohuKI9upsJZm40jMmgyjHPz/miOoiqUi4e75imPBz3Q6PHnd/raEj4BUOLGK2APQlIkkBNBLU1aQS54qlf4PIsZDxOyW73s0BhDpXWRR5XSrFVxCpdcuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GGYsIrNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GGYsIrNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691CF1F00893;
	Mon,  1 Jun 2026 20:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780344583;
	bh=KvLOCEW8jkHCwNgMzFOGEaiNG/pU3Kk0wDhsTLyXRlg=;
	h=Date:To:From:Subject;
	b=GGYsIrNEX+t2HqMFEA3D1xOvmDOHkgQT23bVrfobsk8g32kTgnjAoOT+pxAJMQqpf
	 Oo086AfyULy9C4uqGSUVZYrPdYCMBpsR5SSz9GGzK74nZvFEiK5bCgQrDzmqGKCcl4
	 AkETJAYDmm7xGOPtKxt+9fDnUj41O6K0mBrMPfQw=
Date: Mon, 01 Jun 2026 13:09:43 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,stable@vger.kernel.org,mingo@redhat.com,kdesler@soohrt.org,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + archx86-skip-setting-align_offset-for-hugetlb-mappings.patch added to mm-hotfixes-unstable branch
Message-Id: <20260601200943.691CF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch,x86: skip setting align_offset for hugetlb mappings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     archx86-skip-setting-align_offset-for-hugetlb-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/archx86-skip-setting-align_offset-for-hugetlb-mappings.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: arch,x86: skip setting align_offset for hugetlb mappings
Date: Mon, 1 Jun 2026 14:50:15 +0200

On x86, arch_get_unmapped_area{_topdown} set align_offset in order to
avoid cache aliasing on I$ on AMD family 15h when 'align_va_addr' is
enabled.

Prior to commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through
mm_get_unmapped_area_vmflags"), we did not have to worry about that
because hugetlb specific code did not set align_offset, but the above
commit got rid of hugetlb specific code and started to route hugetlb
mappings through the generic interface.

Doing that has the effect of handing non-aligned hugetlb mappings to
userspace, which is plain wrong, eventually leading to a BUG in
__unmap_hugepage_range().

So, skip setting align_offset if we are dealing with a hugetlb mapping.

Link: https://lore.kernel.org/20260601125015.216110-1-osalvador@suse.de
Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Karsten Desler <kdesler@soohrt.org>
Closes: https://lore.kernel.org/linux-mm/20260527143643.GO31091@soohrt.org/
Tested-by: Karsten Desler <kdesler@soohrt.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/sys_x86_64.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/sys_x86_64.c~archx86-skip-setting-align_offset-for-hugetlb-mappings
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -157,7 +157,12 @@ arch_get_unmapped_area(struct file *filp
 	}
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		/*
+		 * Hugepages must remain hugepage-aligned, so skip adding an offset
+		 * in case we enabled 'align_va_addr'.
+		 */
+		if (!is_file_hugepages(filp))
+			info.align_offset += get_align_bits();
 	}
 
 	return vm_unmapped_area(&info);
@@ -222,7 +227,12 @@ get_unmapped_area:
 
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		/*
+		 * Hugepages must remain hugepage-aligned, so skip adding an offset
+		 * in case we enabled 'align_va_addr'.
+		 */
+		if (!is_file_hugepages(filp))
+			info.align_offset += get_align_bits();
 	}
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))
_

Patches currently in -mm which might be from osalvador@suse.de are

archx86-skip-setting-align_offset-for-hugetlb-mappings.patch

