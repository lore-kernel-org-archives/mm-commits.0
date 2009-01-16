From: akpm@linux-foundation.org
Subject: [merged] alpha-nautilus-fix-compile-failure-with-gcc-43.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:37 -0800
Message-ID: <200901161917.n0GJHbB3026224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936675AbZAPTSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, dsd@gentoo.org, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: nautilus - fix compile failure with gcc-4.3
has been removed from the -mm tree.  Its filename was
     alpha-nautilus-fix-compile-failure-with-gcc-43.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
make-sure-nobodys-leaking-resources.patch

