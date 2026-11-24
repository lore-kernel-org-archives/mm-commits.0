Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795513076;
	b=WMRNBM2UadEW3rJmM/Y1Eoz0rVgszfU/1R5+UZL+BRzHuV1ZQFCiC/M2DH9k0+Gl/RWk
	 l4gyNadxNoxXg/GCZ+L/um/J+qPsXFh2jKS0tLk1WGemM3Ac7YDgcrbXTsUBNKjpAA6sI
	 NK9g8jIYgvi9XeOajQIFj7cuFElAjFISMHGdTrsY1PwdTpHwyM2/PkEGApbuUyg01lG1U
	 8ASWxXZ+8CxwSgoW4yjQtXcoPVjHx1gXVN9JrJrVCQr23PfY6Szp9KAzvM5fw6EYxeJPI
	 9AUgQgjpj1FYUfKKrZ7nPksPWMZzXZZB5kUONd8rwSughaJRdHqhWSp1FYb3mtxpiog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513076;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=AJeEdsAFI38aXIBkAzfjJd8Md8h0p3FWJwEpjOV3zIU=;
	b=w9bbDwhJsD3NNgQ9q0UwdrPkaAwlrorbOUicGeDMmcnSzXmTpszQVq+G2lfFxTE5LHWF
	 MxKcjQK/dPJLdfQL5Lhp+NVpbag7UQ8IPAzRYJf0MFKnMxnjzDFDNbPBNwDNv8IwEevq1
	 tZ3Gzso7inNs6aQU2/4NRiZKrVmF7cD9xBWOCNgozx15njHaGPmwtPDBLvqYYc96DuTgq
	 IEL0wjJM7yAPmdIZik0nMN/DOKpiN0JEATMM+nBJ4O+TCAfNYO8Bv8wguFqGi81f9dkHH
	 Gf5pu9PPDRNi5t3ugTPqh33hrODixD+U0Y09qp7sMVzUrnZ9FBUsxPMzyLWZF2lozYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BGr0gAxr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6339606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 09:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BGr0gAxr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BF01F000C4;
	Tue, 24 Nov 2026 09:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795513075;
	bh=AJeEdsAFI38aXIBkAzfjJd8Md8h0p3FWJwEpjOV3zIU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=BGr0gAxrY7F1xRmUSaEjaj15jDLFrk1KTgoahU2tKL1Zu3ysijopEgxuYHN5GmZwe
	 /UId3HPB0/F17RZ74RJgYnt6Crx/VZuXEtuzoA3y/QrYqFPspiCTIiM2WhRTx/mvhO
	 BXXmQyJ2p+CijMQuZUzcFPa8Yxz4bE3mwMtPTsQE=
Date: Tue, 24 Nov 2026 01:37:55 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vivek.kasireddy@intel.com,
	vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,stable@kernel.org,
	skhan@linuxfoundation.org,rppt@kernel.org,riel@surriel.com,
	rdunlap@infradead.org,peterz@infradead.org,peterx@redhat.com,
	osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,
	nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,
	mgorman@suse.de,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,
	leitao@debian.org,kraxel@redhat.com,josef@toxicpanda.com,jgg@ziepe.ca,
	hughd@google.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,
	borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,arnd@arndb.de,
	apw@canonical.com,aneesh.kumar@kernel.org,airlied@redhat.com,
	agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <68dcdfbc-2755-437f-bf58-d175b1740afd@kernel.org>
References: <68dcdfbc-2755-437f-bf58-d175b1740afd@kernel.org>
Subject: + mm-hugetlb-serialize-page-cache-allocations-with-truncation-fix.patch added to mm-unstable branch
Message-Id: <20261124093755.C0BF01F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fixup: mm/hugetlb: serialize page-cache allocations with truncation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-serialize-page-cache-allocations-with-truncation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-serialize-page-cache-allocations-with-truncation-fix.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: fixup: mm/hugetlb: serialize page-cache allocations with truncation
Date: Thu, 19 Nov 2026 17:57:41 +0100

Update documented locking order in mm/rmap.c.

Link: https://patch.msgid.link/68dcdfbc-2755-437f-bf58-d175b1740afd@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@kernel.org>

 mm/rmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-hugetlb-serialize-page-cache-allocations-with-truncation-fix
+++ a/mm/rmap.c
@@ -48,8 +48,9 @@
  * hugetlbfs PageHuge() take locks in this order:
  *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
  *     vma_lock (hugetlb specific lock for pmd_sharing)
- *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
- *         folio_lock
+ *       mapping->invalidate_lock (when allocating page cache folios)
+ *         mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
+ *           folio_lock
  */
 
 #include <linux/mm.h>
_

Patches currently in -mm which might be from david@kernel.org are

mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
mm-userfaultfd-prevent-poison-marker-loss.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-account-temporary-folios-separately-fix.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation-fix.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch

