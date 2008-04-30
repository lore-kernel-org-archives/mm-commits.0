From: akpm@linux-foundation.org
Subject: - elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:11 -0700
Message-ID: <200804300545.m3U5jBEf029482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756265AbYD3GBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     elf: fix shadowed variables in fs/binfmt_elf.c
has been removed from the -mm tree.  Its filename was
     elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf: fix shadowed variables in fs/binfmt_elf.c
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix these sparse warings:
fs/binfmt_elf.c:1749:29: warning: symbol 'tmp' shadows an earlier one
fs/binfmt_elf.c:1734:28: originally declared here
fs/binfmt_elf.c:2009:26: warning: symbol 'vma' shadows an earlier one
fs/binfmt_elf.c:1892:24: originally declared here

[akpm@linux-foundation.org: chose better variable name]
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN fs/binfmt_elf.c~elf-fix-shadowed-variables-in-fs-binfmt_elfc fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-fix-shadowed-variables-in-fs-binfmt_elfc
+++ a/fs/binfmt_elf.c
@@ -1722,26 +1722,25 @@ static int fill_note_info(struct elfhdr 
 
 	info->thread_status_size = 0;
 	if (signr) {
-		struct elf_thread_status *tmp;
+		struct elf_thread_status *ets;
 		rcu_read_lock();
 		do_each_thread(g, p)
 			if (current->mm == p->mm && current != p) {
-				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
-				if (!tmp) {
+				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
+				if (!ets) {
 					rcu_read_unlock();
 					return 0;
 				}
-				tmp->thread = p;
-				list_add(&tmp->list, &info->thread_list);
+				ets->thread = p;
+				list_add(&ets->list, &info->thread_list);
 			}
 		while_each_thread(g, p);
 		rcu_read_unlock();
 		list_for_each(t, &info->thread_list) {
-			struct elf_thread_status *tmp;
 			int sz;
 
-			tmp = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(signr, tmp);
+			ets = list_entry(t, struct elf_thread_status, list);
+			sz = elf_dump_thread_status(signr, ets);
 			info->thread_status_size += sz;
 		}
 	}
@@ -1997,10 +1996,10 @@ static int elf_core_dump(long signr, str
 
 		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
-			struct vm_area_struct *vma;
+			struct vm_area_struct *tmp_vma;
 
 			if (get_user_pages(current, current->mm, addr, 1, 0, 1,
-						&page, &vma) <= 0) {
+						&page, &tmp_vma) <= 0) {
 				DUMP_SEEK(PAGE_SIZE);
 			} else {
 				if (page == ZERO_PAGE(0)) {
@@ -2010,7 +2009,7 @@ static int elf_core_dump(long signr, str
 					}
 				} else {
 					void *kaddr;
-					flush_cache_page(vma, addr,
+					flush_cache_page(tmp_vma, addr,
 							 page_to_pfn(page));
 					kaddr = kmap(page);
 					if ((size += PAGE_SIZE) > limit ||
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch

