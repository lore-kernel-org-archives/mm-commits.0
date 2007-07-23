From: akpm@linux-foundation.org
Subject: + minor-gpio-doc-update.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:34:40 -0700
Message-ID: <200707232134.l6NLYecv013026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058AbXGWVfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, ukleinek@informatik.uni-freiburg.de


The patch titled
     minor gpio doc update
has been added to the -mm tree.  Its filename is
     minor-gpio-doc-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: minor gpio doc update
=46rom: David Brownell <david-b@pacbell.net>

=46ix doc bug noted by Uwe Kleine-K=F6nig:  gpio_set_direction() is lon=
g
gone, replaced by gpio_direction_input() and gpio_direction_output().

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "Uwe Kleine-Koenig" <ukleinek@informatik.uni-freiburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/gpio.txt~minor-gpio-doc-update Documentation/gp=
io.txt
--- a/Documentation/gpio.txt~minor-gpio-doc-update
+++ a/Documentation/gpio.txt
@@ -148,7 +148,7 @@ pin ... that won't always match the spec
 issues including wire-OR and output latencies.
=20
 The get/set calls have no error returns because "invalid GPIO" should =
have
-been reported earlier in gpio_set_direction().  However, note that not=
 all
+been reported earlier from gpio_direction_*().  However, note that not=
 all
 platforms can read the value of output pins; those that can't should a=
lways
 return zero.  Also, using these calls for GPIOs that can't safely be a=
ccessed
 without sleeping (see below) is an error.
@@ -239,7 +239,7 @@ map between them using calls like:
 Those return either the corresponding number in the other namespace, o=
r
 else a negative errno code if the mapping can't be done.  (For example=
,
 some GPIOs can't used as IRQs.)  It is an unchecked error to use a GPI=
O
-number that hasn't been marked as an input using gpio_set_direction(),=
 or
+number that wasn't set up as an input using gpio_direction_input(), or
 to use an IRQ number that didn't originally come from gpio_to_irq().
=20
 These two mapping calls are expected to cost on the order of a single
_

Patches currently in -mm which might be from david-b@pacbell.net are

minor-gpio-doc-update.patch
git-acpi.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
