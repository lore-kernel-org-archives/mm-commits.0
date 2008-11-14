From: akpm@linux-foundation.org
Subject: + gru-fix-for-debug-option.patch added to -mm tree
Date: Fri, 14 Nov 2008 13:05:52 -0800
Message-ID: <200811142105.mAEL5qhM016898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbYKNVFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 16:05:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     GRU: fix for debug option
has been added to the -mm tree.  Its filename is
     gru-fix-for-debug-option.patch

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
Subject: GRU: fix for debug option
From: Jack Steiner <steiner@sgi.com>

Enable -D DEBUG in the GRU Makefile if CONFIG_SGI_GRU_DEBUG is selected.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/misc/sgi-gru/Makefile~gru-fix-for-debug-option drivers/misc/sgi-gru/Makefile
--- a/drivers/misc/sgi-gru/Makefile~gru-fix-for-debug-option
+++ a/drivers/misc/sgi-gru/Makefile
@@ -1,3 +1,7 @@
+ifdef CONFIG_SGI_GRU_DEBUG
+  EXTRA_CFLAGS	+= -DDEBUG
+endif
+
 obj-$(CONFIG_SGI_GRU) := gru.o
 gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
 
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-fix-for-debug-option.patch

