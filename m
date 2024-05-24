Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4803D4084E;
	Fri, 24 May 2024 18:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576959; cv=none; b=jhUIF+/bdTfdVn7eVX3DiPYrrd+I6Hnh3RYStzy4Z5OwJpev/SU0M0qScrE7dpxLqZQeU0ADaBIhLkMevBLO1/OdQ9c8uNJBUNIRNu/Y25/XGvouxBAa/kkcO1AQJAS/WuXNpD2h2Pk8qQS6+I6c2oov4SdGe+a1M+0uU+MKv9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576959; c=relaxed/simple;
	bh=w/pSzyQhrcyqUo0+7rWU3kJ1Uh2t69wYEfak50r0Iwg=;
	h=Date:To:From:Subject:Message-Id; b=PJ6l6ORMZU6yDWhpyof4Y2xO7RtiiTe47UuKD+Ef14f6MbbqOj1ePP/Us5JAF7/dMj9ZMJ7hzfeD3KI88aD3vakIe3kc4xju48SiNcsGasz8B4PMgAi0Du+jTNm0K6LUd0hUo3dNMfuLnpm3HMuJkAkvXdMlkcL6tpZLCjwE9zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gKjCtyyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gKjCtyyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B377C2BBFC;
	Fri, 24 May 2024 18:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576959;
	bh=w/pSzyQhrcyqUo0+7rWU3kJ1Uh2t69wYEfak50r0Iwg=;
	h=Date:To:From:Subject:From;
	b=gKjCtyyAzhhcunByu50kYnTA54ZBB00FemGHv0FsDLvvuBQd6c9HYMpckDlqnHF7h
	 MT+kmG8P2fdptlgj2FYr39TdxXCPExXBLfQV96nv6xcdMo8F/wpVTzbOIH09Pr8rf4
	 JUro12vn2GudJEe83feAfdF2QkiwkurTOXzWIONw=
Date: Fri, 24 May 2024 11:55:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-handling-of-dissolved-but-not-taken-off-from-buddy-pages.patch removed from -mm tree
Message-Id: <20240524185559.1B377C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix handling of dissolved but not taken off from buddy pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-handling-of-dissolved-but-not-taken-off-from-buddy-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix handling of dissolved but not taken off from buddy pages
Date: Thu, 23 May 2024 15:12:17 +0800

When I did memory failure tests recently, below panic occurs:

page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8cee00
flags: 0x6fffe0000000000(node=1|zone=2|lastcpupid=0x7fff)
raw: 06fffe0000000000 dead000000000100 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000009 00000000ffffffff 0000000000000000
page dumped because: VM_BUG_ON_PAGE(!PageBuddy(page))
------------[ cut here ]------------
kernel BUG at include/linux/page-flags.h:1009!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:__del_page_from_free_list+0x151/0x180
RSP: 0018:ffffa49c90437998 EFLAGS: 00000046
RAX: 0000000000000035 RBX: 0000000000000009 RCX: ffff8dd8dfd1c9c8
RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff8dd8dfd1c9c0
RBP: ffffd901233b8000 R08: ffffffffab5511f8 R09: 0000000000008c69
R10: 0000000000003c15 R11: ffffffffab5511f8 R12: ffff8dd8fffc0c80
R13: 0000000000000001 R14: ffff8dd8fffc0c80 R15: 0000000000000009
FS:  00007ff916304740(0000) GS:ffff8dd8dfd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055eae50124c8 CR3: 00000008479e0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __rmqueue_pcplist+0x23b/0x520
 get_page_from_freelist+0x26b/0xe40
 __alloc_pages_noprof+0x113/0x1120
 __folio_alloc_noprof+0x11/0xb0
 alloc_buddy_hugetlb_folio.isra.0+0x5a/0x130
 __alloc_fresh_hugetlb_folio+0xe7/0x140
 alloc_pool_huge_folio+0x68/0x100
 set_max_huge_pages+0x13d/0x340
 hugetlb_sysctl_handler_common+0xe8/0x110
 proc_sys_call_handler+0x194/0x280
 vfs_write+0x387/0x550
 ksys_write+0x64/0xe0
 do_syscall_64+0xc2/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff916114887
