From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code.patch removed
 from -mm tree
Date: Wed, 12 Oct 2016 12:24:44 -0700
Message-ID: <57fe8dfc.LlX8rr9q0MOkpNmz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbcJLTYp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, fengguang.wu@intel.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rio_cm: use memdup_user() instead of duplicating code
has been removed from the -mm tree.  Its filename was
     rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rio_cm: use memdup_user() instead of duplicating code

Fix coccinelle warning about duplicating existing memdup_user function.

Link: http://lkml.kernel.org/r/20160811151737.20140-1-alexandre.bounine@idt.com
Link: https://lkml.org/lkml/2016/8/11/29
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio_cm.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/rapidio/rio_cm.c~rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code drivers/rapidio/rio_cm.c
--- a/drivers/rapidio/rio_cm.c~rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code
+++ a/drivers/rapidio/rio_cm.c
@@ -1841,24 +1841,19 @@ static int cm_chan_msg_send(void __user
 {
 	struct rio_cm_msg msg;
 	void *buf;
-	int ret = 0;
+	int ret;
 
 	if (copy_from_user(&msg, arg, sizeof(msg)))
 		return -EFAULT;
 	if (msg.size > RIO_MAX_MSG_SIZE)
 		return -EINVAL;
 
-	buf = kmalloc(msg.size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
