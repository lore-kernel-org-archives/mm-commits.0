Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD1DB672;
	Mon,  6 Jul 2026 00:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783296974; cv=none; b=paI/x6oB15QTXAt2QvrnDvusAPpMhBJf27SgwEWQT0AxKxSj2BUcKalfVzvDJUrR1maCJ8aaE11D3UvVdk6iROCgLe1JV7Z5NrYFCyRpQnHln4nzTMwPacl/zx1Ow7IFvHmdsXGTMjS1XXZenOepWW7kLWlMBbsllmXOHXw6bjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783296974; c=relaxed/simple;
	bh=vqQ2mVHSPsqe7qkFwtrg4bb9or20jVEqW3VBB3OxRdg=;
	h=Date:To:From:Subject:Message-Id; b=X85TuRa2dfcpZxyxeRFxxsxb50wRj0C2DqKcYkI1fGZqQ/dY62rsFv8q/rSKR8uyTSOMd5VTb7XiyQ9ZeHOwmljoJrezCXpGMigme0KgEB065HhjQY4Gl7/U3GRwb8zV0pAwxILS2dGomCwnQ/0JQllznKN/oq1Q+qlnpRlVyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fJrc6xKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fJrc6xKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70B81F000E9;
	Mon,  6 Jul 2026 00:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783296973;
	bh=ZJzs087eHBwFc9QEWX/zlttM8ZxPq5rrurtn2qsfcN0=;
	h=Date:To:From:Subject;
	b=fJrc6xKCCXGEZf8oVU664fbbEoMYZXAaYf5+gWZYyJfggiuUKwkfnaeRrNYmPdZ9z
	 Qt6L0uK5qNuQA3/0z/wmzWyHXdQPVK6Wl1ITX6XXgQiV+S+aTqqRId0F83Q0s7z0xt
	 fqum2+tkw6yBw+HYt7nerElHiOi1nUKBvldRyDLI=
Date: Sun, 05 Jul 2026 17:16:12 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,stable@vger.kernel.org,mingo@redhat.com,kdesler@soohrt.org,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] archx86-skip-setting-align_offset-for-hugetlb-mappings.patch removed from -mm tree
Message-Id: <20260706001612.D70B81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch,x86: skip setting align_offset for hugetlb mappings
has been removed from the -mm tree.  Its filename was
     archx86-skip-setting-align_offset-for-hugetlb-mappings.patch

This patch was dropped because an updated version will be issued

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


