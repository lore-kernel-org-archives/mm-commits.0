Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C920719B
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845966; cv=none; b=TWaXd2CVcx6qplQpVroZS/ntuPQWM696tEwf29xvPY8RkzxgfHXgpjU1aCf5hCoTvYbfIPA1uSvpAR00gNq8bRlqZrORHg/IQ6MuFNa9hKuhq0KC2UBB/4fTDCA89b1GrbfrkJlJCFjsb6gKEaV9RzrJBOch9JkmjwK5m3NPZU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845966; c=relaxed/simple;
	bh=wMz2QaCIlXlrgN5DAQWn/iGYxhTxPPkA58cEISnYR2M=;
	h=Date:To:From:Subject:Message-Id; b=ULzi32SRrJI8rAkUlaldVUa2yGAOFPt76+pGKAJBvjDBbHnJPJY6vMoraWC6TcCnmCLnPHLYyi+nKn3XSCjqwyAbT51Aluiv5P4VsLXJvgwBnGpyg9wOfttH93rJjxnomIyIRhXFfTPGxKs57YCD8iAePaG4FoG+oykIS4DDviY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HHSyUvBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HHSyUvBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C10C2BBFC;
	Thu, 20 Jun 2024 01:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845966;
	bh=wMz2QaCIlXlrgN5DAQWn/iGYxhTxPPkA58cEISnYR2M=;
	h=Date:To:From:Subject:From;
	b=HHSyUvBPeFYKsM6uzg5WxtUtu/jrY4Pvi+cQXICZafCaZ38b4Jf2QsMgrn9l0UjxJ
	 MLqsVCryTZKdLJ6QH/CTXCrr0FPocGeDGcreCaI4shbcfWT332qU5daA9nyuEM+pNA
	 dCa2Ct7iPJqfKr9qBB0i2YkaTRItgIFYHUIIFJ+M=
Date: Wed, 19 Jun 2024 18:12:45 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-redefine-max_order-sanely.patch added to mm-nonmm-unstable branch
Message-Id: <20240620011246.34C10C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: redefine MAX_ORDER sanely
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-redefine-max_order-sanely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-redefine-max_order-sanely.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: redefine MAX_ORDER sanely
Date: Wed, 19 Jun 2024 15:49:06 +0800

Patch series "Fix GDB command error".

This patchset fixes some GDB command errors.

1. Since memory layout of AARCH64 has been changed, we need to modify
   the layout in GDB scripts as well.

2. Fix pool_index naming of stackdepot.


This patch (of 6):

Change the definition of MAX_ORDER to be inclusive.

Link: https://lkml.kernel.org/r/20240619074911.100434-1-kuan-ying.lee@canonical.com
Link: https://lkml.kernel.org/r/20240619074911.100434-2-kuan-ying.lee@canonical.com
Fixes: 23baf831a32c ("mm, treewide: redefine MAX_ORDER sanely")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-redefine-max_order-sanely
+++ a/scripts/gdb/linux/mm.py
@@ -59,9 +59,9 @@ class aarch64_page_ops():
         if str(constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER).isdigit():
             self.MAX_ORDER = constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
         else:
-            self.MAX_ORDER = 11
+            self.MAX_ORDER = 10
 
-        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_ORDER - 1)
+        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_ORDER)
         self.PFN_SECTION_SHIFT = self.SECTION_SIZE_BITS - self.PAGE_SHIFT
         self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
         self.PAGES_PER_SECTION = 1 << self.PFN_SECTION_SHIFT
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are

scripts-gdb-redefine-max_order-sanely.patch
scripts-gdb-rework-module-va-range.patch
scripts-gdb-change-the-layout-of-vmemmap.patch
scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch
scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch
scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch

