From: akpm@linux-foundation.org
Subject: + include-linux-errnoh-in-linux-sysrqh.patch added to -mm tree
Date: Wed, 01 Jul 2009 23:39:24 -0700
Message-ID: <200907020639.n626dOls032150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbZGBGjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 02:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tobias.doerffel@gmail.com


The patch titled
     linux/sysrq.h needs linux/errno.h
has been added to the -mm tree.  Its filename is
     include-linux-errnoh-in-linux-sysrqh.patch

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
Subject: linux/sysrq.h needs linux/errno.h
From: Tobias Doerffel <tobias.doerffel@gmail.com>

In include/linux/sysrq.h the constant EINVAL is being used but is undefined
if include/linux/errno.h is not included before.

Fix this by adding #include <linux/errno.h> at the beginning.

Signed-off-by: Tobias Doerffel <tobias.doerffel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysrq.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/sysrq.h~include-linux-errnoh-in-linux-sysrqh include/linux/sysrq.h
--- a/include/linux/sysrq.h~include-linux-errnoh-in-linux-sysrqh
+++ a/include/linux/sysrq.h
@@ -14,6 +14,8 @@
 #ifndef _LINUX_SYSRQ_H
 #define _LINUX_SYSRQ_H
 
+#include <linux/errno.h>
+
 struct pt_regs;
 struct tty_struct;
 
_

Patches currently in -mm which might be from tobias.doerffel@gmail.com are

include-linux-errnoh-in-linux-sysrqh.patch

