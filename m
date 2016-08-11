From: akpm@linux-foundation.org
Subject: +
 rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code.patch added to
 -mm tree
Date: Thu, 11 Aug 2016 13:17:32 -0700
Message-ID: <57acdd5c.JR1J5+aiVkosHAWc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbcHKURd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 16:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, fengguang.wu@intel.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rio_cm: use memdup_user() instead of duplicating code
has been added to the -mm tree.  Its filename is
     rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rio_cm: use memdup_user() instead of duplicating code

Fix coccinelle warning about duplicating existing memdup_user function.

Link: http://lkml.kernel.org/r/20160811151737.20140-1-alexandre.bounine@idt.com
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
