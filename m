From: akpm@linux-foundation.org
Subject: - ibmebus-uevent-support.patch removed from -mm tree
Date: Mon, 26 Mar 2007 12:51:34 -0700
Message-ID: <200703261951.l2QJpZEw028886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48358 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbXCZTwG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 15:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenkes@de.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ibmebus: uevent support
has been removed from the -mm tree.  Its filename was
     ibmebus-uevent-support.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: ibmebus: uevent support
From: Joachim Fenkes <fenkes@de.ibm.com>

This adds uevent support to ibmebus using the generic of_device_uevent()
function.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ibmebus.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/powerpc/kernel/ibmebus.c~ibmebus-uevent-support arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c~ibmebus-uevent-support
+++ a/arch/powerpc/kernel/ibmebus.c
@@ -460,6 +460,7 @@ static struct bus_attribute ibmebus_bus_
 
 struct bus_type ibmebus_bus_type = {
 	.name      = "ibmebus",
+	.uevent    = of_device_uevent,
 	.match     = ibmebus_bus_match,
 	.dev_attrs = ibmebus_dev_attrs,
 	.bus_attrs = ibmebus_bus_attrs
_

Patches currently in -mm which might be from fenkes@de.ibm.com are

git-powerpc.patch
ibmebus-uevent-support.patch
ibmebus-change-probe-remove-interface-from-using-loc-code-to-dt-path.patch
