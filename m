From: akpm@linux-foundation.org
Subject: - sgi-xp-define-is_shub-and-is_uv-macros.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:17 -0700
Message-ID: <200807301916.m6UJGH6M011112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYG3TYJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: define is_shub() and is_uv() macros
has been removed from the -mm tree.  Its filename was
     sgi-xp-define-is_shub-and-is_uv-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: define is_shub() and is_uv() macros
From: Dean Nelson <dcn@sgi.com>

Define the is_shub()/is_uv() macros if they've not already been defined.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-define-is_shub-and-is_uv-macros drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-define-is_shub-and-is_uv-macros
+++ a/drivers/misc/sgi-xp/xp.h
@@ -25,6 +25,22 @@
 #define DBUG_ON(condition)
 #endif
 
+#ifndef is_shub1
+#define is_shub1()	0
+#endif
+
+#ifndef is_shub2
+#define is_shub2()	0
+#endif
+
+#ifndef is_shub
+#define is_shub()	(is_shub1() || is_shub2())
+#endif
+
+#ifndef is_uv
+#define is_uv()		0
+#endif
+
 /*
  * Define the maximum number of logically defined partitions the system
  * can support. It is constrained by the maximum number of hardware
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

