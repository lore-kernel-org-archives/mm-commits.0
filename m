From: akpm@linux-foundation.org
Subject: [patch 6/6] scripts/dtc: fix '%zx' warning
Date: Thu, 31 Aug 2017 16:15:36 -0700
Message-ID: <59a89898.LTl77zNwjftCfUMR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52992 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdHaXPh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Aug 2017 19:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rmk+kernel@armlinux.org.uk, david@gibson.dropbear.id.au, frowand.list@gmail.com, mmarek@suse.cz, robh+dt@kernel.org, shuahkh@osg.samsung.com

From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: scripts/dtc: fix '%zx' warning

dtc uses an incorrect format specifier for printing a uint64_t value. 
uint64_t may be either 'unsigned long' or 'unsigned long long' depending
on the host architecture.

Fix this by using %llx and casting to unsigned long long, which ensures
that we always have a wide enough variable to print 64 bits of hex.

  HOSTCC  scripts/dtc/checks.o
scripts/dtc/checks.c: In function 'check_simple_bus_reg':
scripts/dtc/checks.c:876:2: warning: format '%zx' expects argument of type 'size_t', but argument 4 has type 'uint64_t' [-Wformat=]
  snprintf(unit_addr, sizeof(unit_addr), "%zx", reg);
  ^
scripts/dtc/checks.c:876:2: warning: format '%zx' expects argument of type 'size_t', but argument 4 has type 'uint64_t' [-Wformat=]

Link: http://lkml.kernel.org/r/20170829222034.GJ20805@n2100.armlinux.org.uk
Fixes: 828d4cdd012c ("dtc: check.c fix compile error")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/dtc/checks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/dtc/checks.c~scripts-dtc-fix-%zx-warning scripts/dtc/checks.c
--- a/scripts/dtc/checks.c~scripts-dtc-fix-%zx-warning
+++ a/scripts/dtc/checks.c
@@ -873,7 +873,7 @@ static void check_simple_bus_reg(struct
 	while (size--)
 		reg = (reg << 32) | fdt32_to_cpu(*(cells++));
 
-	snprintf(unit_addr, sizeof(unit_addr), "%zx", reg);
+	snprintf(unit_addr, sizeof(unit_addr), "%llx", (unsigned long long)reg);
 	if (!streq(unitname, unit_addr))
 		FAIL(c, dti, "Node %s simple-bus unit address format error, expected \"%s\"",
 		     node->fullpath, unit_addr);
_
