From: akpm@linux-foundation.org
Subject: +
 include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch added to -mm tree
Date: Fri, 03 Jan 2014 14:44:13 -0800
Message-ID: <52c73d3d.uC0HOJN5Pp1X240R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaACWoO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 17:44:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh+dt@kernel.org, grant.likely@linaro.org, dhowells@redhat.com

Subject: + include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch added to -mm tree
To: dhowells@redhat.com,grant.likely@linaro.org,robh+dt@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 14:44:13 -0800


The patch titled
     Subject: include/linux/of.h: make for_each_child_of_node() reference its args when CONFIG_OF=n
has been added to the -mm tree.  Its filename is
     include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch
drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch
drivers-mfd-max8998c-fix-pointer-integer-size-mismatch-warning-in-max8998_i2c_get_driver_data.patch
drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch
drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe.patch
drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch
documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit.patch
lib-assoc_arrayc-remove-global-variable.patch
afs-proc-cells-and-rootcell-are-writeable.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

