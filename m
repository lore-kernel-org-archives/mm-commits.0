From: akpm@linux-foundation.org
Subject: + mm-cleanup-register_node.patch added to -mm tree
Date: Thu, 08 Nov 2012 11:07:47 -0800
Message-ID: <20121108190749.3B18520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64133 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab2KHTHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 14:07:51 -0500
Received: by mail-wi0-f202.google.com with SMTP id hr7so205604wib.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 11:07:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: mm: cleanup register_node()
has been added to the -mm tree.  Its filename is
     mm-cleanup-register_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch
mm-cleanup-register_node.patch

