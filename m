From: akpm@linux-foundation.org
Subject: - lguest-two-net-bugfixes-doc.patch removed from -mm tree
Date: Wed, 09 May 2007 02:44:28 -0700
Message-ID: <200705090944.l499iSl7020252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbXEIJok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     lguest: two net bugfixes
has been removed from the -mm tree.  Its filename was
     lguest-two-net-bugfixes-doc.patch

This patch was dropped because it was folded into lguest-the-documentation-example-launcher.patch

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

 Documentation/lguest/lguest.c |    4 ++++
 net/lguest_net.c              |    0 
 2 files changed, 4 insertions(+)

diff -puN Documentation/lguest/lguest.c~lguest-two-net-bugfixes-doc Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-two-net-bugfixes-doc
+++ a/Documentation/lguest/lguest.c
@@ -860,6 +860,10 @@ static void setup_tun_net(const char *ar
 
 	/* We are peer 0, ie. first slot. */
 	configure_device(ipfd, ifr.ifr_name, ip, dev->mem);
+
+	/* Set "promisc" bit: we want every single packet. */
+	*((u8 *)dev->mem) |= 0x1;
+
 	close(ipfd);
 
 	verbose("device %p: tun net %u.%u.%u.%u\n",
diff -puN drivers/net/lguest_net.c~lguest-two-net-bugfixes-doc drivers/net/lguest_net.c
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
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
