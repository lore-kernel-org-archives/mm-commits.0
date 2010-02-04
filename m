From: akpm@linux-foundation.org
Subject: + x86-agp-fix-agp_amd64_init-module-initialization-regression.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:12:53 -0800
Message-ID: <201002041812.o14ICrHZ013238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756717Ab0BDSNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, airlied@linux.ie, mingo@elte.hu, mitov@issp.bas.bg


The patch titled
     x86/agp: fix agp_amd64_init module initialization regression
has been added to the -mm tree.  Its filename is
     x86-agp-fix-agp_amd64_init-module-initialization-regression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86/agp: fix agp_amd64_init module initialization regression
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This fixes the regression introduced by commit
42590a75019a50012f25a962246498dead428433 ("x86/agp: Fix agp_amd64_init and
agp_amd64_cleanup").

The commit 61684ceaad4f65d1a9832c722f7bd5e7fc714de9 ("x86/agp: Fix
agp_amd64_init regression") fixed the above regression but there is still
a problem in the module initialization; when apg_amd64 is built as a
module, the GART IOMMU is not still initialized.

Reported-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Marin Mitov <mitov@issp.bas.bg>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd64-agp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/amd64-agp.c~x86-agp-fix-agp_amd64_init-module-initialization-regression drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~x86-agp-fix-agp_amd64_init-module-initialization-regression
+++ a/drivers/char/agp/amd64-agp.c
@@ -767,16 +767,19 @@ int __init agp_amd64_init(void)
 
 static int __init agp_amd64_mod_init(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return agp_bridges_found ? 0 : -ENODEV;
