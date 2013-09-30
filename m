From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-of_irqh-fix-warnings-when-config_of=n.patch removed from -mm
 tree
Date: Mon, 30 Sep 2013 11:57:24 -0700
Message-ID: <5249c994.u5ts4Wpjla+f3Oew%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3I3S5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 14:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com

Subject: [merged] include-linux-of_irqh-fix-warnings-when-config_of=n.patch removed from -mm tree
To: rob.herring@calxeda.com,grant.likely@linaro.org,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 11:57:24 -0700


The patch titled
     Subject: include/linux/of_irq.h: fix warnings when CONFIG_OF=n
has been removed from the -mm tree.  Its filename was
     include-linux-of_irqh-fix-warnings-when-config_of=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rob Herring <rob.herring@calxeda.com>
Subject: include/linux/of_irq.h: fix warnings when CONFIG_OF=n

Much of of_irq.h is needlessly ifdef'ed.  Clean this up and minimize the
amount ifdef'ed code.  This fixes some build warnings when CONFIG_OF is
not enabled (seen on i386 and x86_64):

include/linux/of_irq.h:82:7: warning: 'struct device_node' declared inside parameter list [enabled by default]
include/linux/of_irq.h:82:7: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/of_irq.h:87:47: warning: 'struct device_node' declared inside parameter list [enabled by default]

Compile tested on i386, sparc and arm.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/of_irq.h |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN include/linux/of_irq.h~include-linux-of_irqh-fix-warnings-when-config_of=n include/linux/of_irq.h
--- a/include/linux/of_irq.h~include-linux-of_irqh-fix-warnings-when-config_of=n
+++ a/include/linux/of_irq.h
@@ -1,8 +1,6 @@
 #ifndef __OF_IRQ_H
 #define __OF_IRQ_H
 
-#if defined(CONFIG_OF)
-struct of_irq;
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/irq.h>
@@ -10,14 +8,6 @@ struct of_irq;
 #include <linux/ioport.h>
 #include <linux/of.h>
 
-/*
- * irq_of_parse_and_map() is used by all OF enabled platforms; but SPARC
- * implements it differently.  However, the prototype is the same for all,
- * so declare it here regardless of the CONFIG_OF_IRQ setting.
- */
-extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
-
-#if defined(CONFIG_OF_IRQ)
 /**
  * of_irq - container for device_node/irq_specifier pair for an irq controller
  * @controller: pointer to interrupt controller device tree node
@@ -71,11 +61,17 @@ extern int of_irq_to_resource(struct dev
 extern int of_irq_count(struct device_node *dev);
 extern int of_irq_to_resource_table(struct device_node *dev,
 		struct resource *res, int nr_irqs);
-extern struct device_node *of_irq_find_parent(struct device_node *child);
 
 extern void of_irq_init(const struct of_device_id *matches);
 
-#endif /* CONFIG_OF_IRQ */
+#if defined(CONFIG_OF)
+/*
+ * irq_of_parse_and_map() is used by all OF enabled platforms; but SPARC
+ * implements it differently.  However, the prototype is the same for all,
+ * so declare it here regardless of the CONFIG_OF_IRQ setting.
+ */
+extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
+extern struct device_node *of_irq_find_parent(struct device_node *child);
 
 #else /* !CONFIG_OF */
 static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
_

Patches currently in -mm which might be from rob.herring@calxeda.com are

linux-next.patch

