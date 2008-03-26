From: akpm@linux-foundation.org
Subject: - arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:39:48 -0700
Message-ID: <200803261839.m2QIdmjO028566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758571AbYCZSkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, benh@kernel.crashing.org, paulus@samba.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     arch/powerpc/platforms/iseries/pci.c: use time_* macros
has been removed from the -mm tree.  Its filename was
     arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/powerpc/platforms/iseries/pci.c: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.

So use the time_after() macro, defined in linux/jiffies.h, which deals with
wrapping correctly.

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/iseries/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/iseries/pci.c~arch-powerpc-platforms-iseries-pcic-use-time_-macros arch/powerpc/platforms/iseries/pci.c
--- a/arch/powerpc/platforms/iseries/pci.c~arch-powerpc-platforms-iseries-pcic-use-time_-macros
+++ a/arch/powerpc/platforms/iseries/pci.c
@@ -23,6 +23,7 @@
 
 #undef DEBUG
 
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/string.h>
@@ -586,7 +587,7 @@ static inline struct device_node *xlate_
 		static unsigned long last_jiffies;
 		static int num_printed;
 
-		if ((jiffies - last_jiffies) > 60 * HZ) {
+		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
 			last_jiffies = jiffies;
 			num_printed = 0;
 		}
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

git-powerpc.patch
arch-ia64-kernel-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
git-net.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
fix-indentation.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch

