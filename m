From: akpm@linux-foundation.org
Subject: - arch-parisc-kernel-unalignedc-use-time_-macros.patch removed from -mm tree
Date: Fri, 16 May 2008 15:54:12 -0700
Message-ID: <200805162254.m4GMsCDt003218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758239AbYEPWyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     arch/parisc/kernel/unaligned.c: use time_* macros
has been removed from the -mm tree.  Its filename was
     arch-parisc-kernel-unalignedc-use-time_-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/parisc/kernel/unaligned.c: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.  

So use the time_after() macro, defined in linux/jiffies.h, which deals with
wrapping correctl

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/unaligned.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/parisc/kernel/unaligned.c~arch-parisc-kernel-unalignedc-use-time_-macros arch/parisc/kernel/unaligned.c
--- a/arch/parisc/kernel/unaligned.c~arch-parisc-kernel-unalignedc-use-time_-macros
+++ a/arch/parisc/kernel/unaligned.c
@@ -460,7 +460,8 @@ void handle_unaligned(struct pt_regs *re
 			goto force_sigbus;
 		}
 
-		if (unaligned_count > 5 && jiffies - last_time > 5*HZ) {
+		if (unaligned_count > 5 &&
+				time_after(jiffies, last_time + 5 * HZ)) {
 			unaligned_count = 0;
 			last_time = jiffies;
 		}
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

origin.patch
git-kbuild-fixes.patch

