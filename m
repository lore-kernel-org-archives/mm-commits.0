From: akpm@linux-foundation.org
Subject: + mm-mempolicy-check-return-code-of-check_range.patch added to -mm tree
Date: Wed, 08 Sep 2010 13:12:39 -0700
Message-ID: <201009082012.o88KCdKC006391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384Ab0IHUNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2010 16:13:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     mm/mempolicy.c: check return code of check_range
has been added to the -mm tree.  Its filename is
     mm-mempolicy-check-return-code-of-check_range.patch

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
Subject: mm/mempolicy.c: check return code of check_range
From: Vasiliy Kulikov <segooon@gmail.com>

Function check_range may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicy-check-return-code-of-check_range mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-check-return-code-of-check_range
+++ a/mm/mempolicy.c
@@ -924,12 +924,15 @@ static int migrate_to_node(struct mm_str
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
 	int err = 0;
+	struct vm_area_struct *vma;
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
-	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
 
 	if (!list_empty(&pagelist))
 		err = migrate_pages(&pagelist, new_node_page, dest, 0);
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
md-check-return-code-of-read_sb_page.patch
mm-mempolicy-check-return-code-of-check_range.patch

