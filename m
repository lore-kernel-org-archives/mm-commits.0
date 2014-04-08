From: akpm@linux-foundation.org
Subject: [merged] ipc-use-device_initcall.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:38:41 -0700
Message-ID: <53446c61.0hW8G0fV3JJWVUPh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbaDHVim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, davidlohr@hp.com

Subject: [merged] ipc-use-device_initcall.patch removed from -mm tree
To: davidlohr@hp.com,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:38:41 -0700


The patch titled
     Subject: ipc: use device_initcall
has been removed from the -mm tree.  Its filename was
     ipc-use-device_initcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc: use device_initcall

... since __initcall is now deprecated.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    2 +-
 ipc/mqueue.c     |    2 +-
 ipc/util.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/ipc_sysctl.c~ipc-use-device_initcall ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-use-device_initcall
+++ a/ipc/ipc_sysctl.c
@@ -281,4 +281,4 @@ static int __init ipc_sysctl_init(void)
 	return 0;
 }
 
-__initcall(ipc_sysctl_init);
+device_initcall(ipc_sysctl_init);
diff -puN ipc/mqueue.c~ipc-use-device_initcall ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-use-device_initcall
+++ a/ipc/mqueue.c
@@ -1459,4 +1459,4 @@ out_sysctl:
 	return error;
 }
 
-__initcall(init_mqueue_fs);
+device_initcall(init_mqueue_fs);
diff -puN ipc/util.c~ipc-use-device_initcall ipc/util.c
--- a/ipc/util.c~ipc-use-device_initcall
+++ a/ipc/util.c
@@ -128,7 +128,7 @@ static int __init ipc_init(void)
 	register_ipcns_notifier(&init_ipc_ns);
 	return 0;
 }
-__initcall(ipc_init);
+device_initcall(ipc_init);
 
 /**
  * ipc_init_ids	- initialise ipc identifiers
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch

