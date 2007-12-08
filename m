From: akpm@linux-foundation.org
Subject: - gpio_cs5535-disable-aux-on-output.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:58 -0800
Message-ID: <200712080129.lB81Tw97013439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268AbXLHBjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gardner.ben@gmail.com, david-b@pacbell.net, ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     gpio_cs5535: disable AUX on output
has been removed from the -mm tree.  Its filename was
     gpio_cs5535-disable-aux-on-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gpio_cs5535: disable AUX on output
From: "Ben Gardner" <gardner.ben@gmail.com>

The AMD CS5535/CS5536 GPIO has two alternate output modes: AUX-1 and AUX-2.
When either AUX is enabled, the cs5535_gpio driver cannot control the
output.

Some BIOS code for the Geode processor enables AUX-1 for GPIO-1, which
configures it as the PC BEEP output.

This patch will disable AUX-1 and AUX-2 when the user enables output.

Signed-of-by: Ben Gardner <gardner.ben@gmail.com>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cs5535_gpio.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/char/cs5535_gpio.c~gpio_cs5535-disable-aux-on-output drivers/char/cs5535_gpio.c
--- a/drivers/char/cs5535_gpio.c~gpio_cs5535-disable-aux-on-output
+++ a/drivers/char/cs5535_gpio.c
@@ -104,6 +104,11 @@ static ssize_t cs5535_gpio_write(struct 
 		for (j = 0; j < ARRAY_SIZE(rm); j++) {
 			if (c == rm[j].on) {
 				outl(m1, base + rm[j].wr_offset);
+				/* If enabling output, turn off AUX 1 and AUX 2 */
+				if (c == 'O') {
+					outl(m0, base + 0x10);
+					outl(m0, base + 0x14);
+				}
 				break;
 			} else if (c == rm[j].off) {
 				outl(m0, base + rm[j].wr_offset);
_

Patches currently in -mm which might be from gardner.ben@gmail.com are

origin.patch
