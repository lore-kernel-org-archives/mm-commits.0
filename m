From: akpm@linux-foundation.org
Subject: [merged]
 drivers-mfd-max8998c-fix-pointer-integer-size-mismatch-warning-in-max8998_i2c_get_driver_data.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:31 -0800
Message-ID: <52e2b84f.WR6svZVH2K3M0ZRj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, t.figa@samsung.com, sameo@linux.intel.com, broonie@linaro.org, dhowells@redhat.com

Subject: [merged] drivers-mfd-max8998c-fix-pointer-integer-size-mismatch-warning-in-max8998_i2c_get_driver_data.patch removed from -mm tree
To: dhowells@redhat.com,broonie@linaro.org,sameo@linux.intel.com,t.figa@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:31 -0800


The patch titled
     Subject: drivers/mfd/max8998.c: fix pointer-integer size mismatch warning in max8998_i2c_get_driver_data()
has been removed from the -mm tree.  Its filename was
     drivers-mfd-max8998c-fix-pointer-integer-size-mismatch-warning-in-max8998_i2c_get_driver_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: drivers/mfd/max8998.c: fix pointer-integer size mismatch warning in max8998_i2c_get_driver_data()

Fix up the following pointer-integer size mismatch warning in
max8998_i2c_get_driver_data():

	drivers/mfd/max8998.c: In function 'max8998_i2c_get_driver_data':
	drivers/mfd/max8998.c:178:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
		return (int)match->data;
		       ^

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Mark Brown <broonie@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/max8998.c~drivers-mfd-max8998c-fix-pointer-integer-size-mismatch-warning-in-max8998_i2c_get_driver_data drivers/mfd/max8998.c
--- a/drivers/mfd/max8998.c~drivers-mfd-max8998c-fix-pointer-integer-size-mismatch-warning-in-max8998_i2c_get_driver_data
+++ a/drivers/mfd/max8998.c
@@ -175,7 +175,7 @@ static inline int max8998_i2c_get_driver
 	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(max8998_dt_match, i2c->dev.of_node);
-		return (int)match->data;
+		return (int)(long)match->data;
 	}
 
 	return (int)id->driver_data;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
afs-proc-cells-and-rootcell-are-writeable.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

