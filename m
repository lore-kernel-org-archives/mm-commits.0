From: akpm@linux-foundation.org
Subject: [merged] mm-cleanup-register_node.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:00:53 -0800
Message-ID: <20121212200054.27C4120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52751 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2LLUA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:00:56 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so65806eei.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:00:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup register_node()
has been removed from the -mm tree.  Its filename was
     mm-cleanup-register_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: mm: cleanup register_node()

register_node() is defined as extern in include/linux/node.h.  But the
function is only called from register_one_node() in driver/base/node.c.

So the patch defines register_node() as static.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |    2 +-
 include/linux/node.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/base/node.c~mm-cleanup-register_node drivers/base/node.c
--- a/drivers/base/node.c~mm-cleanup-register_node
+++ a/drivers/base/node.c
@@ -277,7 +277,7 @@ static void node_device_release(struct d
  *
  * Initialize and register the node device.
  */
-int register_node(struct node *node, int num, struct node *parent)
+static int register_node(struct node *node, int num, struct node *parent)
 {
 	int error;
 
diff -puN include/linux/node.h~mm-cleanup-register_node include/linux/node.h
--- a/include/linux/node.h~mm-cleanup-register_node
+++ a/include/linux/node.h
@@ -30,7 +30,6 @@ struct memory_block;
 extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
-extern int register_node(struct node *, int, struct node *);
 extern void unregister_node(struct node *node);
 #ifdef CONFIG_NUMA
 extern int register_one_node(int nid);
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
linux-next.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

