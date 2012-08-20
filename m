From: akpm@linux-foundation.org
Subject: [merged] drivers-char-tlclkc-fix-error-return-code.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:29 -0700
Message-ID: <20120820195629.C432D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:47602 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2HTT4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:30 -0400
Received: by mail-iy0-f202.google.com with SMTP id o24so904828ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, arnd@arndb.de, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/tlclk.c: fix error return code
has been removed from the -mm tree.  Its filename was
     drivers-char-tlclkc-fix-error-return-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <julia@diku.dk>
Subject: drivers/char/tlclk.c: fix error return code

Convert a 0 error return code to a negative one, as returned elsewhere in
the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret;
expression e,e1,e2,e3,e4,x;
@@

(
if (\(ret != 0\|ret < 0\) || ...) { ... return ...; }
|
ret = 0
)
... when != ret = e1
*x = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\|ioremap\|ioremap_nocache\|devm_ioremap\|devm_ioremap_nocache\)(...);
... when != x = e2
    when != ret = e3
*if (x == NULL || ...)
{
  ... when != ret = e4
*  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by <mark.gross@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tlclk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/tlclk.c~drivers-char-tlclkc-fix-error-return-code drivers/char/tlclk.c
--- a/drivers/char/tlclk.c~drivers-char-tlclkc-fix-error-return-code
+++ a/drivers/char/tlclk.c
@@ -784,8 +784,10 @@ static int __init tlclk_init(void)
 	}
 	tlclk_major = ret;
 	alarm_events = kzalloc( sizeof(struct tlclk_alarms), GFP_KERNEL);
-	if (!alarm_events)
+	if (!alarm_events) {
+		ret = -ENOMEM;
 		goto out1;
+	}
 
 	/* Read telecom clock IRQ number (Set by BIOS) */
 	if (!request_region(TLCLK_BASE, 8, "telco_clock")) {
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch

