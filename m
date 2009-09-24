From: akpm@linux-foundation.org
Subject: [merged] linux-futexh-place-kernel-types-behind-__kernel__.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:44 -0700
Message-ID: <200909241936.n8OJaiiD003113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbZIXThQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     linux/futex.h: place kernel types behind __KERNEL__
has been removed from the -mm tree.  Its filename was
     linux-futexh-place-kernel-types-behind-__kernel__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux/futex.h: place kernel types behind __KERNEL__
From: Mike Frysinger <vapier@gentoo.org>

The forward decls for some kernel types are only needed by the code behind
__KERNEL__, so don't bleed these types to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/futex.h~linux-futexh-place-kernel-types-behind-__kernel__ include/linux/futex.h
--- a/include/linux/futex.h~linux-futexh-place-kernel-types-behind-__kernel__
+++ a/include/linux/futex.h
@@ -4,11 +4,6 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
-struct inode;
-struct mm_struct;
-struct task_struct;
-union ktime;
