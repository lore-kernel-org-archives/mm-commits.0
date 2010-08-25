From: akpm@linux-foundation.org
Subject: + mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled.patch added to -mm tree
Date: Wed, 25 Aug 2010 15:32:25 -0700
Message-ID: <201008252232.o7PMWPgx019668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab0HYWce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 18:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com


The patch titled
     mm: only build per-node scan_unevictable functions when NUMA is enabled
has been added to the -mm tree.  Its filename is
     mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled.patch

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
Subject: mm: only build per-node scan_unevictable functions when NUMA is enabled
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Non-NUMA systems do never create these files anyway, since they are only
created by driver subsystem when NUMA is configured.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/vmscan.c          |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled include/linux/swap.h
--- a/include/linux/swap.h~mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled
+++ a/include/linux/swap.h
@@ -270,8 +270,13 @@ extern void scan_mapping_unevictable_pag
 extern unsigned long scan_unevictable_pages;
 extern int scan_unevictable_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+#ifdef CONFIG_NUMA
 extern int scan_unevictable_register_node(struct node *node);
 extern void scan_unevictable_unregister_node(struct node *node);
+#else
+static inline int scan_unevictable_register_node(struct node *node) {return 0;}
+static inline void scan_unevictable_unregister_node(struct node *node) {}
+#endif
 
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
diff -puN mm/vmscan.c~mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled mm/vmscan.c
--- a/mm/vmscan.c~mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled
+++ a/mm/vmscan.c
@@ -3033,6 +3033,7 @@ int scan_unevictable_handler(struct ctl_
 	return 0;
 }
 
+#ifdef CONFIG_NUMA
 /*
  * per node 'scan_unevictable_pages' attribute.  On demand re-scan of
  * a specified node's per zone unevictable lists for evictable pages.
@@ -3079,4 +3080,4 @@ void scan_unevictable_unregister_node(st
 {
 	sysdev_remove_file(&node->sysdev, &attr_scan_unevictable_pages);
 }
