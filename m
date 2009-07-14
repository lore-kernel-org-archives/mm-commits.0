From: akpm@linux-foundation.org
Subject: [merged] include-linux-errnoh-in-linux-sysrqh.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:54 -0700
Message-ID: <200907142032.n6EKWs9r012636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431AbZGNUc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tobias.doerffel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     linux/sysrq.h needs linux/errno.h
has been removed from the -mm tree.  Its filename was
     include-linux-errnoh-in-linux-sysrqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


