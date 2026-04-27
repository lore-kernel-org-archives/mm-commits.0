Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC593890F1
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 14:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777301756; cv=none; b=EzMGIdLx5SpVZ3NEWn637eJMZOPQKakmkBL+LqyaTIae8JHC+9bu7TVp+HLcVEVmnnwVCC6OKNQewBg2kcbr+HyQRbBWl1ihyrcnAURS1lxXnYti/UD71LAvMEAMoWN/zLHyiEVZb+g6k6nupeu+QrKnc6Oe1mJ+/Sex8Ctft6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777301756; c=relaxed/simple;
	bh=h0g8wWxNaCGYtQhWMRa4HTlk6NSywo1Q4ntIsG0tca4=;
	h=Date:To:From:Subject:Message-Id; b=UukG/kDmBH4faPCREpFx9dNdRA0y+4j+J00BNmoSyU+bbNImtOehAjYQpHodcAE30ev9nZtZDDBo47/g5rf+5MlHkmWoXl4EZhFcQzRyMMq+rsXhiMosQ6yE6Udyynn5PBaMIQ3mNRGRvjyjXacmq4PdBMOYR8PyaxrNSNYEiY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bBjlP2zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bBjlP2zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDE5C19425;
	Mon, 27 Apr 2026 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777301755;
	bh=h0g8wWxNaCGYtQhWMRa4HTlk6NSywo1Q4ntIsG0tca4=;
	h=Date:To:From:Subject:From;
	b=bBjlP2zpwnwivRCGsOLJSTedN8dDzaB3qr/AjyG7DXOZxX8i35KO88k9MsCN4m6Oy
	 N4jM2+cK24xeYBb0Smb1mc2H8/LHVnET739ySm5aCbORq8YC72kWAJJ1aLe6B5Fe2K
	 yYt8h5InsHX2nNLo7sWOhtBqcMLjhLb2NBS911gI=
Date: Mon, 27 Apr 2026 07:55:55 -0700
To: mm-commits@vger.kernel.org,npiggin@gmail.com,msalter@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,lkp@intel.com,david.laight.linux@gmail.com,david@kernel.org,dave@stgolabs.net,chmh0624@gmail.com,chleroy@kernel.org,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch added to mm-new branch
Message-Id: <20260427145555.BCDE5C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix
Date: Mon Apr 27 07:52:27 AM PDT 2026

fix powerpc

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202604271114.ebmzs1LE-lkp@intel.com/
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Min-Hsun Chang <chmh0624@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fixmap.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/include/asm/fixmap.h~include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix
+++ a/arch/powerpc/include/asm/fixmap.h
@@ -88,6 +88,9 @@ enum fixed_addresses {
 #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NCG
 #define FIXMAP_PAGE_IO	PAGE_KERNEL_NCG
 
+static inline void __set_fixmap(enum fixed_addresses idx,
+				phys_addr_t phys, pgprot_t flags);
+
 #include <asm-generic/fixmap.h>
 
 static inline void __set_fixmap(enum fixed_addresses idx,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch
proc-rewrite-next_tgid-fix.patch

