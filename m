From: akpm@linux-foundation.org
Subject: + ipc-use-device_initcall.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:39:38 -0800
Message-ID: <5303d31a.Rz8V359+GcBgvu5s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBRVjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:39:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, davidlohr@hp.com

Subject: + ipc-use-device_initcall.patch added to -mm tree
To: davidlohr@hp.com,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:39:38 -0800


The patch titled
     Subject: ipc: use device_initcall
has been added to the -mm tree.  Its filename is
     ipc-use-device_initcall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-use-device_initcall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-use-device_initcall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
ipccompat-remove-sc_semopm-macro.patch
ipc-use-device_initcall.patch
linux-next.patch

