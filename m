From: akpm@linux-foundation.org
Subject: + mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch added
 to -mm tree
Date: Tue, 11 Aug 2015 14:14:09 -0700
Message-ID: <55ca65a1.6mma109DTk7jEBdP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbbHKVOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 17:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix panic due to split huge zero page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: fix panic due to split huge zero page

[ 1162.009854] ------------[ cut here ]------------
[ 1162.014485] kernel BUG at mm/huge_memory.c:1957!
[ 1162.019109] invalid opcode: 0000 [#1] SMP
[ 1162.023236] Modules linked in: snd_hda_codec_hdmi i915 rpcsec_gss_krb5 snd_hda_codec_realtek snd_hda_codec_generic nfsv4 dns_re
[ 1162.090181] CPU: 2 PID: 2576 Comm: test_huge Not tainted 4.2.0-rc5-mm1+ #27
[ 1162.097150] Hardware name: Dell Inc. OptiPlex 7020/0F5C5X, BIOS A03 01/08/2015
[ 1162.104378] task: ffff880204e3d600 ti: ffff8800db16c000 task.ti: ffff8800db16c000
[ 1162.111867] RIP: 0010:[<ffffffff811dea3b>]  [<ffffffff811dea3b>] split_huge_page_to_list+0xdb/0x120
[ 1162.120933] RSP: 0018:ffff8800db16fde8  EFLAGS: 00010246
[ 1162.126246] RAX: ffffea0002310000 RBX: ffffea0002310000 RCX: ffff88021edd2000
[ 1162.133383] RDX: 0000000000000011 RSI: 0000000000000000 RDI: ffffea0002310000
[ 1162.140530] RBP: ffff8800db16fe08 R08: 000000000000fffe R09: 0000000000000001
[ 1162.147668] R10: 0000000000000326 R11: 0000000000000326 R12: 000000000008c400
[ 1162.154809] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
[ 1162.161947] FS:  00007f36f7d2e740(0000) GS:ffff88021eb00000(0000) knlGS:0000000000000000
[ 1162.170043] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1162.175794] CR2: 00007f36eadffff8 CR3: 00000000a75db000 CR4: 00000000001406e0
[ 1162.182931] Stack:
[ 1162.184943]  ffff8800db16fe80 ffffea0002310000 000000000008c400 0000000000000001
[ 1162.192391]  ffff8800db16fe68 ffffffff811ecb4e ffffea0002310000 0000000000000001
[ 1162.199834]  ffff8800db16fe38 ffffea0002310000 ffff8800db16fe58 00007f36eae00000
[ 1162.207278] Call Trace:
[ 1162.209726]  [<ffffffff811ecb4e>] memory_failure+0x32e/0x7c0
[ 1162.215388]  [<ffffffff811b9f1b>] madvise_hwpoison+0x8b/0x160
[ 1162.221134]  [<ffffffff811ba680>] SyS_madvise+0x40/0x240
[ 1162.226450]  [<ffffffff81066777>] ? do_page_fault+0x37/0x90
[ 1162.232024]  [<ffffffff8166152e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1162.238467] Code: ff f0 41 ff 4c 24 30 74 0d 31 c0 48 83 c4 08 5b 41 5c 41 5d c9 c3 4c 89 e7 e8 e2 58 fd ff 48 83 c4 08 31 c0
[ 1162.258104] RIP  [<ffffffff811dea3b>] split_huge_page_to_list+0xdb/0x120
[ 1162.264815]  RSP <ffff8800db16fde8>
[ 1162.273447] ---[ end trace aee7ce0df8e44076 ]---

Testcase:

#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <errno.h>
#include <string.h>

#define MB 1024*1024

int main(void)
{
	char *mem;

	posix_memalign((void **)&mem, 2 * MB, 200 * MB);

	madvise(mem, 200 * MB, MADV_HWPOISON);

	free(mem);

	return 0;
}

Huge zero page is allocated if page fault w/o FAULT_FLAG_WRITE flag.
The get_user_pages_fast() which called in madvise_hwpoison() will get
huge zero page if the page is not allocated before. Huge zero page is
a tranparent huge page, however, it is not an anonymous page. memory_failure
will split the huge zero page and trigger BUG_ON(is_huge_zero_page(page));
After commit (98ed2b0: mm/memory-failure: give up error handling for
non-tail-refcounted thp), memory_failure will not catch non anon thp
from madvise_hwpoison path and this bug occur.

Fix it by catching non anon thp in memory_failure in order to not split
huge zero page in madvise_hwpoison path.

After patch:

[   51.825205] Injecting memory failure for page 0x202800 at 0x7fd8ae800000
[   51.825205] MCE: 0x202800: non anonymous thp
[...]

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-panic-due-to-split-huge-zero-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-panic-due-to-split-huge-zero-page
+++ a/mm/memory-failure.c
@@ -1146,8 +1146,11 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	if (!PageHuge(p) && PageTransHuge(hpage)) {
-		if (unlikely(split_huge_page(hpage))) {
-			pr_err("MCE: %#lx: thp split failed\n", pfn);
+		if (!PageAnon(hpage) || unlikely(split_huge_page(hpage))) {
+			if (!PageAnon(hpage))
+				pr_err("MCE: %#lx: non anonymous thp\n", pfn);
+			else if (unlikely(split_huge_page(hpage)))
+				pr_err("MCE: %#lx: thp split failed\n", pfn);
 			if (TestClearPageHWPoison(p))
 				atomic_long_sub(nr_pages, &num_poisoned_pages);
 			put_page(p);
_

Patches currently in -mm which might be from wanpeng.li@hotmail.com are

mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch
mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch

