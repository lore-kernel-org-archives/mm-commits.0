Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2554A3128B6
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334318; cv=none; b=I/XT+gSyVYCtfJsCiW4F4JMeYnJhP3tTOZEAjSFlMw7JmuDguuDBxnxBdw97LBBA7+agy+ipa186IM6yvg9YTYIxNp+H37xReAzoQKakg99g73DZ/4N5nflFLvxR//5ZCHORBOFdt7D31HgpFXSSqevlsZK6hi9ru7edwR+H/1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334318; c=relaxed/simple;
	bh=qPCZVomFjX24xIP3cFvQ4mSO64mTB0OJNYGQFKuoyD0=;
	h=Date:To:From:Subject:Message-Id; b=g27iEiNG0LAXXCMpMxFnWxzccRf1V+F/s51kKf8/SMDHTX28sr07yk3YoGXqNP6KCYTsj90oBy9LxRlEKUKuiWKIY5WhYMmvk7CEwDtfLwehPl8K6VN3h8Myvq+pdm4Zs35XHFPEJS6/zIUmpTV1Ogeikq0ZuP2clfsNUStc48c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fWjulUVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fWjulUVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791431F0089E;
	Wed,  7 Oct 2026 00:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334315;
	bh=PZMVnwHC/aliopo42LKvCDeCp7mgkTfjdrX4cML3T3Q=;
	h=Date:To:From:Subject;
	b=fWjulUVzBujV4Ec8zVEuMVYcZ2q9EtiJJ8F5Aj2Yo8Y8/BURxkMzJyIfk+6IRMiwq
	 ocyWAXdB0h4Qwbk7akRrfy/Tl8sgPFfBOK8p3lyGKisaaBLPihGsjBHrTfoNefvW46
	 CzQ5soO4hq9ohpAK/XIGrvjfe1RPw78yErwJxdU4=
Date: Tue, 06 Oct 2026 17:51:55 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-stop-using-_error.patch removed from -mm tree
Message-Id: <20261007005155.791431F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh/mm: stop using [p4d|pud|pmd]_ERROR()
has been removed from the -mm tree.  Its filename was
     sh-mm-stop-using-_error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: sh/mm: stop using [p4d|pud|pmd]_ERROR()
Date: Mon, 31 Aug 2026 11:13:28 +0530

Stop using [p4d|pud|pmd]_ERROR() in __get_pte_phys() as the pgtable entries
are known to be NULL and hence could not really be accessed.

Link: https://lore.kernel.org/20260831054331.625505-7-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: WANG Xuerui <kernel@xen0n.name>
---

 arch/sh/mm/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sh/mm/init.c~sh-mm-stop-using-_error
+++ a/arch/sh/mm/init.c
@@ -59,19 +59,19 @@ static pte_t *__get_pte_phys(unsigned lo
 
 	p4d = p4d_alloc(NULL, pgd, addr);
 	if (unlikely(!p4d)) {
-		p4d_ERROR(*p4d);
+		pr_err("allocating p4d table failed\n");
 		return NULL;
 	}
 
 	pud = pud_alloc(NULL, p4d, addr);
 	if (unlikely(!pud)) {
-		pud_ERROR(*pud);
+		pr_err("allocating pud table failed\n");
 		return NULL;
 	}
 
 	pmd = pmd_alloc(NULL, pud, addr);
 	if (unlikely(!pmd)) {
-		pmd_ERROR(*pmd);
+		pr_err("allocating pmd table failed\n");
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-constify-arguments-in-default-pxdp_get.patch
arm64-mm-move-__check_safe_pte_update.patch
arm64-mm-standardize-printing-for-pgtable-entries.patch

