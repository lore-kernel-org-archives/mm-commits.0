Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2DB3EFFD4
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227781; cv=none; b=lX9mUGd14cA5ZKxjlo9DxgybGrINsMn91P8Js+AU69+7AALKrx85b5+ghDWgf6ojfsB1j2hcFNgmjxHRgSKLLy7gLdUCK10rdYeApHa2B7m2l9LQMClGD8RqK5BfDBDl6FCaSfjr4qpWgwtn52uE3COc1G5bt777SeOnB6vJmdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227781; c=relaxed/simple;
	bh=XB/cUoMUPhWAqOF0oVEo/IWnO2pv95iPtPJgMcdvM9g=;
	h=Date:To:From:Subject:Message-Id; b=imqHvyEGq4z+ff4hdKMSJ+EtaxQBVAC7fOyfRBg2h0ZYDyPzvFisWMrUQLjRTkZUe9wlUWPvo/UX/xwO5GxYw8NQhUmA6syYHpOgEqJiKO/PTK6I+bKGroWWmni7yQO3aQgQLRjv90rDdvp5Jms2cj2IWeEOr1kQLcbEU+WkslU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uM1AIxwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uM1AIxwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D481F00ACF;
	Tue,  1 Sep 2026 01:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788227747;
	bh=zZ+vt6w393eiX9abcpqDrZrTsxpebClcda0mWfiX2GM=;
	h=Date:To:From:Subject;
	b=uM1AIxwSCr0AAtSAX6gvudxAd9qgCUpY5CoT3D79eO66gMBjfjgQZwSs3H5R4Wrl5
	 l8LvQlkSdy5l6E6klibeN6RpU8rjaCO3nRkZBLIVhi+dKkWxZ3nJGk6GNalswHjfZI
	 loy7BVUTPIGPfTleVzNCKbcKpW20lQJCpOECr9oA=
Date: Mon, 31 Aug 2026 18:55:47 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-mm-stop-using-pte_error.patch added to mm-new branch
Message-Id: <20260901015547.B4D481F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh/mm: stop using pte_ERROR()
has been added to the -mm mm-new branch.  Its filename is
     sh-mm-stop-using-pte_error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-mm-stop-using-pte_error.patch

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
Subject: sh/mm: stop using pte_ERROR()
Date: Mon, 31 Aug 2026 11:13:27 +0530

Directly use pr_err() in set_pte_phys() and drop pte_ERROR() which helps
in eventually dropping pte_ERROR() macro across the tree.  In this new
printing __FILE__ and __LINE__ has been dropped because they are always
the same and don't really add any value.  Besides ptrval_to_str() has been
able to handle different PTE representation with and without CONFIG_X2TLB,
which helped in unifying error message printing.

Link: https://lore.kernel.org/20260831054331.625505-6-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

 arch/sh/include/asm/pgtable_32.h |    5 -----
 arch/sh/mm/init.c                |    6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/sh/include/asm/pgtable_32.h~sh-mm-stop-using-pte_error
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -401,14 +401,9 @@ static inline unsigned long pmd_page_vad
 #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
 #ifdef CONFIG_X2TLB
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
-	       &(e), (e).pte_high, (e).pte_low)
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
 #else
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
 #endif
--- a/arch/sh/mm/init.c~sh-mm-stop-using-pte_error
+++ a/arch/sh/mm/init.c
@@ -84,7 +84,11 @@ static void set_pte_phys(unsigned long a
 
 	pte = __get_pte_phys(addr);
 	if (!pte_none(*pte)) {
-		pte_ERROR(*pte);
+		char str[PTVAL_STR_MAX];
+
+		ptval_to_str(str, pte_val(*pte));
+		pr_err("unexpected set PTE at %lx in %s: bad pte %p(%s).\n",
+			addr, __func__, pte, str);
 		return;
 	}
 
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

