From: akpm@linux-foundation.org
Subject: [merged] pinctrl-fix-pxa2xxc-build-warnings.patch removed
 from -mm tree
Date: Tue, 04 Feb 2020 10:40:47 -0800
Message-ID: <20200204184047.Lr1Ovu39g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbgBDSks (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, robert.jarzmik@free.fr


The patch titled
     Subject: pinctrl: fix pxa2xx.c build warnings
has been removed from the -mm tree.  Its filename was
     pinctrl-fix-pxa2xxc-build-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: pinctrl: fix pxa2xx.c build warnings

Add #include of <linux/pinctrl/machine.h> to fix build
warnings in pinctrl-pxa2xx.c.  Fixes these warnings:

In file included from ../drivers/pinctrl/pxa/pinctrl-pxa2xx.c:24:0:
../drivers/pinctrl/pxa/../pinctrl-utils.h:36:8: warning: `enum pinctrl_map_type' declared inside parameter list [enabled by default]
   enum pinctrl_map_type type);
        ^
../drivers/pinctrl/pxa/../pinctrl-utils.h:36:8: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Link: http://lkml.kernel.org/r/0024542e-cba9-8f13-6c18-32d0050a6007@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pinctrl/pxa/pinctrl-pxa2xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/pxa/pinctrl-pxa2xx.c~pinctrl-fix-pxa2xxc-build-warnings
+++ a/drivers/pinctrl/pxa/pinctrl-pxa2xx.c
@@ -10,6 +10,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/module.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinconf.h>
 #include <linux/pinctrl/pinconf-generic.h>
 #include <linux/pinctrl/pinmux.h>
_

Patches currently in -mm which might be from rdunlap@infradead.org are
