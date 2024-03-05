Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AE4175A1
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709661038; cv=none; b=Hl1U1L51yvVoX5DCYta+yEPALiZ+ACA4IjlmAvql4MYL3dcTQwXPOb5NTd7hi5E22/xv2N8mNGJa5pWT+Ea28wxeXa7kO0rWPwPi/tZZYHDzR3IUFHIsrU5srfBwyEC/kMw6kKJays6KXoA6HywXluELQ0PvocCJwAD1GrRuL/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709661038; c=relaxed/simple;
	bh=23FPPFvNrHoXAWL9DMDCr7qZs2zpvKqW48GNw7nW5Hs=;
	h=Date:To:From:Subject:Message-Id; b=iTgVBG3Hmd+DBAh/9J58MyxPbvsIK+9Xtl7DVbQ1igvdM817pS/GxbQbFw6wu4q8q29PBQILcbCDvjtQWZaCZHvUALQhM2BMALTJ9gN5vDa0IfobXZtsEQ9rmwOli+0+Ep+dKRLpRMsM+0sTbgJdkzPTnPFsLjuZ1gkPvGo9hs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2gsD5ENg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2gsD5ENg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8DAC433F1;
	Tue,  5 Mar 2024 17:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709661038;
	bh=23FPPFvNrHoXAWL9DMDCr7qZs2zpvKqW48GNw7nW5Hs=;
	h=Date:To:From:Subject:From;
	b=2gsD5ENgt/fHP86DaofJmT6sA42w90li2NsPcr5uqZSZdk6lNyO/cQtCZojxKiEtB
	 dj9r+UgGhMKeRWWfALwv8wZKXfwDPF30DzxqNlpc7+PT8DHWOVms9X0i6NItB063MK
	 jQH1L4nizlpjFYeANNzBBtcves9lff5dSui68KH8=
Date: Tue, 05 Mar 2024 09:50:38 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-use-pxd_leaf-in-shadow_mapped.patch added to mm-unstable branch
Message-Id: <20240305175038.9C8DAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: use pXd_leaf() in shadow_mapped()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-use-pxd_leaf-in-shadow_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-use-pxd_leaf-in-shadow_mapped.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/kasan: use pXd_leaf() in shadow_mapped()
Date: Tue, 5 Mar 2024 12:37:46 +0800

There is an old trick in shadow_mapped() to use pXd_bad() to detect huge
pages.  After commit 93fab1b22ef7 ("mm: add generic p?d_leaf() macros") we
have a global API for huge mappings.  Use that to replace the trick.

Link: https://lkml.kernel.org/r/20240305043750.93762-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
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

mm-ppc-define-pxd_large-with-pxd_leaf.patch
mm-ppc-replace-pxd_is_leaf-with-pxd_leaf.patch
mm-x86-replace-p4d_large-with-p4d_leaf.patch
mm-x86-replace-pgd_large-with-pgd_leaf.patch
mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch
mm-kasan-use-pxd_leaf-in-shadow_mapped.patch
mm-treewide-replace-pmd_large-with-pmd_leaf.patch
mm-treewide-replace-pud_large-with-pud_leaf.patch
mm-treewide-drop-pxd_large.patch
mm-treewide-align-up-pxd_leaf-retval-across-archs.patch

