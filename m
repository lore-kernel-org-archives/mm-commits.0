From: akpm@linux-foundation.org
Subject: [merged] mm-oom-add-description-of-struct-oom_control.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:45:32 -0700
Message-ID: <55f08c5c.IrFpD1rsl4lmuN4C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbIITpc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: add description of struct oom_control
has been removed from the -mm tree.  Its filename was
     mm-oom-add-description-of-struct-oom_control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: add description of struct oom_control

Describe the purpose of struct oom_control and what each member does.

Also make gfp_mask and order const since they are never manipulated or
passed to functions that discard the qualifier.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN include/linux/oom.h~mm-oom-add-description-of-struct-oom_control include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-add-description-of-struct-oom_control
+++ a/include/linux/oom.h
@@ -12,11 +12,25 @@ struct notifier_block;
 struct mem_cgroup;
 struct task_struct;
 
+/*
+ * Details of the page allocation that triggered the oom killer that are used to
+ * determine what should be killed.
+ */
 struct oom_control {
+	/* Used to determine cpuset */
 	struct zonelist *zonelist;
-	nodemask_t	*nodemask;
-	gfp_t		gfp_mask;
-	int		order;
+
+	/* Used to determine mempolicy */
+	nodemask_t *nodemask;
+
+	/* Used to determine cpuset and node locality requirement */
+	const gfp_t gfp_mask;
+
+	/*
+	 * order == -1 means the oom kill is required by sysrq, otherwise only
+	 * for display purposes.
+	 */
+	const int order;
 };
 
 /*
_

Patches currently in -mm which might be from rientjes@google.com are


