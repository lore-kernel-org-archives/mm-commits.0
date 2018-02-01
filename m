From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-page=5Fextc-make-page=5Fext=5Finit-a-noop-when-config=5F?=
 =?US-ASCII?Q?page=5Fextension-but-nothing-uses-it.patch?= removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:34:16 -0800
Message-ID: <20180201193416.A-l8JELfn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754648AbeBATeW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaewon31.kim@samsung.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@techadventures.net, vbabka@suse.cz


The patch titled
     Subject: mm/page_ext.c: make page_ext_init a noop when CONFIG_PAGE_EXTENSION but nothing uses it
has been removed from the -mm tree.  Its filename was
     mm-page_extc-make-page_ext_init-a-noop-when-config_page_extension-but-nothing-uses-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm/page_ext.c: make page_ext_init a noop when CONFIG_PAGE_EXTENSION but nothing uses it

static struct page_ext_operations *page_ext_ops[] always contains debug_guardpage_ops,

static struct page_ext_operations *page_ext_ops[] = {
        &debug_guardpage_ops,
 #ifdef CONFIG_PAGE_OWNER
        &page_owner_ops,
 #endif
...
}

but for it to work, CONFIG_DEBUG_PAGEALLOC must be enabled first.  If
someone has CONFIG_PAGE_EXTENSION, but has none of its users, eg:
(CONFIG_PAGE_OWNER, CONFIG_DEBUG_PAGEALLOC, CONFIG_IDLE_PAGE_TRACKING), we
can shrink page_ext_init() to a simple retq.

$ size vmlinux  (before patch)
   text	   data	    bss	    dec	    hex	filename
14356698	5681582	1687748	21726028	14b834c	vmlinux

$ size vmlinux  (after patch)
   text	   data	    bss	    dec	    hex	filename
14356008	5681538	1687748	21725294	14b806e	vmlinux

On the other hand, it might does not even make sense, since if someone
enables CONFIG_PAGE_EXTENSION, I would expect him to enable also at least
one of its users.

Link: http://lkml.kernel.org/r/20180105130235.GA21241@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_ext.c~mm-page_extc-make-page_ext_init-a-noop-when-config_page_extension-but-nothing-uses-it mm/page_ext.c
--- a/mm/page_ext.c~mm-page_extc-make-page_ext_init-a-noop-when-config_page_extension-but-nothing-uses-it
+++ a/mm/page_ext.c
@@ -59,7 +59,9 @@
  */
 
 static struct page_ext_operations *page_ext_ops[] = {
+#ifdef CONFIG_DEBUG_PAGEALLOC
 	&debug_guardpage_ops,
+#endif
 #ifdef CONFIG_PAGE_OWNER
 	&page_owner_ops,
 #endif
_

Patches currently in -mm which might be from osalvador@techadventures.net are


