From: akpm@linux-foundation.org
Subject: + ibmebus-uevent-support.patch added to -mm tree
Date: Thu, 15 Mar 2007 14:09:18 -0700
Message-ID: <200703152109.l2FL9Ica026485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40859 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbXCOVJq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:09:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fenkes@de.ibm.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     ibmebus: uevent support
has been added to the -mm tree.  Its filename is
     ibmebus-uevent-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ibmebus-whitespace-fixes.patch
ibmebus-dynamic-addition-removal-of-adapters-some-code-cleanup.patch
ibmebus-uevent-support.patch
