From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 22/67] pinctrl: fix pxa2xx.c build warnings
Date: Mon, 03 Feb 2020 17:34:55 -0800
Message-ID: <20200204013455.c6BbkYuNV%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgBDBe4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:56 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, rdunlap@infradead.org, robert.jarzmik@free.fr, torvalds@linux-foundation.org

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
