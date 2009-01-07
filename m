From: akpm@linux-foundation.org
Subject: - edac-fix-mpc85xx-and-add-mpc8536-mpc8560.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:51 -0800
Message-ID: <200901072220.n07MKpr5020030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762128AbZAGWmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:42:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galak@kernel.crashing.org, djiang@mvista.com, dougthompson@xmission.com, ncase@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     edac: fix mpc85xx and add mpc8536 mpc8560
has been removed from the -mm tree.  Its filename was
     edac-fix-mpc85xx-and-add-mpc8536-mpc8560.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: fix mpc85xx and add mpc8536 mpc8560
From: Kumar Gala <galak@kernel.crashing.org>

All other compatibles that are uniquely identifying the processor use a
prefix of the form fsl,mpc85...'.  We add support for it so we can
deprecate the older 'fsl,85...' that was improperly used here.

Additionally added mpc8536 & mpc8560 to the compatible lists.

This patch is based on Nate's 8572 patch.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Acked-by: Dave Jiang <djiang@mvista.com>
Cc: Nate Case <ncase@xes-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |   74 ++++++++++++++--------------------
 1 file changed, 32 insertions(+), 42 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-fix-mpc85xx-and-add-mpc8536-mpc8560 drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-fix-mpc85xx-and-add-mpc8536-mpc8560
+++ a/drivers/edac/mpc85xx_edac.c
@@ -630,27 +630,22 @@ static int mpc85xx_l2_err_remove(struct 
 }
 
 static struct of_device_id mpc85xx_l2_err_of_match[] = {
-	{
-	 .compatible = "fsl,8540-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8541-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8544-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8548-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8555-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8568-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,mpc8572-l2-cache-controller",
-	 },
+/* deprecate the fsl,85.. forms in the future, 2.6.30? */
+	{ .compatible = "fsl,8540-l2-cache-controller", },
+	{ .compatible = "fsl,8541-l2-cache-controller", },
+	{ .compatible = "fsl,8544-l2-cache-controller", },
+	{ .compatible = "fsl,8548-l2-cache-controller", },
+	{ .compatible = "fsl,8555-l2-cache-controller", },
+	{ .compatible = "fsl,8568-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8536-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8540-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8541-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8544-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8548-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8555-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
 	{},
 };
 
@@ -967,27 +962,22 @@ static int mpc85xx_mc_err_remove(struct 
 }
 
 static struct of_device_id mpc85xx_mc_err_of_match[] = {
-	{
-	 .compatible = "fsl,8540-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8541-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8544-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8548-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8555-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8568-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,mpc8572-memory-controller",
-	 },
+/* deprecate the fsl,85.. forms in the future, 2.6.30? */
+	{ .compatible = "fsl,8540-memory-controller", },
+	{ .compatible = "fsl,8541-memory-controller", },
+	{ .compatible = "fsl,8544-memory-controller", },
+	{ .compatible = "fsl,8548-memory-controller", },
+	{ .compatible = "fsl,8555-memory-controller", },
+	{ .compatible = "fsl,8568-memory-controller", },
+	{ .compatible = "fsl,mpc8536-memory-controller", },
+	{ .compatible = "fsl,mpc8540-memory-controller", },
+	{ .compatible = "fsl,mpc8541-memory-controller", },
+	{ .compatible = "fsl,mpc8544-memory-controller", },
+	{ .compatible = "fsl,mpc8548-memory-controller", },
+	{ .compatible = "fsl,mpc8555-memory-controller", },
+	{ .compatible = "fsl,mpc8560-memory-controller", },
+	{ .compatible = "fsl,mpc8568-memory-controller", },
+	{ .compatible = "fsl,mpc8572-memory-controller", },
 	{},
 };
 
_

Patches currently in -mm which might be from galak@kernel.crashing.org are

origin.patch
linux-next.patch

