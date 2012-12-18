From: akpm@linux-foundation.org
Subject: [merged] aoe-describe-the-behavior-of-the-err-character-device.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:35 -0800
Message-ID: <20121218200935.95AFE100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:56211 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2LRUJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:36 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so125562yhl.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: describe the behavior of the "err" character device
has been removed from the -mm tree.  Its filename was
     aoe-describe-the-behavior-of-the-err-character-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: describe the behavior of the "err" character device

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoechr.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/block/aoe/aoechr.c~aoe-describe-the-behavior-of-the-err-character-device drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-describe-the-behavior-of-the-err-character-device
+++ a/drivers/block/aoe/aoechr.c
@@ -39,6 +39,11 @@ struct ErrMsg {
 };
 
 static DEFINE_MUTEX(aoechr_mutex);
+
+/* A ring buffer of error messages, to be read through
+ * "/dev/etherd/err".  When no messages are present,
+ * readers will block waiting for messages to appear.
+ */
 static struct ErrMsg emsgs[NMSG];
 static int emsgs_head_idx, emsgs_tail_idx;
 static struct completion emsgs_comp;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

