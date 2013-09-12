From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:39 -0700
Message-ID: <523219e3.8C0FPrvqizPKEua6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3ILTpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:39 -0700


The patch titled
     Subject: mm/memory-failure.c: fix bug triggered by unpoisoning empty zero page
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/memory-failure.c: fix bug triggered by unpoisoning empty zero page

[   57.579580] Injecting memory failure for page 0x19d0 at 0xb77d2000
[   57.579824] MCE 0x19d0: non LRU page recovery: Ignored
[   91.290453] MCE: Software-unpoisoned page 0x19d0
[   91.290456] BUG: Bad page state in process bash  pfn:019d0
[   91.290466] page:f3461a00 count:0 mapcount:0 mapping:  (null) index:0x0
[   91.290467] page flags: 0x40000404(referenced|reserved)
[   91.290469] Modules linked in: nfsd auth_rpcgss i915 nfs_acl nfs lockd video drm_kms_helper drm bnep rfcomm sunrpc bluetooth psmouse parport_pc ppdev lp serio_raw fscache parport gpio_ich lpc_ich mac_hid i2c_algo_bit tpm_tis wmi usb_storage hid_generic usbhid hid e1000e firewire_ohci firewire_core ahci ptp libahci pps_core crc_itu_t
[   91.290486] CPU: 3 PID: 2123 Comm: bash Not tainted 3.11.0-rc6+ #12
[   91.290487] Hardware name: LENOVO 7034DD7/        , BIOS 9HKT47AUS 01//2012
[   91.290488]  00000000 00000000 e9625ea0 c15ec49b f3461a00 e9625eb8 c15ea119 c17cbf18
[   91.290491]  ef084314 000019d0 f3461a00 e9625ed8 c110dc8a f3461a00 00000001 00000000
[   91.290494]  f3461a00 40000404 00000000 e9625ef8 c110dcc1 f3461a00 f3461a00 000019d0
[   91.290497] Call Trace:
[   91.290501]  [<c15ec49b>] dump_stack+0x41/0x52
[   91.290504]  [<c15ea119>] bad_page+0xcf/0xeb
[   91.290515]  [<c110dc8a>] free_pages_prepare+0x12a/0x140
[   91.290517]  [<c110dcc1>] free_hot_cold_page+0x21/0x110
[   91.290519]  [<c11123c1>] __put_single_page+0x21/0x30
[   91.290521]  [<c1112815>] put_page+0x25/0x40
[   91.290524]  [<c11544e7>] unpoison_memory+0x107/0x200
[   91.290526]  [<c104a537>] ? ns_capable+0x27/0x60
[   91.290528]  [<c1155720>] hwpoison_unpoison+0x20/0x30
[   91.290530]  [<c1178266>] simple_attr_write+0xb6/0xd0
[   91.290532]  [<c11781b0>] ? generic_fh_to_dentry+0x50/0x50
[   91.290535]  [<c1158c60>] vfs_write+0xa0/0x1b0
[   91.290537]  [<c11781b0>] ? generic_fh_to_dentry+0x50/0x50
[   91.290539]  [<c11590df>] SyS_write+0x4f/0x90
[   91.290549]  [<c15f9a81>] sysenter_do_call+0x12/0x22
[   91.290550] Disabling lock debugging due to kernel taint

Testcase:

#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <errno.h>

#define PAGES_TO_TEST 1
#define PAGE_SIZE	4096

int main(void)
{
	char *mem;

	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

	if (madvise(mem, PAGES_TO_TEST * PAGE_SIZE, MADV_HWPOISON) == -1)
		return -1;

	munmap(mem, PAGES_TO_TEST * PAGE_SIZE);

	return 0;
}

There is one page reference count for default empty zero page,
madvise_hwpoison add another one by get_user_pages_fast.  memory_hwpoison
reduce one page reference count since it's a non LRU page. 
unpoison_memory release the last page reference count and free empty zero
page to buddy system which is not correct since empty zero page has
PG_reserved flag.  This patch fix it by don't reduce the page reference
count under 1 against empty zero page.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page
+++ a/mm/memory-failure.c
@@ -1388,7 +1388,7 @@ int unpoison_memory(unsigned long pfn)
 	unlock_page(page);
 
 	put_page(page);
-	if (freeit)
+	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
 		put_page(page);
 
 	return 0;
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

