From: akpm@linux-foundation.org
Subject: - fix-core-x86-make-list_poison-less-deadly.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:40 -0800
Message-ID: <200812291918.mBTJIeCd030980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbYL2TZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:25:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@infradead.org, avi@redhat.com, jaswinderrajput@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fix "core, x86: make LIST_POISON less deadly"
has been removed from the -mm tree.  Its filename was
     fix-core-x86-make-list_poison-less-deadly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix "core, x86: make LIST_POISON less deadly"
From: Jaswinder Singh Rajput <jaswinder@infradead.org>

Impact: cleanup, avoid 10000+ sparse warnings

Eliminate 1434 sparse warnings like:
include/linux/list.h:106:16: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1434 sparse warnings like:
include/linux/list.h:107:16: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1434 sparse warnings like:
include/linux/list.h:579:12: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1434 sparse warnings like:
include/linux/list.h:580:13: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1237 sparse warnings like:
include/linux/rculist.h:97:16: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1237 sparse warnings like:
include/linux/rculist.h:143:14: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1237 sparse warnings like:
include/linux/rculist.h:260:13: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1237 sparse warnings like:
include/linux/rculist.h:280:15: warning: constant 0xdead000000000000 is so big it is unsigned long

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/poison.h~fix-core-x86-make-list_poison-less-deadly include/linux/poison.h
--- a/include/linux/poison.h~fix-core-x86-make-list_poison-less-deadly
+++ a/include/linux/poison.h
@@ -9,7 +9,7 @@
  * that is also not mappable by user-space exploits:
  */
 #ifdef CONFIG_ILLEGAL_POINTER_VALUE
-# define POISON_POINTER_DELTA CONFIG_ILLEGAL_POINTER_VALUE
+# define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
 #else
 # define POISON_POINTER_DELTA 0
 #endif
_

Patches currently in -mm which might be from jaswinder@infradead.org are

origin.patch
linux-next.patch
make-firmware-dsp56k-bootstrapasm-buildable-on-a56.patch

