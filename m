From: akpm@google.com
Subject: + cgroups-add-a-task-counter-subsystem-fix.patch added to -mm tree
Date: Wed, 05 Oct 2011 12:32:47 -0700
Message-ID: <201110051932.p95JWlGE012766@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:28111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233Ab1JETcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 15:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, fweisbec@gmail.com


The patch titled
     Subject: cgroups: ERR_PTR needs err.h
has been added to the -mm tree.  Its filename is
     cgroups-add-a-task-counter-subsystem-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: cgroups: ERR_PTR needs err.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/cgroup_task_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup_task_counter.c~cgroups-add-a-task-counter-subsystem-fix kernel/cgroup_task_counter.c
--- a/kernel/cgroup_task_counter.c~cgroups-add-a-task-counter-subsystem-fix
+++ a/kernel/cgroup_task_counter.c
@@ -8,11 +8,11 @@
  *
  */
 
+#include <linux/err.h>
 #include <linux/cgroup.h>
 #include <linux/slab.h>
 #include <linux/res_counter.h>
 
