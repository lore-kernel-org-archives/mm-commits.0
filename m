From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1307c-change-variable-type-to-bool.patch
 added to -mm tree
Date: Tue, 08 Oct 2013 15:44:19 -0700
Message-ID: <52548ac3./cdWHEmETPexUdz/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3JHWoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Oct 2013 18:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peter.senna@gmail.com

Subject: + drivers-rtc-rtc-ds1307c-change-variable-type-to-bool.patch added to -mm tree
To: peter.senna@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 08 Oct 2013 15:44:19 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: change variable type to bool
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-change-variable-type-to-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1307c-change-variable-type-to-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1307c-change-variable-type-to-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: drivers/rtc/rtc-ds1307.c: change variable type to bool

The variable want_irq is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-change-variable-type-to-bool drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-change-variable-type-to-bool
+++ a/drivers/rtc/rtc-ds1307.c
@@ -670,7 +670,7 @@ static int ds1307_probe(struct i2c_clien
 	int			tmp;
 	const struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
-	int			want_irq = false;
+	bool			want_irq = false;
 	unsigned char		*buf;
 	struct ds1307_platform_data *pdata = dev_get_platdata(&client->dev);
 	static const int	bbsqi_bitpos[] = {
_

Patches currently in -mm which might be from peter.senna@gmail.com are

drivers-rtc-rtc-ds1307c-change-variable-type-to-bool.patch
linux-next.patch

