From: akpm@linux-foundation.org
Subject: - mark-res_counter_charge_locked-with-__must_check.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:02 -0700
Message-ID: <200807252258.m6PMw2K4003252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754844AbYGYXHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     Mark res_counter_charge(_locked) with __must_check
has been removed from the -mm tree.  Its filename was
     mark-res_counter_charge_locked-with-__must_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Mark res_counter_charge(_locked) with __must_check
From: Pavel Emelyanov <xemul@openvz.org>

Ignoring their return values may result in counter underflow in the future -
when the value charged will be uncharged (or in "leaks" - when the value is
not uncharged).

This also prevents from using charging routines to decrement the
counter value (i.e. uncharge it) ;)

(Current code works OK with res_counter, however :) )

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/res_counter.h~mark-res_counter_charge_locked-with-__must_check include/linux/res_counter.h
--- a/include/linux/res_counter.h~mark-res_counter_charge_locked-with-__must_check
+++ a/include/linux/res_counter.h
@@ -95,8 +95,10 @@ void res_counter_init(struct res_counter
  * counter->limit _locked call expects the counter->lock to be taken
  */
 
-int res_counter_charge_locked(struct res_counter *counter, unsigned long val);
-int res_counter_charge(struct res_counter *counter, unsigned long val);
+int __must_check res_counter_charge_locked(struct res_counter *counter,
+		unsigned long val);
+int __must_check res_counter_charge(struct res_counter *counter,
+		unsigned long val);
 
 /*
  * uncharge - tell that some portion of the resource is released
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

