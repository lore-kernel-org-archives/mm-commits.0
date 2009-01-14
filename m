From: akpm@linux-foundation.org
Subject: + alpha-nautilus-fix-compile-failure-with-gcc-43.patch added to -mm tree
Date: Wed, 14 Jan 2009 09:47:37 -0800
Message-ID: <200901141747.n0EHlbII020736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555AbZANRsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 12:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, dsd@gentoo.org, rth@twiddle.net


The patch titled
     alpha: nautilus - fix compile failure with gcc-4.3
has been added to the -mm tree.  Its filename is
     alpha-nautilus-fix-compile-failure-with-gcc-43.patch

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
Subject: alpha: nautilus - fix compile failure with gcc-4.3
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

init_srm_irq() deals with irq's #16 and above, but size of irq_desc
array on nautilus and some other system types is 16. So gcc-4.3
complains that "array subscript is above array bounds", even though
this function is never called on those systems.

This adds a check for NR_IRQS <= 16, which effectively optimizes
init_srm_irq() code away on problematic platforms.

Thanks to Daniel Drake <dsd@gentoo.org> for detailed analysis
of the problem.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/irq_srm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/alpha/kernel/irq_srm.c~alpha-nautilus-fix-compile-failure-with-gcc-43 arch/alpha/kernel/irq_srm.c
--- a/arch/alpha/kernel/irq_srm.c~alpha-nautilus-fix-compile-failure-with-gcc-43
+++ a/arch/alpha/kernel/irq_srm.c
@@ -63,6 +63,8 @@ init_srm_irqs(long max, unsigned long ig
 {
 	long i;
 
+	if (NR_IRQS <= 16)
+		return;
 	for (i = 16; i < max; ++i) {
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

alpha-fix-vmalloc-breakage.patch
alpha-fix-vmalloc-breakage-fix.patch
alpha-nautilus-fix-compile-failure-with-gcc-43.patch
alpha-nautilus-fix-hang-on-boot.patch
alpha-fix-rtc-on-marvel.patch
alpha-gitignore-vmlinuxlds.patch
alpha-make-pte_alloc_one_kernel-inline.patch
make-sure-nobodys-leaking-resources.patch

