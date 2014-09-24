From: akpm@linux-foundation.org
Subject: + rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers.patch added to
 -mm tree
Date: Wed, 24 Sep 2014 15:45:56 -0700
Message-ID: <542349a4.a+JwB+fwoihKS7cM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIXWp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 18:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-rs5c372.c: use %*ph to dump small buffers
has been added to the -mm tree.  Its filename is
     rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-rtc-rs5c372-use-%ph-to-dump-small-buffers.patch
linux-next.patch
lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch

