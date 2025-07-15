Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E6E259C
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 00:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752537812; cv=none; b=q4JFaPsSDTn+HfTPlco6c/XhZagQHTEq1GawnCJKWhumJP6dAqSIMPMtlfG73HThBqqa8wTNXL98KNJVqK1EOHNkhrXp9gg2J9qPb9UNZolz3GcumpSzNUA0SF7zFQ9h85fODBMwusSMe4lwVdoqSeu36w8kq8OLQaQiBDB1las=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752537812; c=relaxed/simple;
	bh=vUmFUFLVTtI+3YS2nk4cCZx2q3upy+SbW/CEVlRQSPY=;
	h=Date:To:From:Subject:Message-Id; b=WIXHbNb+pP6d3Yj1LfLoTmH4Yusw/luWB981jx+VW90iL+YU6BqsY6Yd5Pp9xRDQcqghnU7JFJw3nUPqJu7XiGJBY7SjNvwTaqyj8XHRGAks/vNJj0k5kiFvHjBcst3U17PZMSjUfCt/yBIjrU/PXEMb3QgkoutuiQx08StG6PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jyV00zSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jyV00zSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDDAC4CEED;
	Tue, 15 Jul 2025 00:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752537812;
	bh=vUmFUFLVTtI+3YS2nk4cCZx2q3upy+SbW/CEVlRQSPY=;
	h=Date:To:From:Subject:From;
	b=jyV00zSgpJr8zuh8W8MTDNe8pveKjS2lA7Kn41wfZCb4aXPzQxYYnKHhxUYU57S8M
	 4Q2pdPHFzhgC7g6SEqTGL1jr3wHnqSZ3yTa+r9yHCHU3PulV8z9/tZT6NfvSYRJPRJ
	 V0sYB0sNjdDzoMVZeslmuuXSzWL8ABTcsy3HqskM=
Date: Mon, 14 Jul 2025 17:03:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-kpagecount-use-snapshot_page.patch added to mm-new branch
Message-Id: <20250715000332.4EDDAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: kpagecount: use snapshot_page()
has been added to the -mm mm-new branch.  Its filename is
     proc-kpagecount-use-snapshot_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-kpagecount-use-snapshot_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: proc: kpagecount: use snapshot_page()
Date: Mon, 14 Jul 2025 09:16:53 -0400

Currently, the call to folio_precise_page_mapcount() from kpage_read() can
race with a folio split.  When the race happens we trigger a
VM_BUG_ON_FOLIO() in folio_entire_mapcount() (see splat below).

This commit fixes this race by using snapshot_page() so that we retrieve
the folio mapcount using a folio snapshot.

