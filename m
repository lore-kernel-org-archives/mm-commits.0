Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915991DE3A4
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766963492; cv=none; b=F6ymstnSQR48lgh/cVing8dbwzXU0hrw5HYrC04yEFlsdCjH77AZNjaeL6190WcW2RS0nZ6ntCOeL+RV6mbbFMYBmllv5xmD6KJNsqtMKMpeQp4/sD6wAhSFb6OwOSk/Ka6ezDA2YAcu4ribzKOsJ7+LCWXQnrFDLRV9dwrxxwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766963492; c=relaxed/simple;
	bh=0bpR19T4LTN4K1MUWP6O5aGcrHt8oF9AmmiT7Iqgyos=;
	h=Date:To:From:Subject:Message-Id; b=KA9m4bifjxKiTL08dGFLzvtjfurL8Fw2FqZBwkSghiWTdootoYJyezyB6SjPF+mCrW0pzcV2+C42KZtIixvDxs8JntilAuzXT5fsKH1kWhtC6LMKrVI3Il6V/wGInE9XyGFwO7CIL6e8oZLVDUe6VRv8eFSrrqOLeo5OQP1Si4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KY8yW7dV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KY8yW7dV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BD2C4CEFB;
	Sun, 28 Dec 2025 23:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766963492;
	bh=0bpR19T4LTN4K1MUWP6O5aGcrHt8oF9AmmiT7Iqgyos=;
	h=Date:To:From:Subject:From;
	b=KY8yW7dVMwueCAWO3IhtpgnoYeK0bPnd3O2dvEQvv8UkJNhS+Rf6wNG+68cmMvzHM
	 6JvkcGBHScuL/qCgZd7oKISkuSfXoYIlXxrT+ArBxlPluCa+40Iuj9wpQFSEm9ELNm
	 MdxlnENp0N1wKBL4oxf43v6M7m1qjvGHBc1nVA6o=
Date: Sun, 28 Dec 2025 15:11:31 -0800
To: mm-commits@vger.kernel.org,suschako@amazon.de,riel@surriel.com,osalvador@suse.de,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,lance.yang@linux.dev,harry.yoo@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix.patch added to mm-unstable branch
Message-Id: <20251228231132.30BD2C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix.patch

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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix
Date: Thu, 25 Dec 2025 10:41:55 +0100

fix kerneldoc

Link: https://lkml.kernel.org/r/f223dd74-331c-412d-93fc-69e360a5006c@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmu_gather.c~mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix
+++ a/mm/mmu_gather.c
@@ -462,8 +462,8 @@ void tlb_gather_mmu_fullmm(struct mmu_ga
 }
 
 /**
- * tlb_gather_mmu - initialize an mmu_gather structure for operating on a single
- *		    VMA
+ * tlb_gather_mmu_vma - initialize an mmu_gather structure for operating on a
+ *			single VMA
  * @tlb: the mmu_gather structure to initialize
  * @vma: the vm_area_struct
  *
_

Patches currently in -mm which might be from david@kernel.org are

mm-hugetlb-fix-hugetlb_pmd_shared.patch
mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix.patch

