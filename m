Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238B71F8BAF
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741906110; cv=none; b=uUbNh7zCEv0YEzPms4jJTI5n/BXzpDGWEaKvOtKcA2hl3xujB2WZFzjYYZ0TdELB3FPU3gVivLBJjKYEv/FKVcVBjCR7x7SKN9F4v8FhZ9Sp7ue1LFCNYy2q1Ozp9bom8zXaI1SAUHouFIxW9Q5Tz1ZDC6JIHLO6qtZKFM/cnsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741906110; c=relaxed/simple;
	bh=cp0so5gXGNaTY29Slwynzlky2DEdJE8yqDNRH3p/oXo=;
	h=Date:To:From:Subject:Message-Id; b=ipGfoGT0gJJVIHS4vIrG38qDwNX48jUytB4EPDcUntdaNPk3tpjzyvxw1JSSVjQbNpWtYq0BpKfcuyfgVb6/z2GQLibdJdGxzL+JOYM4L2Ekp0OuPzjhuSkzliW2l4Bgi/5dZ3BnSp9AAAKEwWv8/kEwxHf6q5jVsJnxPLSsjhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gIcmitGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gIcmitGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E183C4CEDD;
	Thu, 13 Mar 2025 22:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741906109;
	bh=cp0so5gXGNaTY29Slwynzlky2DEdJE8yqDNRH3p/oXo=;
	h=Date:To:From:Subject:From;
	b=gIcmitGZtqvh49cn+3bNbXvEj38SDQAYK5Glj92xwAgJ09VVQmm3WpyByKOOBS+58
	 wrzpcSlPZnCuTIfhmgolxO/XDAfurtPrEpP+qvdowESyAzcwsNCw9YFtzAtyuKL3sd
	 R3+N2bdUkDs7IC7kYnlczah0jSxdcp/2CbWTtOTQ=
Date: Thu, 13 Mar 2025 15:48:28 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,christophe.leroy@csgroup.eu,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-add-pud_pfn-stub.patch added to mm-unstable branch
Message-Id: <20250313224829.7E183C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: mm: add pud_pfn() stub
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-add-pud_pfn-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-add-pud_pfn-stub.patch

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
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: powerpc: mm: add pud_pfn() stub
Date: Wed, 12 Feb 2025 03:14:01 +1100

The page table check feature requires that pud_pfn() be defined on each
consuming architecture.  Since only 64-bit, Book3S platforms allow for
hugepages at this upper level, and since the calling code is gated by a
call to pud_user_accessible_page(), which will return zero, include this
stub as a BUILD_BUG().

Link: https://lkml.kernel.org/r/20250211161404.850215-9-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-add-pud_pfn-stub
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -215,6 +215,15 @@ static inline bool arch_supports_memmap_
 
 #endif /* CONFIG_PPC64 */
 
+#ifndef pud_pfn
+#define pud_pfn pud_pfn
+static inline int pud_pfn(pud_t pud)
+{
+	BUILD_BUG();
+	return 0;
+}
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are

mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch
mm-provide-address-parameter-to-ptemdud_user_accessible_page.patch
powerpc-mm-add-pud_pfn-stub.patch
powerpc-mm-implement-_user_accessible_page-for-ptes.patch
powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch
powerpc-mm-support-page-table-check.patch

