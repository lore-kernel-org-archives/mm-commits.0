From: akpm@linux-foundation.org
Subject: + elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:35:26 -0800
Message-ID: <200802152035.m1FKZQhj022565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536AbYBOUfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:35:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com


The patch titled
     elf: fix shadowed variables in fs/binfmt_elf.c
has been added to the -mm tree.  Its filename is
     elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1728,26 +1728,25 @@ static int fill_note_info(struct elfhdr 
 
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
@@ -2003,10 +2002,10 @@ static int elf_core_dump(long signr, str
 
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
@@ -2016,7 +2015,7 @@ static int elf_core_dump(long signr, str
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

uml-fix-initrd-printk.patch
arch-um-kernel-memc-fix-a-shadowed-variable.patch
fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
