From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:20:54 -0700
Message-ID: <543d6986.qD6eGQdW9jUb2W2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaJNSUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-rs5c372.c: use %*ph to dump small buffers
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drivers/rtc/rtc-rs5c372.c: use %*ph to dump small buffers

Instead of pushing each byte let's reduce stack usage by using %*ph specifier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -142,12 +142,11 @@ static int rs5c_get_regs(struct rs5c372
 	}
 
 	dev_dbg(&client->dev,
-		"%02x %02x %02x (%02x) %02x %02x %02x (%02x), "
-		"%02x %02x %02x, %02x %02x %02x; %02x %02x\n",
-		rs5c->regs[0],  rs5c->regs[1],  rs5c->regs[2],  rs5c->regs[3],
-		rs5c->regs[4],  rs5c->regs[5],  rs5c->regs[6],  rs5c->regs[7],
-		rs5c->regs[8],  rs5c->regs[9],  rs5c->regs[10], rs5c->regs[11],
-		rs5c->regs[12], rs5c->regs[13], rs5c->regs[14], rs5c->regs[15]);
+		"%3ph (%02x) %3ph (%02x), %3ph, %3ph; %02x %02x\n",
+		rs5c->regs + 0, rs5c->regs[3],
+		rs5c->regs + 4, rs5c->regs[7],
+		rs5c->regs + 8, rs5c->regs + 11,
+		rs5c->regs[14], rs5c->regs[15]);
 
 	return 0;
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

