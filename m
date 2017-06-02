From: akpm@linux-foundation.org
Subject: [patch 01/15] ksm: prevent crash after write_protect_page fails
Date: Fri, 02 Jun 2017 14:46:11 -0700
Message-ID: <5931dca3.MYeX0G1uKJyKskde%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVqM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, fsimonce@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: prevent crash after write_protect_page fails

"err" needs to be left set to -EFAULT if split_huge_page succeeds. 
Otherwise if "err" gets clobbered with zero and write_protect_page fails,
try_to_merge_one_page() will succeed instead of returning -EFAULT and then
try_to_merge_with_ksm_page() will continue thinking kpage is a PageKsm
when in fact it's still an anonymous page.  Eventually it'll crash in
page_add_anon_rmap.

This has been reproduced on Fedora25 kernel but I can reproduce with
upstream too.

The bug was introduced in commit
f765f540598a129dc4bb6f698fd4acc92f296c14 in v4.5.

page:fffff67546ce1cc0 count:4 mapcount:2 mapping:ffffa094551e36e1 index:0x7f0f46673
flags: 0x2ffffc0004007c(referenced|uptodate|dirty|lru|active|swapbacked)
page dumped because: VM_BUG_ON_PAGE(!PageLocked(page))
page->mem_cgroup:ffffa09674bf0000
------------[ cut here ]------------
kernel BUG at mm/rmap.c:1222!
invalid opcode: 0000 [#1] SMP
CPU: 1 PID: 76 Comm: ksmd Not tainted 4.9.3-200.fc25.x86_64 #1
task: ffffa0968be65b80 task.stack: ffffc0e941b3c000
RIP: 0010:[<ffffffff9a20ac94>]  [<ffffffff9a20ac94>] do_page_add_anon_rmap+0x1c4/0x240
RSP: 0018:ffffc0e941b3fd48  EFLAGS: 00010282
RAX: 0000000000000021 RBX: fffff67546ce1cc0 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffffa0969ec4e0a0
RBP: ffffc0e941b3fd70 R08: 0000000000018a84 R09: 0000000000000005
R10: fffff6754f87de00 R11: 000000000000049f R12: 00007fe6f5f67000
R13: ffffa094990ecc00 R14: 0000000000000000 R15: ffffa093c369c480
FS:  0000000000000000(0000) GS:ffffa0969ec40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4c21c221f0 CR3: 0000000152e07000 CR4: 00000000000426e0
Stack:
 fffff675470fd9c0 00007fe6f5f67000 fffff67540f8a900 ffffa094990ecc00
 ffffa093c369c480 ffffc0e941b3fd80 ffffffff9a20ad28 ffffc0e941b3fe00
 ffffffff9a228b4b 80000001c3f67807 0000000000000000 80000001c3f67805
Call Trace:
 [<ffffffff9a20ad28>] page_add_anon_rmap+0x18/0x20
 [<ffffffff9a228b4b>] try_to_merge_with_ksm_page+0x50b/0x780
 [<ffffffff9a229fd1>] ksm_scan_thread+0x1211/0x1410
 [<ffffffff9a0e7270>] ? prepare_to_wait_event+0x100/0x100
 [<ffffffff9a228dc0>] ? try_to_merge_with_ksm_page+0x780/0x780
 [<ffffffff9a0c2569>] kthread+0xd9/0xf0
 [<ffffffff9a0c2490>] ? kthread_park+0x60/0x60
 [<ffffffff9a81be55>] ret_from_fork+0x25/0x30

Fixes: f765f54059 ("ksm: prepare to new THP semantics")
Link: http://lkml.kernel.org/r/20170513131040.21732-1-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Federico Simoncelli <fsimonce@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/ksm.c~ksm-prevent-crash-after-write_protect_page-fails mm/ksm.c
--- a/mm/ksm.c~ksm-prevent-crash-after-write_protect_page-fails
+++ a/mm/ksm.c
@@ -1028,8 +1028,7 @@ static int try_to_merge_one_page(struct
 		goto out;
 
 	if (PageTransCompound(page)) {
-		err = split_huge_page(page);
-		if (err)
+		if (split_huge_page(page))
 			goto out_unlock;
 	}
 
_
