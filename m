From: akpm@linux-foundation.org
Subject: + hugetlb-offload-per-node-attribute-registrations-fix.patch added to -mm tree
Date: Mon, 02 Nov 2009 14:57:07 -0800
Message-ID: <200911022257.nA2Mv7dU019018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757151AbZKBW50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 17:57:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, randy.dunlap@oracle.com


The patch titled
     hugetlb: offload per node attribute registrations fix
has been added to the -mm tree.  Its filename is
     hugetlb-offload-per-node-attribute-registrations-fix.patch

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
Subject: hugetlb: offload per node attribute registrations fix
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Fix build failure when MEMORY_HOTPLUG_SPARSE and !HUGETLBFS:

drivers/base/node.c:484: error: implicit declaration of function 'init_node_hugetlb_work'
drivers/base/node.c:582: error: 'node_memory_callback' undeclared (first use in this function)

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/base/node.c~hugetlb-offload-per-node-attribute-registrations-fix drivers/base/node.c
--- a/drivers/base/node.c~hugetlb-offload-per-node-attribute-registrations-fix
+++ a/drivers/base/node.c
@@ -445,8 +445,12 @@ static int node_memory_callback(struct n
 }
 #endif	/* CONFIG_HUGETLBFS */
 #else	/* !CONFIG_MEMORY_HOTPLUG_SPARSE */
+
 static int link_mem_sections(int nid) { return 0; }
+#endif	/* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+#if !defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || \
+    !defined(CONFIG_HUGETLBFS)
 static inline int node_memory_callback(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
@@ -455,7 +459,7 @@ static inline int node_memory_callback(s
 
 static void init_node_hugetlb_work(int nid) { }
 
-#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
+#endif
 
 int register_one_node(int nid)
 {
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled.patch
acpi-remove-nid_inval.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
hugetlb-offload-per-node-attribute-registrations-fix.patch