[ 2356.558576] page: refcount:1 mapcount:1 mapping:0000000000000000 index:0xffff85200 pfn:0x6f7c00
[ 2356.558748] memcg:ffff000651775780
[ 2356.558763] anon flags: 0xafffff60020838(uptodate|dirty|lru|owner_2|swapbacked|node=1|zone=2|lastcpupid=0xfffff)
[ 2356.558796] raw: 00afffff60020838 fffffdffdb5d0048 fffffdffdadf7fc8 ffff00064c1629c1
[ 2356.558817] raw: 0000000ffff85200 0000000000000000 0000000100000000 ffff000651775780
[ 2356.558839] page dumped because: VM_BUG_ON_FOLIO(!folio_test_large(folio))
[ 2356.558882] ------------[ cut here ]------------
[ 2356.558897] kernel BUG at ./include/linux/mm.h:1103!
[ 2356.558982] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[ 2356.564729] CPU: 8 UID: 0 PID: 1864 Comm: folio-split-rac Tainted: G S      W           6.15.0+ #3 PREEMPT(voluntary)
[ 2356.566196] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
[ 2356.566814] Hardware name: Red Hat KVM, BIOS edk2-20241117-3.el9 11/17/2024
[ 2356.567684] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 2356.568563] pc : kpage_read.constprop.0+0x26c/0x290
[ 2356.569605] lr : kpage_read.constprop.0+0x26c/0x290
[ 2356.569992] sp : ffff80008fb739b0
[ 2356.570263] x29: ffff80008fb739b0 x28: ffff00064aa69580 x27: 00000000ff000000
[ 2356.570842] x26: 0000fffffffffff8 x25: ffff00064aa69580 x24: ffff80008fb73ae0
[ 2356.571411] x23: 0000000000000001 x22: 0000ffff86c6e8b8 x21: 0000000000000008
[ 2356.571978] x20: 00000000006f7c00 x19: 0000ffff86c6e8b8 x18: 0000000000000000
[ 2356.572581] x17: 3630303066666666 x16: 0000000000000003 x15: 0000000000001000
[ 2356.573217] x14: 00000000ffffffff x13: 0000000000000004 x12: 00aaaaaa00aaaaaa
[ 2356.577674] x11: 0000000000000000 x10: 00aaaaaa00aaaaaa x9 : ffffbf3afca6c300
[ 2356.578332] x8 : 0000000000000002 x7 : 0000000000000001 x6 : 0000000000000001
[ 2356.578984] x5 : ffff000c79812408 x4 : 0000000000000000 x3 : 0000000000000000
[ 2356.579635] x2 : 0000000000000000 x1 : ffff00064aa69580 x0 : 000000000000003e
[ 2356.580286] Call trace:
[ 2356.580524]  kpage_read.constprop.0+0x26c/0x290 (P)
[ 2356.580982]  kpagecount_read+0x28/0x40
[ 2356.581336]  proc_reg_read+0x38/0x100
[ 2356.581681]  vfs_read+0xcc/0x320
[ 2356.581992]  ksys_read+0x74/0x118
[ 2356.582306]  __arm64_sys_read+0x24/0x38
[ 2356.582668]  invoke_syscall+0x70/0x100
[ 2356.583022]  el0_svc_common.constprop.0+0x48/0xf8
[ 2356.583456]  do_el0_svc+0x28/0x40
[ 2356.583930]  el0_svc+0x38/0x118
[ 2356.584328]  el0t_64_sync_handler+0x144/0x168
[ 2356.584883]  el0t_64_sync+0x19c/0x1a0
[ 2356.585350] Code: aa0103e0 9003a541 91082021 97f813fc (d4210000)
[ 2356.586130] ---[ end trace 0000000000000000 ]---
[ 2356.587377] note: folio-split-rac[1864] exited with irqs disabled
[ 2356.588050] note: folio-split-rac[1864] exited with preempt_count 1

Link: https://lkml.kernel.org/r/1c05cc725b90962d56323ff2e28e9cc3ae397b68.1752499009.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reported-by: syzbot+3d7dc5eaba6b932f8535@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67812fbd.050a0220.d0267.0030.GAE@google.com/Reviewed-by: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/fs/proc/page.c~proc-kpagecount-use-snapshot_page
+++ a/fs/proc/page.c
@@ -43,6 +43,22 @@ static inline unsigned long get_max_dump
 #endif
 }
 
+static u64 get_kpage_count(const struct page *page)
+{
+	struct page_snapshot ps;
+	u64 ret;
+
+	snapshot_page(&ps, page);
+
+	if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
+		ret = folio_precise_page_mapcount(&ps.folio_snapshot,
+						  &ps.page_snapshot);
+	else
+		ret = folio_average_page_mapcount(&ps.folio_snapshot);
+
+	return ret;
+}
+
 static ssize_t kpage_read(struct file *file, char __user *buf,
 		size_t count, loff_t *ppos,
 		enum kpage_operation op)
@@ -75,10 +91,7 @@ static ssize_t kpage_read(struct file *f
 				info = stable_page_flags(page);
 				break;
 			case KPAGE_COUNT:
-				if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-					info = folio_precise_page_mapcount(page_folio(page), page);
-				else
-					info = folio_average_page_mapcount(page_folio(page));
+				info = get_kpage_count(page);
 				break;
 			case KPAGE_CGROUP:
 				info = page_cgroup_ino(page);
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-util-introduce-snapshot_page.patch
proc-kpagecount-use-snapshot_page.patch
fs-stable_page_flags-use-snapshot_page.patch

