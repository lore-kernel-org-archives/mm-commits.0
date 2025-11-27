Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACE2305051
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 19:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764272023; cv=none; b=RxgMMSy+EMaIVFJHLUniqVaUB78GsPX0DBuK7MnXfJ+/rVp1pIbSwHol0qAzzpobKm8oEvXUIApXSczAThN6Qby7LejpYkeyR4VncFwtwPzFOoPpSnGRBOPB0s68xmQUuiS1LivLjJVwu++9YZAgMKwP8qeA2iMpVJlTH2m2Crg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764272023; c=relaxed/simple;
	bh=binVvdN0DPCnbQ+hdozAXU1iklv8VR2iTrTooKoYX5s=;
	h=Date:To:From:Subject:Message-Id; b=JTp6uYJuoEGE9Ai0mOQsQKBVpDa5oBsSFZv77LVjjmMfVzlhrHr35rUCBd8wPMdsL8Dt7WmH5kNOBuJyebDF3+RPjq14jAU+R2TlQy86pexxFv5LnB6IByslLWzfvskKZqL2WJBCRC7Ea0pLUJ3/oL+FhgHvcWUn4R0jtYZ0vYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kEUPvJkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kEUPvJkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AD5C4CEF8;
	Thu, 27 Nov 2025 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764272022;
	bh=binVvdN0DPCnbQ+hdozAXU1iklv8VR2iTrTooKoYX5s=;
	h=Date:To:From:Subject:From;
	b=kEUPvJkNILr/kFVrl5G9rasPAVJhDHdWuQT+o+hzq4pF6zfqAF7oVWZ/458X50FaJ
	 58N1A1yX0iY2LbRWeITveZJn/MKKmnce47/G5LHkx1jNn701lPVIpjD9Xus7EdF2Sq
	 AuVJr0XpoiOPmyb3lT9FX3uKMNW/bCrtvQNSavvw=
Date: Thu, 27 Nov 2025 11:33:41 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling.patch added to mm-unstable branch
Message-Id: <20251127193342.94AD5C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu.c: fix make_uffd_wp_huge_pte() huge pte handling
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fs/proc/task_mmu.c: fix make_uffd_wp_huge_pte() huge pte handling
Date: Thu, 27 Nov 2025 17:45:17 +0000

make_uffd_wp_huge_pte() should return after handling a huge_pte_none()
pte.

Link: https://lkml.kernel.org/r/66178124-ebdf-4e23-b8ca-ed3eb8030c81@lucifer.local
Fixes: 03bfbc3ad6e4 ("mm: remove is_hugetlb_entry_[migration, hwpoisoned]()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Closes: https://lkml.kernel.org/r/dc483db3-be4d-45f7-8b40-a28f5d8f5738@suse.cz
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling
+++ a/fs/proc/task_mmu.c
@@ -2500,9 +2500,11 @@ static void make_uffd_wp_huge_pte(struct
 	const unsigned long psize = huge_page_size(hstate_vma(vma));
 	softleaf_t entry;
 
-	if (huge_pte_none(ptent))
+	if (huge_pte_none(ptent)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
+		return;
+	}
 
 	entry = softleaf_from_pte(ptent);
 	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-declare-vma-flags-by-bit.patch
mm-simplify-and-rename-mm-flags-function-for-clarity.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch
mm-introduce-vma-flags-bitmap-type.patch
fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling.patch

