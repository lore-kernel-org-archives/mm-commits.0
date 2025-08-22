Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C761A20322
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 22:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755900561; cv=none; b=Nh4vNKOPPLM8tDs1cFZ3EYhWiVqW9eiLSbxtRxuO0jpngm0WIAAQZAniFCTh0jNMoBIfGu0xQ+qX00+i9DKZ3WUX88LjwS+qoG0XBDRRf7HKBnt41WsFEbPK8GthfMRQiTrocuw7DjuWn4/BYizs/0G+jJop8ZJbYY1dIP9Du50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755900561; c=relaxed/simple;
	bh=Q+DAHj1zMCMpZBnuZeXo1tk4YKg8L1w/ivZDEl93Qso=;
	h=Date:To:From:Subject:Message-Id; b=spBGkKPLLDJIWZNFmnDKNJ3QRXbYdTL9KkRmEYDaX2qXFVZMdVv/7PY9cx5injHGbkTgHXpIEFMUv7dZ7yBrZthtyU3FsFRqIxuY6eiEehnYDsfnt99Gs06iJyrc4LQ3Ktyq/zaCKxZud3b51VJaM6aCWwWDz3B4GIZbT6b0DTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lcqC70ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lcqC70ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469A2C4CEED;
	Fri, 22 Aug 2025 22:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755900561;
	bh=Q+DAHj1zMCMpZBnuZeXo1tk4YKg8L1w/ivZDEl93Qso=;
	h=Date:To:From:Subject:From;
	b=lcqC70nyTSkefkstr2QLLz0hla1P7HU/aY5PLYsPYg+89gg0suune4qfJavIpknx/
	 iMGNZzJlVo5WFad9wwzuRSXfZlp6CxKjn0Lb0UplI3C0auElUpC+Ajbs+2lVk0iqGx
	 81S1A5slIzDVaiXq2PCJKdjxXEHkmGtexxHNeZvU=
Date: Fri, 22 Aug 2025 15:09:20 -0700
To: mm-commits@vger.kernel.org,rmclure@linux.ibm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,lkp@intel.com,aou@eecs.berkeley.edu,alex@ghiti.fr,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix.patch added to mm-unstable branch
Message-Id: <20250822220921.469A2C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix
Date: Fri Aug 22 03:05:44 PM PDT 2025

fix arch/riscv/include/asm/pgtable.h
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508230551.qiEQu04P-lkp@intel.com/

Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix
+++ a/arch/riscv/include/asm/pgtable.h
@@ -948,7 +948,7 @@ static inline pud_t pudp_huge_get_and_cl
 {
 	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
 
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, address, pud);
 
 	return pud;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix.patch
lib-sys_info-handle-sys_info_mask==0-case-fix.patch

