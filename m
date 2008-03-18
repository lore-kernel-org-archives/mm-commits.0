From: akpm@linux-foundation.org
Subject: + arch-parisc-kernel-unalignedc-use-time_-macros.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:19:32 -0700
Message-ID: <200803180419.m2I4JWfB013769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbYCREUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:20:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     arch/parisc/kernel/unaligned.c: use time_* macros
has been added to the -mm tree.  Its filename is
     arch-parisc-kernel-unalignedc-use-time_-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/parisc/kernel/unaligned.c: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.  

So use the time_after() macro, defined in linux/jiffies.h, which deals with
wrapping correctl

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/unaligned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/kernel/unaligned.c~arch-parisc-kernel-unalignedc-use-time_-macros arch/parisc/kernel/unaligned.c
--- a/arch/parisc/kernel/unaligned.c~arch-parisc-kernel-unalignedc-use-time_-macros
+++ a/arch/parisc/kernel/unaligned.c
@@ -460,7 +460,7 @@ void handle_unaligned(struct pt_regs *re
 			goto force_sigbus;
 		}
 
-		if (unaligned_count > 5 && jiffies - last_time > 5*HZ) {
+		if (unaligned_count > 5 && time_after(jiffies, last_time + 5 * HZ)) {
 			unaligned_count = 0;
 			last_time = jiffies;
 		}
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-wireless-atmelc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch
fix-indentation.patch

