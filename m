Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9520D2F3C3B
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 23:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755126382; cv=none; b=BEyWSr94sYgsvTwSUBiiOgaD3eorlP+mQczl9iJETKBh/QSf0w4HbaE+1nzXLK8TejTuLbEru+AQ+O1g/0uKhB0Ko+PDvWuvUI41tP79RfW37PzLkMrOz6svsT/glWvQVzlkx07Lez2Sxn397b0t4uM3vsq/btaQBi3a25nHKos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755126382; c=relaxed/simple;
	bh=OoRBEY5XT3PpIIfGrDE4o2N9L6fD1zLMOElFcbAUDcU=;
	h=Date:To:From:Subject:Message-Id; b=f01erbXrKg/hRMzZsJ11ALbYm80hizoewtIuodJG9oQloSjehXUQHcJUbAKYz+W68cH+m0pEuJN7nuMV6L3u8+chsYZLIahH/IyJp9IeDA80B4TyF+hLPHjbKYPEjWNPzaWB4PEOxeBWbvZ5MSioguLuc9BCOAsxeZsCD5qpmoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IiNrmH1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IiNrmH1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FF4C4CEEB;
	Wed, 13 Aug 2025 23:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126382;
	bh=OoRBEY5XT3PpIIfGrDE4o2N9L6fD1zLMOElFcbAUDcU=;
	h=Date:To:From:Subject:From;
	b=IiNrmH1QApmLM+E/0amHB/UIvWrzO2dGX0TgtRNxfnjkbL77wJE0UjxVzMkndhFEb
	 SwTWdwWeoad2snFmT4PlMq3U92XS+0chgdPqeAhFSyyo+WrKAOok5JBJopnHqz+yGN
	 yNZ58mjXiUjlGMD51xjuMOa6WumHxwY42q8CFa4Q=
Date: Wed, 13 Aug 2025 16:06:21 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,nicholas@linux.ibm.com,mingo@kernel.org,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-add-pud_pfn-stub.patch added to mm-new branch
Message-Id: <20250813230622.05FF4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: mm: add pud_pfn() stub
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-add-pud_pfn-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-add-pud_pfn-stub.patch

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
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: powerpc: mm: add pud_pfn() stub
Date: Wed, 13 Aug 2025 16:26:11 +1000

The page table check feature requires that pud_pfn() be defined on each
consuming architecture.  Since only 64-bit, Book3S platforms allow for
hugepages at this upper level, and since the calling code is gated by a
call to pud_user_accessible_page(), which will return zero, include this
stub as a BUILD_BUG().

Link: https://lkml.kernel.org/r/20250813062614.51759-11-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-add-pud_pfn-stub
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -214,6 +214,15 @@ static inline bool arch_supports_memmap_
 
 #endif /* CONFIG_PPC64 */
 
+#ifndef pud_pfn
+#define pud_pfn pud_pfn
+static inline int pud_pfn(pud_t pud)
+{
+	BUILD_BUG();
+	return 0;
+}
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are

mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch
mm-provide-address-parameter-to-ptemdud_user_accessible_page.patch
powerpc-mm-add-pud_pfn-stub.patch
powerpc-mm-implement-_user_accessible_page-for-ptes.patch
powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch
powerpc-mm-support-page-table-check.patch

