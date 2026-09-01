Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B723DB64D
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 01:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227770; cv=none; b=Ioe7JczMY0w9x44yw9k7HvPksgw8rxsEFcUTJI5QH8nKu/CN79/dzeGyw9SgQIWy2stmOKp30qNNv0nrHs+Dl0M3pLfUVrX++GJbR8mf17lpLRM4F8Wg4ZWKaYA2kmrXsIae89Wb+DuEp88HqARt76unv/4xB09WixRzGFCD1Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227770; c=relaxed/simple;
	bh=Xnmg1sP2A879hJhXnycWJgOQaKY9//moTdcZjfDAImw=;
	h=Date:To:From:Subject:Message-Id; b=KiIuCkOVUVjUydhfM3AKKPpSoerpPjeX7NuO+VSZ6qfnHD0sEvNDAXeRBbzNYh1GiILpMDrQwKIUSOeHwP2nBG9DcM9cwwnrIgCiHYtbAZar/w+RKJQFip9SlRZBOxb78zcmUTRTF5/jpfoCAqON0FTO+RoQKDHuNn5lvyR6gfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZBrfoROA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZBrfoROA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445041F00ADB;
	Tue,  1 Sep 2026 01:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788227752;
	bh=AhWZElnEwoCu8LRziKRcqbiAUqdkAOPed/PNuvvLG/c=;
	h=Date:To:From:Subject;
	b=ZBrfoROA0lQPYCtuhevkflsF7cwlT+bVaAzlWS2aMQo/JbrolMHfRnHc4wKWlktdT
	 w23yG4Jt28BWuN03Lh+W4X4FEbXT/1yi7OY1oEwHmLMvW6DVRnqSD1br9XxONgL9Bg
	 OHcqAWViuTuu5ffHbP7UOKvhv+/czY0nxmRa+UAU=
Date: Mon, 31 Aug 2026 18:55:51 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-mm-stop-using-pgd_error.patch added to mm-new branch
Message-Id: <20260901015552.445041F00ADB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh/mm: stop using pgd_ERROR()
has been added to the -mm mm-new branch.  Its filename is
     sh-mm-stop-using-pgd_error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-mm-stop-using-pgd_error.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: sh/mm: stop using pgd_ERROR()
Date: Mon, 31 Aug 2026 11:13:29 +0530

Stop using pgd_ERROR() in __get_pte_phys() when page table entry is
already known to be empty.

Link: https://lore.kernel.org/20260831054331.625505-8-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/sh/mm/init.c~sh-mm-stop-using-pgd_error
+++ a/arch/sh/mm/init.c
@@ -52,10 +52,8 @@ static pte_t *__get_pte_phys(unsigned lo
 	pmd_t *pmd;
 
 	pgd = pgd_offset_k(addr);
-	if (pgd_none(*pgd)) {
-		pgd_ERROR(*pgd);
+	if (pgd_none(*pgd))
 		return NULL;
-	}
 
 	p4d = p4d_alloc(NULL, pgd, addr);
 	if (unlikely(!p4d)) {
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-make-ptval_to_str-generally-available.patch
mm-stop-using-pxd_error.patch
loongarch-mm-stop-using-pte_error.patch
parisc-mm-directly-use-generic-_clear_bad.patch
sh-mm-stop-using-pte_error.patch
sh-mm-stop-using-_error.patch
sh-mm-stop-using-pgd_error.patch
mm-drop-pxd_error.patch

