From: akpm@linux-foundation.org
Subject: + kconfig-use-macros-which-are-already-defined.patch added to -mm tree
Date: Thu, 26 Feb 2015 13:24:14 -0800
Message-ID: <54ef8efe.AI+jFq+VTuqCYbLR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbbBZVYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 16:24:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: monstr@monstr.eu, michal.simek@xilinx.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kconfig.h: ese macros which are already defined
has been added to the -mm tree.  Its filename is
     kconfig-use-macros-which-are-already-defined.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-use-macros-which-are-already-defined.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-use-macros-which-are-already-defined.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Simek <monstr@monstr.eu>
Subject: include/linux/kconfig.h: ese macros which are already defined

It is better to use macros which are already available because then there
is just one location which needs to be change.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kconfig.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kconfig.h~kconfig-use-macros-which-are-already-defined include/linux/kconfig.h
--- a/include/linux/kconfig.h~kconfig-use-macros-which-are-already-defined
+++ a/include/linux/kconfig.h
@@ -28,7 +28,7 @@
  *
  */
 #define IS_ENABLED(option) \
-	(config_enabled(option) || config_enabled(option##_MODULE))
+	(IS_BUILTIN(option) || IS_MODULE(option))
 
 /*
  * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
_

Patches currently in -mm which might be from monstr@monstr.eu are

microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
kconfig-use-macros-which-are-already-defined.patch
kconfig-use-macros-which-are-already-defined-fix.patch

