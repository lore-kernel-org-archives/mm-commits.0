From: akpm@linux-foundation.org
Subject: + edac-fix-mpc85xx-and-add-mpc8536-mpc8560.patch added to -mm tree
Date: Fri, 14 Nov 2008 14:42:58 -0800
Message-ID: <200811142242.mAEMgwIN000397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbYKNWvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 17:51:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galak@kernel.crashing.org, djiang@mvista.com, dougthompson@xmission.com


The patch titled
     edac: fix mpc85xx and add mpc8536 mpc8560
has been added to the -mm tree.  Its filename is
     edac-fix-mpc85xx-and-add-mpc8536-mpc8560.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
edac-fix-mpc85xx-and-add-mpc8536-mpc8560.patch

