Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B615175BD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759122; cv=none; b=SiFh2GYnpBKbsJol+LwkMEiPjLkfnnm3ZranmxYTTLc6sqSElNTtpFablZcBAscsfH44i6JFEv5UdKlRvXdYgHAjhRiymVqDERIlquKr2Z4P2R22kL3sPJFwhWY9wKWdQN1leR9x5l8g/m0FA5aJkINUhAejYG5BuR6h0MjyxNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759122; c=relaxed/simple;
	bh=Awra9X122bjbkkCEad72kPyFTNOvVuoi/pr7ngAsiCw=;
	h=Date:To:From:Subject:Message-Id; b=SBy4hBdifliuLtLW1UawkWEt+i4erK3uD1C7gM1TAfh/eLhYQBvm6SZ0BPjHJjVIyZJ8MD/qgKTT6bNhoL7SKXU3fXg9MVmJxpGOqXmSfwp8aVdXz9MuEck7crsMN5wDRcvWoLfSUphsK1/29uZmDiCu3Bpl8bHC8TFuY4quYpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kerm+Q4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kerm+Q4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF23C433F1;
	Wed,  6 Mar 2024 21:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759122;
	bh=Awra9X122bjbkkCEad72kPyFTNOvVuoi/pr7ngAsiCw=;
	h=Date:To:From:Subject:From;
	b=kerm+Q4kRhDJfLIfvuFk5wsqIyJjssYgd6jjUT6FI+8UEnw9EyQLUXpG9vs9kEvf5
	 mZJdPoPk5CshZbAZ64TUx8b7E5SzTaOD7g7u9jkQS8bDDbmVpe0MLBg87Dja80WxtB
	 h7L0y0iudYqey+5avJTXSa+C+CXSYkpTMYSO96Vo=
Date: Wed, 06 Mar 2024 13:05:21 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-use-pxd_leaf-in-shadow_mapped.patch removed from -mm tree
Message-Id: <20240306210522.2DF23C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kasan: use pXd_leaf() in shadow_mapped()
has been removed from the -mm tree.  Its filename was
     mm-kasan-use-pxd_leaf-in-shadow_mapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/kasan: use pXd_leaf() in shadow_mapped()
Date: Tue, 5 Mar 2024 12:37:46 +0800

There is an old trick in shadow_mapped() to use pXd_bad() to detect huge
pages.  After commit 93fab1b22ef7 ("mm: add generic p?d_leaf() macros") we
have a global API for huge mappings.  Use that to replace the trick.

Link: https://lkml.kernel.org/r/20240305043750.93762-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/kasan/shadow.c~mm-kasan-use-pxd_leaf-in-shadow_mapped
+++ a/mm/kasan/shadow.c
@@ -199,19 +199,12 @@ static bool shadow_mapped(unsigned long
 	pud = pud_offset(p4d, addr);
 	if (pud_none(*pud))
 		return false;
-
-	/*
-	 * We can't use pud_large() or pud_huge(), the first one is
-	 * arch-specific, the last one depends on HUGETLB_PAGE.  So let's abuse
-	 * pud_bad(), if pud is bad then it's bad because it's huge.
-	 */
-	if (pud_bad(*pud))
+	if (pud_leaf(*pud))
 		return true;
 	pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd))
 		return false;
-
-	if (pmd_bad(*pmd))
+	if (pmd_leaf(*pmd))
 		return true;
 	pte = pte_offset_kernel(pmd, addr);
 	return !pte_none(ptep_get(pte));
_

Patches currently in -mm which might be from peterx@redhat.com are


