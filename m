From: akpm@linux-foundation.org
Subject: + fix-core-x86-make-list_poison-less-deadly.patch added to -mm tree
Date: Sat, 27 Dec 2008 02:09:18 -0800
Message-ID: <200812271009.mBRA9IfV011778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYL0KJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Dec 2008 05:09:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@infradead.org, avi@redhat.com, jaswinderrajput@gmail.com, mingo@elte.hu


The patch titled
     fix "core, x86: make LIST_POISON less deadly"
has been added to the -mm tree.  Its filename is
     fix-core-x86-make-list_poison-less-deadly.patch

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

linux-next.patch
fix-core-x86-make-list_poison-less-deadly.patch
make-firmware-dsp56k-bootstrapasm-buildable-on-a56.patch

