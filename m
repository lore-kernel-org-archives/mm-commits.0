From: akpm@linux-foundation.org
Subject: + gpio-doc-updates.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:12:00 -0700
Message-ID: <201009072212.o87MC0v2009379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab0IGWMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, eric.y.miao@gmail.com, ryan@bluewatersys.com


The patch titled
     gpio: doc updates:
has been added to the -mm tree.  Its filename is
     gpio-doc-updates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: doc updates:
From: David Brownell <dbrownell@users.sourceforge.net>

There's been some recent confusion about error checking GPIO numbers. 
briefly, it should be handled mostly during setup, when gpio_request() is
called, and NEVER by expectig gpio_is_valid to report more than
never-usable GPIO numbers.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao" <eric.y.miao@gmail.com>
Cc: "Ryan Mallon" <ryan@bluewatersys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt     |   22 ++++++++++++++--------
 include/asm-generic/gpio.h |   12 +++++++++++-
 2 files changed, 25 insertions(+), 9 deletions(-)

diff -puN Documentation/gpio.txt~gpio-doc-updates Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-doc-updates
+++ a/Documentation/gpio.txt
@@ -109,17 +109,19 @@ use numbers 2000-2063 to identify GPIOs 
 
 If you want to initialize a structure with an invalid GPIO number, use
 some negative number (perhaps "-EINVAL"); that will never be valid.  To
-test if a number could reference a GPIO, you may use this predicate:
+test if such number from such a structure could reference a GPIO, you
+may use this predicate:
 
 	int gpio_is_valid(int number);
 
 A number that's not valid will be rejected by calls which may request
 or free GPIOs (see below).  Other numbers may also be rejected; for
-example, a number might be valid but unused on a given board.
-
-Whether a platform supports multiple GPIO controllers is currently a
-platform-specific implementation issue.
+example, a number might be valid but temporarily unused on a given board.
 
+Whether a platform supports multiple GPIO controllers is a platform-specific
+implementation issue, as are whether that support can leave "holes" in the space
+of GPIO numbers, and whether new controllers can be added at runtime.  Such issues
+can affect things including whether adjacent GPIO numbers are both valid.
 
 Using GPIOs
 -----------
@@ -480,12 +482,16 @@ To support this framework, a platform's 
 ARCH_REQUIRE_GPIOLIB or ARCH_WANT_OPTIONAL_GPIOLIB
 and arrange that its <asm/gpio.h> includes <asm-generic/gpio.h> and defines
 three functions: gpio_get_value(), gpio_set_value(), and gpio_cansleep().
-They may also want to provide a custom value for ARCH_NR_GPIOS.
 
-ARCH_REQUIRE_GPIOLIB means that the gpio-lib code will always get compiled
+It may also provide a custom value for ARCH_NR_GPIOS, so that it better
+reflects the number of GPIOs in actual use on that platform, without
+wasting static table space.  (It should count both built-in/SoC GPIOs and
+also ones on GPIO expanders.
+
+ARCH_REQUIRE_GPIOLIB means that the gpiolib code will always get compiled
 into the kernel on that architecture.
 
-ARCH_WANT_OPTIONAL_GPIOLIB means the gpio-lib code defaults to off and the user
+ARCH_WANT_OPTIONAL_GPIOLIB means the gpiolib code defaults to off and the user
 can enable it and build it into the kernel optionally.
 
 If neither of these options are selected, the platform does not support
diff -puN include/asm-generic/gpio.h~gpio-doc-updates include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpio-doc-updates
+++ a/include/asm-generic/gpio.h
@@ -16,15 +16,25 @@
  * While the GPIO programming interface defines valid GPIO numbers
  * to be in the range 0..MAX_INT, this library restricts them to the
  * smaller range 0..ARCH_NR_GPIOS-1.
+ *
+ * ARCH_NR_GPIOS is somewhat arbitrary; it usually reflects the sum of
+ * builtin/SoC GPIOs plus a number of GPIOs on expanders; the latter is
+ * actually an estimate of a board-specific value.
  */
 
 #ifndef ARCH_NR_GPIOS
 #define ARCH_NR_GPIOS		256
 #endif
 
+/* "valid" GPIO numbers are nonnegative and may be passed to
+ * setup routines like gpio_request().  only some valid numbers
+ * can successfully be requested and used.
+ *
+ * Invalid GPIO numbers are useful for indicating no-such-GPIO in
+ * platform data and other tables.
+
 static inline int gpio_is_valid(int number)
 {
-	/* only some non-negative numbers are valid */
 	return ((unsigned)number) < ARCH_NR_GPIOS;
 }
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
gpio-doc-updates.patch

