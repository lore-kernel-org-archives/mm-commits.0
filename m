Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CF525B0B1;
	Fri, 22 May 2026 00:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779410594; cv=none; b=RjUD+DLn6eaM4ILtwnbI6WlWhZyiPSw4FcfAfOKmwdw/0Pwyra4J/4fQXn4S6ZeqLMrUpQoPiimIHHSL8LIir9WpVJalUnRypnqfN/abo11tGARG2LATYjZAkf7J3MQ9qmatiK8ZI1AdSPnqDZ61x2S5HLMJckqKKLfXI5SXEdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779410594; c=relaxed/simple;
	bh=B1Lt7gNM+fakb2hE5bzmLLmpYgJ70acrfnlrRqmz8Eo=;
	h=Date:To:From:Subject:Message-Id; b=aYJUmyl8zJ4z4UBBxIrtGV9vv0FS/iZijRT0T2nLvS2y+EIrNuaaaRvDA1qrNB7+VFh9kGKDAspz/Zk1MklOIwPIguaHr2Efa8atc/ONvM0/3pV7ZtGaWsYJtp9Mry8UZER1TmEe6vc318VmKtsRD9a2PPVQQ1tI1+aPUZayzJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oH3u7xsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oH3u7xsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4211F000E9;
	Fri, 22 May 2026 00:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410592;
	bh=omDkwlP6luyP5G/eh1X+mkMA3BZQNxFEQ5cm4exXCD4=;
	h=Date:To:From:Subject;
	b=oH3u7xsacSMWHrdhb9ESYmC3C2pzRn+Jjq8iPiU4nzIJ7Ap5OS3hRdJMz50kG6LjD
	 WQkFojd5QNXlGyfiu5kKP0ymidU7TxzsbuwfwVrswFiaPJwq6eHBOztq1FqpHx4P9M
	 jcHAmusgVraMwq8rX4jLM3JJXe8b3XmHtMYwb2uA=
Date: Thu, 21 May 2026 17:43:12 -0700
To: mm-commits@vger.kernel.org,yuehaibing@huawei.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,almasrymina@google.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch removed from -mm tree
Message-Id: <20260522004312.9B4211F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path
Date: Sun, 22 Mar 2026 05:21:20 +0000

When the resubmission path in hugetlb_mfill_atomic_pte() allocates a new
hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is consumed. 
If copy_user_large_folio() subsequently fails (e.g.  -EHWPOISON when the
source page is hwpoisoned), folio_put() restores the global hugetlb pool
count through free_huge_folio(), but the per-VMA reservation map entry is
left marked consumed.

User-visible effect: on a UFFDIO_COPY into a private hugetlb VMA where the
resubmission path's copy fails, the reservation for that address is leaked
from the VMA's reserve map.  A subsequent fault at the same address takes
the no-reservation path, and under hugetlb pool pressure the task is
SIGBUSed at an address it had previously reserved.  One map entry is
leaked per occurrence.

Add the missing restore_reserve_on_error() call before folio_put(),
matching the first-attempt error path which already handles this
correctly.

Link: https://lore.kernel.org/20260519230503.121293-1-devnexen@gmail.com
Link: https://lore.kernel.org/20260322052120.14021-1-devnexen@gmail.com
Fixes: 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: yuehaibing <yuehaibing@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path
+++ a/mm/hugetlb.c
@@ -6270,6 +6270,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb-folio-copy-paths.patch
mm-page_io-rename-swap_iocb-fields-for-clarity.patch
mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

