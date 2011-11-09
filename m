From: akpm@linux-foundation.org
Subject: + mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch added to -mm tree
Date: Wed, 09 Nov 2011 14:04:04 -0800
Message-ID: <201111092204.pA9M44sF016236@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:37772 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab1KIWFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 17:05:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz


The patch titled
     Subject: mm: memcg: remove unused node/section info from pc->flags fix
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: memcg: remove unused node/section info from pc->flags fix

Fix non-CONFIG_SPARSEMEM build, which failed with
mm/page_cgroup.c: In function `alloc_node_page_cgroup':
mm/page_cgroup.c:44: error: `start_pfn' undeclared (first use in this function)

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_cgroup.c~mm-memcg-remove-unused-node-section-info-from-pc-flags-fix mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-memcg-remove-unused-node-section-info-from-pc-flags-fix
+++ a/mm/page_cgroup.c
@@ -41,9 +41,7 @@ static int __init alloc_node_page_cgroup
 	unsigned long table_size;
 	unsigned long nr_pages;
 
-	start_pfn = NODE_DATA(nid)->node_start_pfn;
 	nr_pages = NODE_DATA(nid)->node_spanned_pages;
