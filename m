From: akpm@linux-foundation.org
Subject: [merged]
 documentation-update-codingstyle-on-local-variables-naming-in-macros.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:16:23 -0700
Message-ID: <55355087.lyG9SaQl30kNI14d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbDTTKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgolaszewski@baylibre.com, linux@roeck-us.net, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: documentation: update CodingStyle on local variables naming in macros
has been removed from the -mm tree.  Its filename was
     documentation-update-codingstyle-on-local-variables-naming-in-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

