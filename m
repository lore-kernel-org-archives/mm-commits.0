From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-make-hugetlb_register_node-static.patch added to -mm tree
Date: Wed, 06 Mar 2013 14:51:35 -0800
Message-ID: <20130306225135.5F1EE31C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38431 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3CFWvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 17:51:36 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so546986qaj.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 14:51:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: claudiughioc@gmail.com, claudiu.ghioc@gmail.com


The patch titled
     Subject: mm/hugetlb.c: make hugetlb_[un]register_node() static
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-make-hugetlb_register_node-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Claudiu Ghioc <claudiughioc@gmail.com>
Subject: mm/hugetlb.c: make hugetlb_[un]register_node() static

Fixes sparse warnings:

mm/hugetlb.c:1764:6: warning: symbol 'hugetlb_unregister_node' was not declared. Should it be static?

mm/hugetlb.c:1808:6: warning: symbol 'hugetlb_register_node' was not declared. Should it be static?

Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-make-hugetlb_register_node-static mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-make-hugetlb_register_node-static
+++ a/mm/hugetlb.c
@@ -1761,7 +1761,7 @@ static struct hstate *kobj_to_node_hstat
  * Unregister hstate attributes from a single node device.
  * No-op if no hstate attributes attached.
  */
-void hugetlb_unregister_node(struct node *node)
+static void hugetlb_unregister_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
@@ -1805,7 +1805,7 @@ static void hugetlb_unregister_all_nodes
  * Register hstate attributes for a single node device.
  * No-op if attributes already registered.
  */
-void hugetlb_register_node(struct node *node)
+static void hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
_

Patches currently in -mm which might be from claudiughioc@gmail.com are

mm-hugetlbc-make-hugetlb_register_node-static.patch

