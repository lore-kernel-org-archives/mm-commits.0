Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2080824B9
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 22:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717194396; cv=none; b=QEg0U/NSCgVHUpyF4esCAipVtEhgf2DPh7eEfCq1zGzMKKW/9bzwk9lqxCrU+xMk9IzaQEDeW79A5bVKKCZoqP7xiEX6bfo+eklaO6UuW/4VBOrwXxF01B2ZXYSuQCR9zWQX+Ug4rJiyw8pxR8IEcVTl5rWNkUi93ywKQdwQFU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717194396; c=relaxed/simple;
	bh=lMO8e+zJgy5Yy09fUm6P9MIgZT/znzBLsYiDpbQlySE=;
	h=Date:To:From:Subject:Message-Id; b=U/eKCV9NooJC2TIRGkWCb9kQBJIxYRIrEm9SsupXK1tK0HhI4cagdsLoRuEGdj38nW+mv4OKpe9m8cQHlELZyV3GSLjXjAI9qGXorf/Ukbs/qo9jyvqq6uEBTGU5OzeJ7rC5ei4ZdLYiwWXTipQZxE5G2Kd61FMQiYaNEFQK8GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y+Zw/90u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y+Zw/90u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB31C4AF0B;
	Fri, 31 May 2024 22:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717194396;
	bh=lMO8e+zJgy5Yy09fUm6P9MIgZT/znzBLsYiDpbQlySE=;
	h=Date:To:From:Subject:From;
	b=Y+Zw/90ukArWqbLrhFy/OfOP7fBQVZFgq8wKeS6DK0n2GF/O2gGYlZEHB0zIkNP2u
	 +cHCSXZ9z0gSoddlq/TMjNRAYAA/T7FTSCaHJyJ/fZWhVzfJyVhNaNFMPAqU99tUXL
	 EjGs3pCfb35Ax/3Iu0ebliy75CtFIgJdmT2TDK6w=
Date: Fri, 31 May 2024 15:26:35 -0700
To: mm-commits@vger.kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-consistently-use-_nr.patch added to mm-unstable branch
Message-Id: <20240531222636.3BB31C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: sparse: consistently use _nr
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-consistently-use-_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-consistently-use-_nr.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm: sparse: consistently use _nr
Date: Fri, 31 May 2024 18:11:44 +0530

Consistently name the return variable with an _nr suffix, whenever calling
pfn_to_section_nr(), to avoid confusion with a (struct mem_section *).

Link: https://lkml.kernel.org/r/20240531124144.240399-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/sparse.c~mm-sparse-consistently-use-_nr
+++ a/mm/sparse.c
@@ -192,13 +192,13 @@ static void subsection_mask_set(unsigned
 
 void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
 {
-	int end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
-	unsigned long nr, start_sec = pfn_to_section_nr(pfn);
+	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
+	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
 
 	if (!nr_pages)
 		return;
 
-	for (nr = start_sec; nr <= end_sec; nr++) {
+	for (nr = start_sec_nr; nr <= end_sec_nr; nr++) {
 		struct mem_section *ms;
 		unsigned long pfns;
 
@@ -229,17 +229,17 @@ static void __init memory_present(int ni
 	start &= PAGE_SECTION_MASK;
 	mminit_validate_memmodel_limits(&start, &end);
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
-		unsigned long section = pfn_to_section_nr(pfn);
+		unsigned long section_nr = pfn_to_section_nr(pfn);
 		struct mem_section *ms;
 
-		sparse_index_init(section, nid);
-		set_section_nid(section, nid);
+		sparse_index_init(section_nr, nid);
+		set_section_nid(section_nr, nid);
 
-		ms = __nr_to_section(section);
+		ms = __nr_to_section(section_nr);
 		if (!ms->section_mem_map) {
 			ms->section_mem_map = sparse_encode_early_nid(nid) |
 							SECTION_IS_ONLINE;
-			__section_mark_present(ms, section);
+			__section_mark_present(ms, section_nr);
 		}
 	}
 }
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-va_high_addr_switch-reduce-test-noise.patch
selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch
mm-sparse-consistently-use-_nr.patch

