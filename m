Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640262;
	b=qRI1Cv2ewFEE4YevraR0X34iVCbCa7VWBTiqjQnR6Ig484HsfJyZZGRAWiY7/J1lg8sM
	 YUpMxuAXr8CVmNKHk6d28SiDYCsL96g+9iqoEhzCKKdnZnr/u90zDewAA2GCmXgOV0hwk
	 MR/ePeFIHD472StDd+Maj+xxOw5kuszHUz2R76vrzBBxCBsBbKK5AFCsOlCaDdTeS/iPV
	 DdXIl4eslg4vqHFj533poX6A9RFg/KG9qd0M9jcd/H1Hbm9ykfiVQ/PLPm+QeEO54yZjb
	 K2QrsiT95DDxO+RL+z2Y/ZMSbfFoCaEF7GcXRdvG6K7HVVOCPs+JH0Ac0yU4X7ZNidg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640262;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TnP8R84OHs/pZi9TpOSeG+NCuAkBuG4nMPPAdbbk50U=;
	b=3ZLY1KzkjNdz2UAdmdsDPwIEHKrpGDW3GGD5TnUjts75xEO89kQz7LJmLrwdAEx1i/VK
	 qm3N7asi0RR9PJclQcVGQmv4kfoQmOX5EsiMSfIReARiEnyFrqriOX/E+QG9lh2w87CAQ
	 GOqkynq6WfrnRld4isKK0xL9FRyi+MNE/NFrp54gHK2vCYr2hjC+apJv8gGmUJzSVin60
	 kjlZCipIAJgkg4HP3gJxECExqbCoKl1UcIkcYaGejTUmCjQ7O1G/gfizoB1ds1mxP+Shv
	 x1t2WSSXmHTpvrCvve8/tt00yHT9kqTbJ0x4Lpm+K83F53DxlK8aumFfFVMeQAAeqRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bY6mOesr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70033606B929
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bY6mOesr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279701F00A1A;
	Mon,  2 Nov 2026 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640262;
	bh=TnP8R84OHs/pZi9TpOSeG+NCuAkBuG4nMPPAdbbk50U=;
	h=Date:To:From:Subject;
	b=bY6mOesr6ndurmXqEv5IdTL9MbZo5zxxdHpfTZc1QJZ/Gbs7Mbn51o5htXe468hEh
	 yqSvkkhULdgnvkpHV7d6N130ntHo2+saI6eAz+dOrAjw4Fus1L9OZvbuzGVvQWzgo9
	 9k40HxCJRcXmpOhAUcLVQkGCjDBqtteNT6HitE3M=
Date: Mon, 02 Nov 2026 09:24:21 -0800
To: mm-commits@vger.kernel.org,sjpark@amazon.de,sj@kernel.org,
	sieberf@amazon.com,shakeel.butt@linux.dev,ruanjinjie@huawei.com,
	manuelebnerli@mailbox.org,lienze@kylinos.cn,jm5905938@gmail.com,
	jaeyeon.lee.dev@gmail.com,foersleo@amazon.de,adrianhuang0701@gmail.com,
	sh@gentwo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pte-young-bit.patch added to mm-new branch
Message-Id: <20261102172422.279701F00A1A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/ops-common: align MMU notifier range when clearing PTE young bit
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pte-young-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pte-young-bit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Subject: mm/damon/ops-common: align MMU notifier range when clearing PTE young bit
Date: Mon, 02 Nov 2026 07:07:49 -0800

DAMON selects a byte-granular sampling address.  damon_ptep_mkold()
clears the young bit of the PTE covering that address, but passes the
unaligned range [addr, addr + PAGE_SIZE) to MMU notifiers.

For an unaligned address, that range extends into the following page.
KVM ages every guest page intersecting the notifier range, so it can age
a secondary mapping for the following page although DAMON cleared only
the sampled page's primary PTE.

Align the address before both the primary PTE operation and the
MMU notifier call so that they cover the same page.

Link: https://lore.kernel.org/20261102150757.93058-3-sj@kernel.org
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
---

 mm/damon/ops-common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pte-young-bit
+++ a/mm/damon/ops-common.c
@@ -64,6 +64,8 @@ void damon_ptep_mkold(pte_t *pte, struct
 	bool young = false;
 	unsigned long pfn;
 
+	addr = PAGE_ALIGN_DOWN(addr);
+
 	if (likely(pte_present(pteval)))
 		pfn = pte_pfn(pteval);
 	else
@@ -83,8 +85,7 @@ void damon_ptep_mkold(pte_t *pte, struct
 		 * Arch implementation of ptep_test_and_clear_young() may
 		 * require aligned @addr
 		 */
-		young |= ptep_test_and_clear_young(vma, PAGE_ALIGN_DOWN(addr),
-				pte);
+		young |= ptep_test_and_clear_young(vma, addr, pte);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 	if (young)
 		folio_set_young(folio);
_

Patches currently in -mm which might be from sh@gentwo.org are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pte-young-bit.patch
ipc-msg-fix-msg_qbytes-truncation-in-ipc_set.patch

