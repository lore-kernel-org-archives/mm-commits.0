From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:27 -0800
Message-ID: <52e2b84b.Dp7KyGbbHOCWDeTR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh+dt@kernel.org, grant.likely@linaro.org, dhowells@redhat.com

Subject: [merged] include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch removed from -mm tree
To: dhowells@redhat.com,grant.likely@linaro.org,robh+dt@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:27 -0800


The patch titled
     Subject: include/linux/of.h: make for_each_child_of_node() reference its args when CONFIG_OF=n
has been removed from the -mm tree.  Its filename was
     include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: include/linux/of.h: make for_each_child_of_node() reference its args when CONFIG_OF=n

Make for_each_child_of_node() reference its args when CONFIG_OF=n to avoid
warnings like:

	drivers/leds/leds-pwm.c:88:22: warning: unused variable 'node' [-Wunused-variable]
	  struct device_node *node = pdev->dev.of_node;
			      ^

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/of.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/of.h~include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n include/linux/of.h
--- a/include/linux/of.h~include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n
+++ a/include/linux/of.h
@@ -377,8 +377,13 @@ static inline bool of_have_populated_dt(
 	return false;
 }
 
+/* Kill an unused variable warning on a device_node pointer */
+static inline void __of_use_dn(const struct device_node *np)
+{
+}
+
 #define for_each_child_of_node(parent, child) \
-	while (0)
+	while (__of_use_dn(parent), __of_use_dn(child), 0)
 
 #define for_each_available_child_of_node(parent, child) \
 	while (0)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
afs-proc-cells-and-rootcell-are-writeable.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

