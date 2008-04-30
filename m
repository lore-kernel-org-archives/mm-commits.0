From: akpm@linux-foundation.org
Subject: - thinkpad-acpi-fix-possible-null-pointer-dereference.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:46 -0700
Message-ID: <200804300550.m3U5okEC030153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758972AbYD3Fuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, hmh@hmh.eng.br, mm-commits@vger.kernel.org


The patch titled
     ThinkPad ACPI: fix possible NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     thinkpad-acpi-fix-possible-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ThinkPad ACPI: fix possible NULL pointer dereference
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix potential NULL pointer dereference if kstrdup failed

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/thinkpad_acpi.c~thinkpad-acpi-fix-possible-null-pointer-dereference drivers/misc/thinkpad_acpi.c
--- a/drivers/misc/thinkpad_acpi.c~thinkpad-acpi-fix-possible-null-pointer-dereference
+++ a/drivers/misc/thinkpad_acpi.c
@@ -5826,7 +5826,7 @@ static void __init get_thinkpad_model_da
 
 	tp->model_str = kstrdup(dmi_get_system_info(DMI_PRODUCT_VERSION),
 					GFP_KERNEL);
-	if (strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
+	if (tp->model_str && strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
 		kfree(tp->model_str);
 		tp->model_str = NULL;
 	}
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-acpi.patch
git-m32r.patch

