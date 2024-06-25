Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B88F49635
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291623; cv=none; b=W+YNbJMyCtfoCIRCuvskjM4Md9jWsHcDvglj/rtZy98d+1ez8ZIg4Y0ghVe5WFMvyPf/PD7Ra6LcgeSH3x4hYpNv9JlTNP9oDeC0KCLUiiJMVLw/ME2FxWh4HHth4HffR6L3hh2uWfX1+da+ADIbq6O0I11LIqvM+S2tj+rEdgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291623; c=relaxed/simple;
	bh=qmFsLyrczOyEanBWiFUgrDDBFlPrIhVS6AUQIk2j2VQ=;
	h=Date:To:From:Subject:Message-Id; b=CkYnSCZcU8mSj3mSXXqgUazrJQwyKVQrgHgj9YSkdQ68X4e9rKcuukQSRA+ax3Sw6WacGffx7mfBHpbo4Hd3Q4YfkI6ZSSIrmXwWxw3C43lZe2zlAxH0PV0whKyk3wALNjmiLdLwlNFW016ILkXaYq89bARwdlWASGEwyHgVsKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZY2z1uAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZY2z1uAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30662C32782;
	Tue, 25 Jun 2024 05:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291623;
	bh=qmFsLyrczOyEanBWiFUgrDDBFlPrIhVS6AUQIk2j2VQ=;
	h=Date:To:From:Subject:From;
	b=ZY2z1uAwZObQ7xx/lGy9LOqrZx3QnUCIkr0J2pTPgsedi8aOwOlGHADWBlkdBJz+L
	 W0uU/5tbiFFgq4AxtCWRdzz21tzywyYPYF0nMaZcV8l5SSpq+nFPC4Pghd8Bc1u+MB
	 dte37Xh+2BO+at+dbV6SBZKl9iU0dBhdxm1NRgA4=
Date: Mon, 24 Jun 2024 22:00:22 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-consistently-use-_nr.patch removed from -mm tree
Message-Id: <20240625050023.30662C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: sparse: consistently use _nr
has been removed from the -mm tree.  Its filename was
     mm-sparse-consistently-use-_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: sparse: consistently use _nr
Date: Fri, 31 May 2024 18:11:44 +0530

Consistently name the return variable with an _nr suffix, whenever calling
pfn_to_section_nr(), to avoid confusion with a (struct mem_section *).

Link: https://lkml.kernel.org/r/20240531124144.240399-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
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


