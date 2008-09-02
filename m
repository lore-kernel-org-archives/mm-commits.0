From: akpm@linux-foundation.org
Subject: - v4l1-make-pms-not-autoprobe-when-builtin-update.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:16 -0700
Message-ID: <200809022041.m82KfGsJ011625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbYIBUlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, alan@lxorguk.ukuu.org.uk, mchehab@infradead.org, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     v4l1-make-pms-not-autoprobe-when-builtin update
has been removed from the -mm tree.  Its filename was
     v4l1-make-pms-not-autoprobe-when-builtin-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l1-make-pms-not-autoprobe-when-builtin update
From: Rene Herman <rene.herman@keyaccess.nl>

On 10-08-08 23:37, Alan Cox wrote:
>
> Would probably make the printk "pms: not enabled, use pms.enable=1 to
> probe"
>
> So you know
> a) What is wittering about not being probed
> b) How to undo it.
>
> But thats trivia really.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/pms.c~v4l1-make-pms-not-autoprobe-when-builtin-update drivers/media/video/pms.c
--- a/drivers/media/video/pms.c~v4l1-make-pms-not-autoprobe-when-builtin-update
+++ a/drivers/media/video/pms.c
@@ -1030,7 +1030,8 @@ static int __init init_pms_cards(void)
 
 #ifndef MODULE
 	if (!enable) {
-		printk(KERN_INFO "Not enabled\n");
+		printk(KERN_INFO "PMS: not enabled, use pms.enable=1 to "
+				 "probe\n");
 		return -ENODEV;
 	}
 #endif
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

linux-next.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch

