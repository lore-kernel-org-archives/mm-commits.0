From: akpm@linux-foundation.org
Subject: + memcg-remove-unused-variable.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:23:01 -0700
Message-ID: <20120404212301.5059EA011D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:35617 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2DDVXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:23:07 -0400
Received: by yhgm50 with SMTP id m50so94649yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:23:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: remove unused variable
has been added to the -mm tree.  Its filename is
     memcg-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: memcg: remove unused variable

mm/memcontrol.c: In function `mc_handle_file_pte':
mm/memcontrol.c:5206:16: warning: variable `inode' set but not used [-Wunused-but-set-variable]

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unused-variable mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unused-variable
+++ a/mm/memcontrol.c
@@ -5133,7 +5133,6 @@ static struct page *mc_handle_file_pte(s
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
 	struct page *page = NULL;
-	struct inode *inode;
 	struct address_space *mapping;
 	pgoff_t pgoff;
 
@@ -5142,7 +5141,6 @@ static struct page *mc_handle_file_pte(s
 	if (!move_file())
 		return NULL;
 
-	inode = vma->vm_file->f_path.dentry->d_inode;
 	mapping = vma->vm_file->f_mapping;
 	if (pte_none(ptent))
 		pgoff = linear_page_index(vma, addr);
_
Subject: Subject: memcg: remove unused variable

Patches currently in -mm which might be from kirill@shutemov.name are

memcg-mark-more-functions-variables-as-static.patch
memcg-remove-unused-variable.patch

