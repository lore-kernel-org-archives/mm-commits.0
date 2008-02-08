From: akpm@linux-foundation.org
Subject: - arch-powerpc-platforms-82xx-add-missing-of_node_put.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:42 -0800
Message-ID: <200802080810.m188ANbo014933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761420AbYBHITn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     arch/powerpc/platforms/82xx: Add missing of_node_put
has been removed from the -mm tree.  Its filename was
     arch-powerpc-platforms-82xx-add-missing-of_node_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/powerpc/platforms/82xx: Add missing of_node_put
From: Julia Lawall <julia@diku.dk>


Of_get_parent and of_find_compatible_node do a of_node_get, and thus a
corresponding of_code_put is needed in both the error case and the normal
return case.

The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* E = \(of_get_parent\|of_find_compatible_node\)(...);
  if (E == NULL) S
  ... when != of_node_put(...,(T1)E,...)
      when != if (E != NULL) { ... of_node_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != of_node_put(...,(T2)E,...)
        when != if (E != NULL) { ... of_node_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/82xx/mpc8272_ads.c |    3 +--
 arch/powerpc/platforms/82xx/pq2fads.c     |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/82xx/mpc8272_ads.c~arch-powerpc-platforms-82xx-add-missing-of_node_put arch/powerpc/platforms/82xx/mpc8272_ads.c
--- a/arch/powerpc/platforms/82xx/mpc8272_ads.c~arch-powerpc-platforms-82xx-add-missing-of_node_put
+++ a/arch/powerpc/platforms/82xx/mpc8272_ads.c
@@ -134,13 +134,12 @@ static void __init mpc8272_ads_setup_arc
 	}
 
 	bcsr = of_iomap(np, 0);
+	of_node_put(np);
 	if (!bcsr) {
 		printk(KERN_ERR "Cannot map BCSR registers\n");
 		return;
 	}
 
-	of_node_put(np);
-
 	clrbits32(&bcsr[1], BCSR1_RS232_EN1 | BCSR1_RS232_EN2 | BCSR1_FETHIEN);
 	setbits32(&bcsr[1], BCSR1_FETH_RST);
 
diff -puN arch/powerpc/platforms/82xx/pq2fads.c~arch-powerpc-platforms-82xx-add-missing-of_node_put arch/powerpc/platforms/82xx/pq2fads.c
--- a/arch/powerpc/platforms/82xx/pq2fads.c~arch-powerpc-platforms-82xx-add-missing-of_node_put
+++ a/arch/powerpc/platforms/82xx/pq2fads.c
@@ -130,13 +130,12 @@ static void __init pq2fads_setup_arch(vo
 	}
 
 	bcsr = of_iomap(np, 0);
+	of_node_put(np);
 	if (!bcsr) {
 		printk(KERN_ERR "Cannot map BCSR registers\n");
 		return;
 	}
 
-	of_node_put(np);
-
 	/* Enable the serial and ethernet ports */
 
 	clrbits32(&bcsr[1], BCSR1_RS232_EN1 | BCSR1_RS232_EN2 | BCSR1_FETHIEN);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
