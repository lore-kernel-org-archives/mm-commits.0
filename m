From: akpm@linux-foundation.org
Subject: + oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch added to -mm tree
Date: Thu, 20 Jan 2011 16:28:15 -0800
Message-ID: <201101210028.p0L0SFpV011482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722Ab1AUA3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     oom: suppress show_mem() for many nodes in irq context on page alloc failure
has been added to the -mm tree.  Its filename is
     oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch

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
Subject: oom: suppress show_mem() for many nodes in irq context on page alloc failure
From: David Rientjes <rientjes@google.com>

When a page allocation failure occurs, show_mem() is called to dump the
state of the VM so users may understand what happened to get into that
condition.

This output, however, can be extremely verbose.  In irq context, it may
result in significant delays that incur NMI watchdog timeouts when the
machine is large (we use CONFIG_NODES_SHIFT > 8 here to define a "large"
machine since the length of the show_mem() output is proportional to the
number of possible nodes).

This patch suppresses the show_mem() call in irq context when the kernel
has CONFIG_NODES_SHIFT > 8.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure mm/page_alloc.c
--- a/mm/page_alloc.c~oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure
+++ a/mm/page_alloc.c
@@ -1712,6 +1712,20 @@ try_next_zone:
 	return page;
 }
 
+/*
+ * Large machines with many possible nodes should not always dump per-node
+ * meminfo in irq context.
+ */
+static inline bool should_suppress_show_mem(void)
+{
+	bool ret = false;
+
+#if NODES_SHIFT > 8
+	ret = in_interrupt();
+#endif
+	return ret;
+}
+
 static inline int
 should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 				unsigned long pages_reclaimed)
@@ -2151,7 +2165,8 @@ nopage:
 			" order:%d, mode:0x%x\n",
 			current->comm, order, gfp_mask);
 		dump_stack();
-		show_mem();
+		if (!should_suppress_show_mem())
+			show_mem();
 	}
 	return page;
 got_pg:
_

Patches currently in -mm which might be from rientjes@google.com are

kconfig-rename-config_embedded-to-config_expert.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
jbd-remove-dependency-on-__gfp_nofail.patch

