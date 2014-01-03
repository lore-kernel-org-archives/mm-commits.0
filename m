From: akpm@linux-foundation.org
Subject: +
 drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch added to -mm tree
Date: Fri, 03 Jan 2014 14:44:16 -0800
Message-ID: <52c73d40.anN9+Zk1+yGAL+dN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaACWoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 17:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sameo@linux.intel.com, anilkumar@ti.com, dhowells@redhat.com

Subject: + drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch added to -mm tree
To: dhowells@redhat.com,anilkumar@ti.com,sameo@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 14:44:16 -0800


The patch titled
     Subject: drivers/mfd/tps65217.c: fix pointer-integer size mismatch warning in tps65217_probe()
has been added to the -mm tree.  Its filename is
     drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch

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
Subject: drivers/mfd/tps65217.c: fix pointer-integer size mismatch warning in tps65217_probe()

Fix up the following pointer-integer size mismatch warning in tps65217_probe():

	drivers/mfd/tps65217.c: In function 'tps65217_probe':
	drivers/mfd/tps65217.c:173:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	   chip_id = (unsigned int)match->data;
		     ^

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/tps65217.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/tps65217.c~drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe drivers/mfd/tps65217.c
--- a/drivers/mfd/tps65217.c~drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe
+++ a/drivers/mfd/tps65217.c
@@ -170,7 +170,7 @@ static int tps65217_probe(struct i2c_cli
 				"Failed to find matching dt id\n");
 			return -EINVAL;
 		}
-		chip_id = (unsigned int)match->data;
+		chip_id = (unsigned int)(unsigned long)match->data;
 		status_off = of_property_read_bool(client->dev.of_node,
 					"ti,pmic-shutdown-controller");
 	}
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

