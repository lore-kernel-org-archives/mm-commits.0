Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B7A78B68
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 19:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579865; cv=none; b=JVRk2ZtdIJHQrX6r3wkCiMkE/lomN52gilzO7kF4+7/z9Mzz3VAfSoQY9dNKXUtMMELcyeDIRyw/q0HCOI2Y/QxOHuQMRsfzzTf6Q9DvyuAJ0/hZF2MN5Qi/EZFjJNVop0C63URrdPhoPwApxunwF50Jah/T5mUiLI2uU/hzcBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579865; c=relaxed/simple;
	bh=NzpwFWLw9DT+svIiCLiGGjC5Dz1u+N5Y2z17NdFUoFY=;
	h=Date:To:From:Subject:Message-Id; b=h48hdMyViyWu7WU1EPkeL9YxuIWSGWih2IEikvkaDo8r6xKX0fBzKc5GEhlxvL8PrGPD35DMD8g5uLfIYTE0byHukHDTQg3Qspg1QIBLyPm0ywivjnMCF4c0fuGoPAnIZOMDt688gkwWECUR3/pwjSWZM7gSLkKjE1tueSlC//0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=drl9audc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="drl9audc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F09DC433F1;
	Mon,  4 Mar 2024 19:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709579865;
	bh=NzpwFWLw9DT+svIiCLiGGjC5Dz1u+N5Y2z17NdFUoFY=;
	h=Date:To:From:Subject:From;
	b=drl9audcRQsAUOrcfSpSxy3iigF21IzOLCUROM6PzIqJP+wBB5JpvLGPSkmEdP+Wl
	 kxBKnSmW7U6wP9f/b7YBfpxtACTeSi8DgndMBu9Lpxt3si/RRl/8cZsRbPUpXgHJNA
	 WsHGxTkRbPFUomX9V5E/eJCllzG71wEuzzgueKe0=
Date: Mon, 04 Mar 2024 11:17:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,broonie@kernel.org,ardb@kernel.org,aishwarya.tcv@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-__dump_folio-fix-3-fix.patch added to mm-unstable branch
Message-Id: <20240304191745.3F09DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-__dump_folio-fix-3-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-__dump_folio-fix-3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-__dump_folio-fix-3-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-__dump_folio-fix-3-fix
Date: Mon Mar  4 11:15:25 AM PST 2024

s/printk/pr_warn/

Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-add-__dump_folio-fix-3-fix
+++ a/mm/debug.c
@@ -139,7 +139,7 @@ again:
 	if (idx > nr_pages) {
 		if (loops-- > 0)
 			goto again;
-		printk("page does not match folio\n");
+		pr_warn("page does not match folio\n");
 		precise.compound_head &= ~1UL;
 		foliop = (struct folio *)&precise;
 		idx = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-add-alloc_contig_migrate_range-allocation-statistics-fix.patch
mm-add-__dump_folio-fix-3-fix.patch

