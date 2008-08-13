From: akpm@linux-foundation.org
Subject: - matrox-maven-fix-a-broken-error-path.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:47 -0700
Message-ID: <200808130852.m7D8qluM008256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbYHMIx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, VANDROVE@vc.cvut.cz, krzysztof.h1@wp.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     matrox maven: fix a broken error path
has been removed from the -mm tree.  Its filename was
     matrox-maven-fix-a-broken-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matrox maven: fix a broken error path
From: Jean Delvare <khali@linux-fr.org>

I broke an error path with d03c21ec0be7787ff6b75dcf56c0e96209ccbfbd,
sorry about that.

The machine will crash if the i2c_attach_client() or maven_init_client()
calls fail, although nobody has yet reported this happening.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_maven.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/matrox/matroxfb_maven.c~matrox-maven-fix-a-broken-error-path drivers/video/matrox/matroxfb_maven.c
--- a/drivers/video/matrox/matroxfb_maven.c~matrox-maven-fix-a-broken-error-path
+++ a/drivers/video/matrox/matroxfb_maven.c
@@ -1266,7 +1266,7 @@ static int maven_detect_client(struct i2
 ERROR4:;
 	i2c_detach_client(new_client);
 ERROR3:;
-	kfree(new_client);
+	kfree(data);
 ERROR0:;
 	return err;
 }
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
applesmc-support-for-intel-imac.patch
applesmc-add-support-for-macbook-v3.patch
hwmon-adc124s501-generic-driver.patch
hwmon-adc124s501-generic-driver-update.patch
i5k_amb-provide-labels-for-temperature-sensors.patch
abituguru3-update-maintainers.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
resource-add-resource_type-and-ioresource_type_bits.patch
i2c-use-bcd2bin-bin2bcd.patch

