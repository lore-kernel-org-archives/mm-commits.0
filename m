From: akpm@linux-foundation.org
Subject: [merged]
 mm-drop-useless-local-parameters-of-__register_one_node.patch removed from
 -mm tree
Date: Tue, 11 Jul 2017 12:24:31 -0700
Message-ID: <20170711192431._llh6H4_R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbdGKTYc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: douly.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com


The patch titled
     Subject: mm: drop useless local parameters of __register_one_node()
has been removed from the -mm tree.  Its filename was
     mm-drop-useless-local-parameters-of-__register_one_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dou Liyang <douly.fnst@cn.fujitsu.com>
Subject: mm: drop useless local parameters of __register_one_node()

__register_one_node() initializes local parameters "p_node" & "parent" for
register_node().

But, register_node() does not use them.

Remove the related code of "parent" node, cleanup __register_one_node()
and register_node().

Link: http://lkml.kernel.org/r/1498013846-20149-1-git-send-email-douly.fnst@cn.fujitsu.com
Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/base/node.c~mm-drop-useless-local-parameters-of-__register_one_node drivers/base/node.c
--- a/drivers/base/node.c~mm-drop-useless-local-parameters-of-__register_one_node
+++ a/drivers/base/node.c
@@ -288,7 +288,7 @@ static void node_device_release(struct d
  *
  * Initialize and register the node device.
  */
-static int register_node(struct node *node, int num, struct node *parent)
+static int register_node(struct node *node, int num)
 {
 	int error;
 
@@ -567,19 +567,14 @@ static void init_node_hugetlb_work(int n
 
 int __register_one_node(int nid)
 {
-	int p_node = parent_node(nid);
-	struct node *parent = NULL;
 	int error;
 	int cpu;
 
-	if (p_node != nid)
-		parent = node_devices[p_node];
