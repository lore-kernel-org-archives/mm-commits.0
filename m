Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3739A7603F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103841; cv=none; b=FWZY+1/G11+md+LkLeHwBh3sKyAxo8tXKI4gQjkpww6qzBDBLT6hi7nrY1bNhZ1FY97tLUL19k5iCRRla2cNL+KbyF5YuWRe4YqT3Bw/lRjfcEF1q2/W9ImnuHG+3vsll/vbe7a7urjl/9tknzKxsD/XxvqKC/zsZlzvqvvPLCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103841; c=relaxed/simple;
	bh=PZswoHwHh08RXAOSXz79mPTMRJgPJSKtkrMr53So4jc=;
	h=Date:To:From:Subject:Message-Id; b=lCT9rExY9Vbe/tiacudFE6sKtffVNNd2o80300C6Wfb8iP23wuzjWW7mhYa5dqECVrHD2w4ByhKj+WyJEVJt+rRLRVcp7jTDlvX3O469QKa/X/WHrT7HCBkTZvM+27Fz3hR7+VxFvMQA+r91DG5fMlkFLRDisryavkO41m2ChIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tkdVziPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tkdVziPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A453AC2BD11;
	Fri, 26 Apr 2024 03:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103840;
	bh=PZswoHwHh08RXAOSXz79mPTMRJgPJSKtkrMr53So4jc=;
	h=Date:To:From:Subject:From;
	b=tkdVziPLiaQNQOUMvRimIe6aPpgGAw2tdGm151nNLGd1Rm9F9QaB2yM5NVcrLrEJm
	 bQfvCEaUviG1LFd/kPINlwLADRFgPR79tCZJfrqLCbnqLUzEzOUlIUGkMPYbwuCCzp
	 zJR57PWaBQR3lkQ782n9UwdMpA1xnUbhJGPwomKk=
Date: Thu, 25 Apr 2024 20:57:20 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-guard-around-pgd_offset_k-macro.patch removed from -mm tree
Message-Id: <20240426035720.A453AC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove guard around pgd_offset_k() macro
has been removed from the -mm tree.  Its filename was
     mm-remove-guard-around-pgd_offset_k-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: remove guard around pgd_offset_k() macro
Date: Sat, 16 Mar 2024 12:52:41 +0100

The last architecture redefining pgd_offset_k() was IA64 and it was
removed by commit cf8e8658100d ("arch: Remove Itanium (IA-64)
architecture")

There is no need anymore to guard generic version of pgd_offset_k()
with #ifndef pgd_offset_k

Link: https://lkml.kernel.org/r/59d3f47d5615d18cca1986f269be2fcb3df34556.1710589838.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/pgtable.h~mm-remove-guard-around-pgd_offset_k-macro
+++ a/include/linux/pgtable.h
@@ -149,9 +149,7 @@ static inline pgd_t *pgd_offset_pgd(pgd_
  * a shortcut which implies the use of the kernel's pgd, instead
  * of a process's
  */
-#ifndef pgd_offset_k
 #define pgd_offset_k(address)		pgd_offset(&init_mm, (address))
-#endif
 
 /*
  * In many cases it is known that a virtual address is mapped at PMD or PTE
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