RSP: 002b:00007ffec8a2fd78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000055eae500e350 RCX: 00007ff916114887
RDX: 0000000000000004 RSI: 000055eae500e390 RDI: 0000000000000003
RBP: 000055eae50104c0 R08: 0000000000000000 R09: 000055eae50104c0
R10: 0000000000000077 R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000000004 R14: 00007ff916216b80 R15: 00007ff916216a00
 </TASK>
Modules linked in: mce_inject hwpoison_inject
---[ end trace 0000000000000000 ]---

And before the panic, there had an warning about bad page state:

BUG: Bad page state in process page-types  pfn:8cee00
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8cee00
flags: 0x6fffe0000000000(node=1|zone=2|lastcpupid=0x7fff)
page_type: 0xffffff7f(buddy)
raw: 06fffe0000000000 ffffd901241c0008 ffffd901240f8008 0000000000000000
raw: 0000000000000000 0000000000000009 00000000ffffff7f 0000000000000000
page dumped because: nonzero mapcount
Modules linked in: mce_inject hwpoison_inject
CPU: 8 PID: 154211 Comm: page-types Not tainted 6.9.0-rc4-00499-g5544ec3178e2-dirty #22
Call Trace:
 <TASK>
 dump_stack_lvl+0x83/0xa0
 bad_page+0x63/0xf0
 free_unref_page+0x36e/0x5c0
 unpoison_memory+0x50b/0x630
 simple_attr_write_xsigned.constprop.0.isra.0+0xb3/0x110
 debugfs_attr_write+0x42/0x60
 full_proxy_write+0x5b/0x80
 vfs_write+0xcd/0x550
 ksys_write+0x64/0xe0
 do_syscall_64+0xc2/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f189a514887
RSP: 002b:00007ffdcd899718 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f189a514887
RDX: 0000000000000009 RSI: 00007ffdcd899730 RDI: 0000000000000003
RBP: 00007ffdcd8997a0 R08: 0000000000000000 R09: 00007ffdcd8994b2
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdcda199a8
R13: 0000000000404af1 R14: 000000000040ad78 R15: 00007f189a7a5040
 </TASK>

The root cause should be the below race:

 memory_failure
  try_memory_failure_hugetlb
   me_huge_page
    __page_handle_poison
     dissolve_free_hugetlb_folio
     drain_all_pages -- Buddy page can be isolated e.g. for compaction.
     take_page_off_buddy -- Failed as page is not in the buddy list.
	     -- Page can be putback into buddy after compaction.
    page_ref_inc -- Leads to buddy page with refcnt = 1.

Then unpoison_memory() can unpoison the page and send the buddy page back
into buddy list again leading to the above bad page state warning.  And
bad_page() will call page_mapcount_reset() to remove PageBuddy from buddy
page leading to later VM_BUG_ON_PAGE(!PageBuddy(page)) when trying to
allocate this page.

Fix this issue by only treating __page_handle_poison() as successful when
it returns 1.

Link: https://lkml.kernel.org/r/20240523071217.1696196-1-linmiaohe@huawei.com
Fixes: ceaf8fbea79a ("mm, hwpoison: skip raw hwpoison page in freeing 1GB hugepage")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-handling-of-dissolved-but-not-taken-off-from-buddy-pages
+++ a/mm/memory-failure.c
@@ -1221,7 +1221,7 @@ static int me_huge_page(struct page_stat
 		 * subpages.
 		 */
 		folio_put(folio);
-		if (__page_handle_poison(p) >= 0) {
+		if (__page_handle_poison(p) > 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		} else {
@@ -2091,7 +2091,7 @@ retry:
 	 */
 	if (res == 0) {
 		folio_unlock(folio);
-		if (__page_handle_poison(p) >= 0) {
+		if (__page_handle_poison(p) > 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		} else {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


