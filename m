Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640264;
	b=dD9V8DUW6TZKonx00WwR5Zl44dRsG2Mx6ckI4ddBmdZsWJguPUqjcD6vymbFhatnVVNC
	 GtoTvsMh5ekArPeFv4xemGUmEUC4Mog/KW9d9Tf/QZThox37Iuy4u6KFfsKAcUvyX0UiI
	 ugzTF6l9TTxjbY7xdHSkuUoc4YBigKD4v/kkKuEPgj5QMyLzjnUU6pyzWi1oTXBKiaR/N
	 o7VVuF+RUbZ3BFDJiwX9Aph/95Y1fKlouXwUGJWllVie6/u1xEwX8FIpuWDaFWYVsUK6p
	 RBwXgUZqtcngt4m1TuhASY7rn/prEgPRB0ikODm2yjLUEuacfl7kRieQv65DwYtwTbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640264;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=poLPn8dex7MI6ZZhm+WOPYpI6C4wlZixUP63vOKZan8=;
	b=erJN8WJgPbs822cJ9hyGKqPgeOneaihFr7q4sYhygLVtcnXQFsVLbUlYuU5OXBRlGv6k
	 Zi+qT+693EyLOpMf6Kju2T/e6UrI6EM7N8++2kWCcrh9FhbvU/JvjAG1wjOprjZp3pfBs
	 i/rsN66Roi+hGzA2QY+5y9H9RjOufnr0l4TWUHuzupQyrj0NJfWb/Bd2E0h4AtFpXkRVe
	 IEEtbcDaX8DCmvOz5eoD86hbqOz0KFE3lQSZPwV9+2e/nt34IQlmnYGejXML6HFIYnXwJ
	 lO+UcpUkgPq6zAWx6Uqv7kzpqxlNJJ9Tnn5Mg+B4JBDVnmZG5IRV/2YCEIH2pGc8Rog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pfOh5oh1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556D5606B922
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pfOh5oh1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0CB1F00A17;
	Mon,  2 Nov 2026 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640264;
	bh=poLPn8dex7MI6ZZhm+WOPYpI6C4wlZixUP63vOKZan8=;
	h=Date:To:From:Subject;
	b=pfOh5oh1QnRGJ41Vpc7NMxc1VLVU53xsxRdqTeCb6i1IvnX0plewHsgoXW1Ke3JM1
	 Z6Wt/ksKh3qsLi55yZZfDJvpDSc7FDX0Vnu1MrpR3XteQapMz4fV0Lig/jwio//LgG
	 o7K1YGwlTm0Wbkq41Wqni/wMvSOeJPLMiS4SguS0=
Date: Mon, 02 Nov 2026 09:24:23 -0800
To: mm-commits@vger.kernel.org,sjpark@amazon.de,sj@kernel.org,
	sieberf@amazon.com,sh@gentwo.org,shakeel.butt@linux.dev,
	ruanjinjie@huawei.com,manuelebnerli@mailbox.org,lienze@kylinos.cn,
	jaeyeon.lee.dev@gmail.com,foersleo@amazon.de,adrianhuang0701@gmail.com,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch added to mm-new branch
Message-Id: <20261102172424.1F0CB1F00A17@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/ops-common: align MMU notifier range when clearing PMD young bit
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/damon/ops-common: align MMU notifier range when clearing PMD young bit
Date: Mon, 02 Nov 2026 07:07:50 -0800

damon_pmdp_mkold() clears the young bit of a PMD but notifies
[addr, addr + HPAGE_PMD_SIZE), where addr can be an unaligned sampling
address. This can miss part of the sampled huge page and age secondary
mappings in the next one.

Align addr to HPAGE_PMD_MASK so both operations cover the same huge page.

Link: https://lore.kernel.org/20261102150757.93058-4-sj@kernel.org
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Shubhang Kaushik (Ampere) <sh@gentwo.org>
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

 mm/damon/ops-common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit
+++ a/mm/damon/ops-common.c
@@ -102,6 +102,8 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 	bool young = false;
 	unsigned long pfn;
 
+	addr &= HPAGE_PMD_MASK;
+
 	if (likely(pmd_present(pmdval)))
 		pfn = pmd_pfn(pmdval);
 	else
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch

