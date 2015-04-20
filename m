From: akpm@linux-foundation.org
Subject: [merged] kconfig-use-macros-which-are-already-defined.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:22 -0700
Message-ID: <55355176.b4xAl8ul0uxP10Lv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbbDTTOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: monstr@monstr.eu, michal.simek@xilinx.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kconfig.h: ese macros which are already defined
has been removed from the -mm tree.  Its filename was
     kconfig-use-macros-which-are-already-defined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Simek <monstr@monstr.eu>
Subject: include/linux/kconfig.h: ese macros which are already defined

It is better to use macros which are already available because then there
is just one location which needs to be change.

[akpm@linux-foundation.org: move IS_ENABLED definition to after the IS_BUILTIN and IS_MODULE definitions]
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kconfig.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/kconfig.h~kconfig-use-macros-which-are-already-defined include/linux/kconfig.h
--- a/include/linux/kconfig.h~kconfig-use-macros-which-are-already-defined
+++ a/include/linux/kconfig.h
@@ -23,14 +23,6 @@
 #define ___config_enabled(__ignored, val, ...) val
 
 /*
- * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
- * 0 otherwise.
- *
- */
-#define IS_ENABLED(option) \
-	(config_enabled(option) || config_enabled(option##_MODULE))
