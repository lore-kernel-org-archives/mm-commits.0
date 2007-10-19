From: akpm@linux-foundation.org
Subject: - pid-namespaces-allow-signalling-container-init.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:54 -0700
Message-ID: <200710192251.l9JMpsab024221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760146AbXJSXLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: allow signalling cgroup-init
has been removed from the -mm tree.  Its filename was
     pid-namespaces-allow-signalling-container-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: allow signalling cgroup-init
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Only the global-init process must be special - any other cgroup-init
process must be killable to prevent run-away processes in the system.

TODO: 	Ideally we should allow killing the cgroup-init only from parent
	cgroup and prevent it being killed from within the cgroup.
	But that is a more complex change and will be addressed by a follow-on
	patch. For now allow the cgroup-init to be terminated by any process
	with sufficient privileges.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/signal.c~pid-namespaces-allow-signalling-container-init kernel/signal.c
--- a/kernel/signal.c~pid-namespaces-allow-signalling-container-init
+++ a/kernel/signal.c
@@ -1835,11 +1835,9 @@ relock:
 			continue;
 
 		/*
-		 * Init of a pid space gets no signals it doesn't want from
-		 * within that pid space. It can of course get signals from
-		 * its parent pid space.
+		 * Global init gets no signals it doesn't want.
 		 */
-		if (current == task_child_reaper(current))
+		if (is_global_init(current))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch
