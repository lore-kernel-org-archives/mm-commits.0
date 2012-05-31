From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-unused-variable.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:05 -0700
Message-ID: <20120531191705.5EF1DA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60153 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2EaTRH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:07 -0400
Received: by eeit10 with SMTP id t10so76344eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove unused variable
has been removed from the -mm tree.  Its filename was
     memcg-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -5150,7 +5150,6 @@ static struct page *mc_handle_file_pte(s
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
 	struct page *page = NULL;
-	struct inode *inode;
 	struct address_space *mapping;
 	pgoff_t pgoff;
 
@@ -5159,7 +5158,6 @@ static struct page *mc_handle_file_pte(s
 	if (!move_file())
 		return NULL;
 
-	inode = vma->vm_file->f_path.dentry->d_inode;
 	mapping = vma->vm_file->f_mapping;
 	if (pte_none(ptent))
 		pgoff = linear_page_index(vma, addr);
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

