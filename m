From: akpm@linux-foundation.org
Subject: - x86-olpc-add-one-laptop-per-child-architecture-support-fix-3.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:29:19 -0700
Message-ID: <200804290529.m3T5TJ9p003084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbYD2F35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, ak@suse.de, dilinger@debian.org, dwmw2@infradead.org, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     OLPC: only check for OFW signature on VSA-less Geodes
has been removed from the -mm tree.  Its filename was
     x86-olpc-add-one-laptop-per-child-architecture-support-fix-3.patch

This patch was dropped because it was folded into x86-olpc-add-one-laptop-per-child-architecture-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OLPC: only check for OFW signature on VSA-less Geodes
From: Andres Salomon <dilinger@queued.net>

The OFW sig check requires an ioremap that is dangerous on non-OLPC systems. 
Long term, we should be getting the signature from the device tree
(/openprom/model), but for right now just limit the check to only run on a
subset of Geode (GX2/LX) systems.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Acked-By: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/olpc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/x86/kernel/olpc.c~x86-olpc-add-one-laptop-per-child-architecture-support-fix-3 arch/x86/kernel/olpc.c
--- a/arch/x86/kernel/olpc.c~x86-olpc-add-one-laptop-per-child-architecture-support-fix-3
+++ a/arch/x86/kernel/olpc.c
@@ -211,6 +211,10 @@ static int __init olpc_init(void)
 {
 	unsigned char *romsig;
 
+	/* The ioremap check is dangerous; limit what we run it on */
+	if (!is_geode() || geode_has_vsa2())
+		return 0;
+
 	spin_lock_init(&ec_lock);
 
 	romsig = ioremap(0xffffffc0, 16);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-3.patch

