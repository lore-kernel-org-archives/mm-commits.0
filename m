From: akpm@linux-foundation.org
Subject: +
 drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe.patch added to -mm tree
Date: Fri, 03 Jan 2014 14:44:17 -0800
Message-ID: <52c73d41.DT/8cZVCQMGZSX5r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaACWoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 17:44:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ldewangan@nvidia.com, broonie@opensource.wolfsonmicro.com, dhowells@redhat.com

Subject: + drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe.patch added to -mm tree
To: dhowells@redhat.com,broonie@opensource.wolfsonmicro.com,ldewangan@nvidia.com
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 14:44:17 -0800


The patch titled
     Subject: drivers/regulator/tps62360-regulator.c: fix pointer-integer size mismatch warning in tps62360_probe()
has been added to the -mm tree.  Its filename is
     drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe.patch

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
Subject: drivers/regulator/tps62360-regulator.c: fix pointer-integer size mismatch warning in tps62360_probe()

Fix up the following pointer-integer size mismatch warning in tps62360_probe():

	drivers/regulator/tps62360-regulator.c: In function 'tps62360_probe':
	drivers/regulator/tps62360-regulator.c:363:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	   chip_id = (int)match->data;
		     ^

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/tps62360-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/regulator/tps62360-regulator.c~drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe drivers/regulator/tps62360-regulator.c
--- a/drivers/regulator/tps62360-regulator.c~drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe
+++ a/drivers/regulator/tps62360-regulator.c
@@ -360,7 +360,7 @@ static int tps62360_probe(struct i2c_cli
 			dev_err(&client->dev, "Error: No device match found\n");
 			return -ENODEV;
 		}
-		chip_id = (int)match->data;
+		chip_id = (int)(long)match->data;
 		if (!pdata)
 			pdata = of_get_tps62360_platform_data(&client->dev);
 	} else if (id) {
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

