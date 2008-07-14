From: akpm@linux-foundation.org
Subject: - ov7670-clean-up-ov7670_read-semantics.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:34:54 -0700
Message-ID: <200807141934.m6EJYsO6023845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbYGNTfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, corbet@lwn.net, csetlow@tower-research.com, dilinger@debian.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ov7670: clean up ov7670_read semantics
has been removed from the -mm tree.  Its filename was
     ov7670-clean-up-ov7670_read-semantics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ov7670: clean up ov7670_read semantics
From: Andres Salomon <dilinger@queued.net>

Cortland Setlow pointed out a bug in ov7670.c where the result from
ov7670_read() was just being checked for !0, rather than <0.  This made me
realize that ov7670_read's semantics were rather confusing; it both fills
in 'value' with the result, and returns it.  This is goes against general
kernel convention; so rather than fixing callers, let's fix the function.

This makes ov7670_read return <0 in the case of an error, and 0 upon
success. Thus, code like:

res = ov7670_read(...);
if (!res)
	goto error;

..will work properly.

Signed-off-by: Cortland Setlow <csetlow@tower-research.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ov7670.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/ov7670.c~ov7670-clean-up-ov7670_read-semantics drivers/media/video/ov7670.c
--- a/drivers/media/video/ov7670.c~ov7670-clean-up-ov7670_read-semantics
+++ a/drivers/media/video/ov7670.c
@@ -406,8 +406,10 @@ static int ov7670_read(struct i2c_client
 	int ret;
 
 	ret = i2c_smbus_read_byte_data(c, reg);
-	if (ret >= 0)
+	if (ret >= 0) {
 		*value = (unsigned char) ret;
+		ret = 0;
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from dilinger@queued.net are

linux-next.patch
lxfb-drop-dead-declarations-from-header.patch

