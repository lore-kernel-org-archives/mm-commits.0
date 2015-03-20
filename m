From: akpm@linux-foundation.org
Subject: +
 documentation-update-codingstyle-on-local-variables-naming-in-macros.patch
 added to -mm tree
Date: Fri, 20 Mar 2015 13:51:25 -0700
Message-ID: <550c884d.Km4lAe0dob5lfHRQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbCTUv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 16:51:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgolaszewski@baylibre.com, linux@roeck-us.net, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: documentation: update CodingStyle on local variables naming in macros
has been added to the -mm tree.  Its filename is
     documentation-update-codingstyle-on-local-variables-naming-in-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-update-codingstyle-on-local-variables-naming-in-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-update-codingstyle-on-local-variables-naming-in-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: documentation: update CodingStyle on local variables naming in macros

Describe proper naming convention for local variables in macros
resembling functions.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN Documentation/CodingStyle~documentation-update-codingstyle-on-local-variables-naming-in-macros Documentation/CodingStyle
--- a/Documentation/CodingStyle~documentation-update-codingstyle-on-local-variables-naming-in-macros
+++ a/Documentation/CodingStyle
@@ -659,6 +659,19 @@ macros using parameters.
 #define CONSTANT 0x4000
 #define CONSTEXP (CONSTANT | 3)
 
+5) namespace collisions when defining local variables in macros resembling
+functions:
+
+#define FOO(x)				\
+({					\
+	typeof(x) ret;			\
+	ret = calc_ret(x);		\
+	(ret);				\
+)}
+
+ret is a common name for a local variable - __foo_ret is less likely
+to collide with an existing variable.
+
 The cpp manual deals with macros exhaustively. The gcc internals manual also
 covers RTL which is used frequently with assembly language in the kernel.
 
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are

util_macrosh-add-find_closest-macro.patch
documentation-update-codingstyle-on-local-variables-naming-in-macros.patch
hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest.patch
hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch
hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg.patch

