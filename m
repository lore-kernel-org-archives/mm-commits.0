From: akpm@linux-foundation.org
Subject: + drivers-char-tlclkc-fix-error-return-code.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:20:19 -0700
Message-ID: <20120815232020.16D2C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:35897 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573Ab2HOXUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2012 19:20:22 -0400
Received: by lagw12 with SMTP id w12so99173lag.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:20:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, arnd@arndb.de, gregkh@linuxfoundation.org


The patch titled
     Subject: drivers/char/tlclk.c: fix error return code
has been added to the -mm tree.  Its filename is
     drivers-char-tlclkc-fix-error-return-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
drivers-char-tlclkc-fix-error-return-code.patch

