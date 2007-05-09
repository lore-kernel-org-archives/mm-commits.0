From: akpm@linux-foundation.org
Subject: - lguest-the-net-driver-two-net-bugfixes.patch removed from -mm tree
Date: Wed, 09 May 2007 02:43:38 -0700
Message-ID: <200705090943.l499hcKT020225@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbXEIJoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:44:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     lguest: two net bugfixes
has been removed from the -mm tree.  Its filename was
     lguest-the-net-driver-two-net-bugfixes.patch

This patch was dropped because it was folded into lguest-the-net-driver.patch

------------------------------------------------------
Subject: lguest: two net bugfixes
From: Rusty Russell <rusty@rustcorp.com.au>

1) Bridging via host is broken: we need to set "promisc" bit in MAC
   address published by the host so the guest sends us everything.
   Thanks James Morris for the report (I don't use bridging).

2) Lguest network device uses 0 to mean "noone at this slot".  It used to
   use 0xFF, and one spot was missed.  Minor: it just means we'll have a
   useless extra transmit for broadcast packets.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lguest_net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/lguest_net.c~lguest-the-net-driver-two-net-bugfixes drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c~lguest-the-net-driver-two-net-bugfixes
+++ a/drivers/net/lguest_net.c
@@ -249,7 +249,7 @@ static int lguestnet_close(struct net_de
 	struct lguestnet_info *info = dev->priv;
 
 	/* Clear all trace: others might deliver packets, we'll ignore it. */
-	memset(&info->peer[info->me], 0xFF, sizeof(info->peer[info->me]));
+	memset(&info->peer[info->me], 0, sizeof(info->peer[info->me]));
 
 	/* Deregister sg lists. */
 	hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma), 0);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
