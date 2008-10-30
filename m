From: akpm@linux-foundation.org
Subject: + memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch added to -mm tree
Date: Thu, 30 Oct 2008 00:20:13 -0700
Message-ID: <200810300720.m9U7KDXG016718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbYJ3HU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 03:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: do not recalculate section unnecessarily in init_section_page_cgroup
has been added to the -mm tree.  Its filename is
     memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch

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
Subject: memcg: do not recalculate section unnecessarily in init_section_page_cgroup
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

In init_section_page_cgroup() the section a given pfn belongs to is
calculated at the top of the function and, despite the fact that the
pfn/section correspondence does not change, it is recalculated further
down the same function.  By computing this just once and reusing that
value we save some bytes in the object file and do not waste CPU cycles.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/page_cgroup.c~memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup
+++ a/mm/page_cgroup.c
@@ -99,13 +99,11 @@ struct page_cgroup *lookup_page_cgroup(s
 
 int __meminit init_section_page_cgroup(unsigned long pfn)
 {
-	struct mem_section *section;
+	struct mem_section *section = __pfn_to_section(pfn);
 	struct page_cgroup *base, *pc;
 	unsigned long table_size;
 	int nid, index;
 
-	section = __pfn_to_section(pfn);
