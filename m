Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42023AA19D
	for <mm-commits@vger.kernel.org>; Tue, 24 Feb 2026 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955875; cv=none; b=LjzkLXKkgT+aDUFzgKh+DUzg2ixWzR0ujhDk0/CazjANup1MvOFswH8njWW9BlG0ZQ+Hat6D4wMO+B2kIRKt/wLwPwJQWejEP/zWrZ6Z8IQe9tlHPsLUDU+MJIsQL5aW7c45Q5HCN2xa1lLCn7CuBXtlYeIsTrfwsNvFsw6vEVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955875; c=relaxed/simple;
	bh=Ki3MNligh8ThGb0qoqiXoNpg6aO1cmH0d4q0VEn0wlE=;
	h=Date:To:From:Subject:Message-Id; b=uDG8R8gwZQBBYTyaYDqGTx024Zyvt42auDyY0iQ/6Gw14Uz8o3EDrFzIS1S6ESI9O/+iHjOncO4P58u+UlbR6u1v72UfXXn90levASRFoQgP5sIdbzlraMBedVc+p/QJYzjaWVxO20Ku7TDTFBveG6WGpWYWewBWtSs2C0CTEOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iz8/m3Ej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iz8/m3Ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BF2C2BC86;
	Tue, 24 Feb 2026 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771955875;
	bh=Ki3MNligh8ThGb0qoqiXoNpg6aO1cmH0d4q0VEn0wlE=;
	h=Date:To:From:Subject:From;
	b=Iz8/m3EjOt9VZqzqKSE0vrWUVA+zcY2G6sifeqFz2H6G/Jut9qYrVqFUMC2AnAA/I
	 RtRdnPE5e1umcr8eGl1sW/ASYVyhJHGvsMlxoWv4A17/jSa8oPsbGrHScUcgNKHvg4
	 YeMIroStRPWVdJ5Pkf4DtM/Ac5e1qNdYq/lZLzLU=
Date: Tue, 24 Feb 2026 09:57:54 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,julia.lawall@inria.fr,david@kernel.org,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-update-outdated-comment.patch added to mm-unstable branch
Message-Id: <20260224175755.70BF2C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_vmemmap: update outdated comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-update-outdated-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-update-outdated-comment.patch

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
From: kexinsun <kexinsun@smail.nju.edu.cn>
Subject: mm/hugetlb_vmemmap: update outdated comment
Date: Tue, 24 Feb 2026 10:28:40 +0800

The function vmemmap_pte_range() was refactored into vmemmap_pte_entry()
by commit fb93ed63345f ("mm: hugetlb_vmemmap: use walk_page_range_novma()
to simplify the code").  Both functions share the key behavior that the
reuse page is identified first before remapping begins.  Update the
comment accordingly.

Link: https://lkml.kernel.org/r/20260224022840.1936-1-kexinsun@smail.nju.edu.cn
Signed-off-by: kexinsun <kexinsun@smail.nju.edu.cn>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-update-outdated-comment
+++ a/mm/hugetlb_vmemmap.c
@@ -350,7 +350,7 @@ static int vmemmap_remap_free(unsigned l
 	/*
 	 * In order to make remapping routine most efficient for the huge pages,
 	 * the routine of vmemmap page table walking has the following rules
-	 * (see more details from the vmemmap_pte_range()):
+	 * (see more details from the vmemmap_pte_entry()):
 	 *
 	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
 	 *   should be continuous.
_

Patches currently in -mm which might be from kexinsun@smail.nju.edu.cn are

mm-hugetlb_vmemmap-update-outdated-comment.patch

