From: akpm@linux-foundation.org
Subject: + mm-drop-useless-local-parameters-of-__register_one_node.patch
 added to -mm tree
Date: Thu, 22 Jun 2017 14:59:18 -0700
Message-ID: <594c3db6.x+cBIsv6D3nS4IRs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdFVV7T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: douly.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mhocko@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop useless local parameters of __register_one_node()
has been added to the -mm tree.  Its filename is
     mm-drop-useless-local-parameters-of-__register_one_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-useless-local-parameters-of-__register_one_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-useless-local-parameters-of-__register_one_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
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
