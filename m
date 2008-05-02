From: akpm@linux-foundation.org
Subject: - netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:18 -0700
Message-ID: <200805021944.m42JiIh1011369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935286AbYEBTxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     netns: assign PDE->data before gluing entry into /proc tree
has been removed from the -mm tree.  Its filename was
     netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netns: assign PDE->data before gluing entry into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

In this unfortunate case, proc_mkdir_mode wrapper can't be used anymore and
this is no way to reuse proc_create_data due to nlinks assignment.  So, copy
the code from proc_mkdir and assign PDE->data at the appropriate moment.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |   17 +++++++++++++++++
 fs/proc/proc_net.c |   11 -----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/proc/generic.c~netns-assign-pde-data-before-gluing-entry-into-proc-tree fs/proc/generic.c
--- a/fs/proc/generic.c~netns-assign-pde-data-before-gluing-entry-into-proc-tree
+++ a/fs/proc/generic.c
@@ -641,6 +641,23 @@ struct proc_dir_entry *proc_mkdir_mode(c
 	return ent;
 }
 
+struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
+		struct proc_dir_entry *parent)
+{
+	struct proc_dir_entry *ent;
+
+	ent = __proc_create(&parent, name, S_IFDIR | S_IRUGO | S_IXUGO, 2);
+	if (ent) {
+		ent->data = net;
+		if (proc_register(parent, ent) < 0) {
+			kfree(ent);
+			ent = NULL;
+		}
+	}
+	return ent;
+}
+EXPORT_SYMBOL_GPL(proc_net_mkdir);
+
 struct proc_dir_entry *proc_mkdir(const char *name,
 		struct proc_dir_entry *parent)
 {
diff -puN fs/proc/proc_net.c~netns-assign-pde-data-before-gluing-entry-into-proc-tree fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~netns-assign-pde-data-before-gluing-entry-into-proc-tree
+++ a/fs/proc/proc_net.c
@@ -159,17 +159,6 @@ struct net *get_proc_net(const struct in
 }
 EXPORT_SYMBOL_GPL(get_proc_net);
 
-struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
-		struct proc_dir_entry *parent)
-{
-	struct proc_dir_entry *pde;
-	pde = proc_mkdir_mode(name, S_IRUGO | S_IXUGO, parent);
-	if (pde != NULL)
-		pde->data = net;
-	return pde;
-}
-EXPORT_SYMBOL_GPL(proc_net_mkdir);
