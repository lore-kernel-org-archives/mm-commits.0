From: akpm@linux-foundation.org
Subject: [merged] drivers-char-rawc-remove-call-to-kobject_put.patch removed from -mm tree
Date: Mon, 09 May 2011 12:33:01 -0700
Message-ID: <201105091926.p49JQ11n012716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617Ab1EIT0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 15:26:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     drivers/char/raw.c: remove call to kobject_put().
has been removed from the -mm tree.  Its filename was
     drivers-char-rawc-remove-call-to-kobject_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/raw.c: remove call to kobject_put().
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

If cdev_add() fails, there is no justification for subsequently
calling kobject_put().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/raw.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/raw.c~drivers-char-rawc-remove-call-to-kobject_put drivers/char/raw.c
--- a/drivers/char/raw.c~drivers-char-rawc-remove-call-to-kobject_put
+++ a/drivers/char/raw.c
@@ -319,7 +319,6 @@ static int __init raw_init(void)
 	cdev_init(&raw_cdev, &raw_fops);
 	ret = cdev_add(&raw_cdev, dev, MAX_RAW_MINORS);
 	if (ret) {
-		kobject_put(&raw_cdev.kobj);
 		goto error_region;
 	}
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch

