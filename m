From: akpm@linux-foundation.org
Subject: +
 mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix.patch added to -mm tree
Date: Fri, 07 Feb 2014 13:44:57 -0800
Message-ID: <52f553d9.hnqcn1Jegn/t5gJM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaBGVo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 16:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, gong.chen@linux.intel.com, andi@firstfloor.org, akpm@linux-foundation.org

Subject: + mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix.patch added to -mm tree
To: akpm@linux-foundation.org,andi@firstfloor.org,gong.chen@linux.intel.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 13:44:57 -0800


The patch titled
     Subject: mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix

s/&&/&/

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix
+++ a/mm/memory-failure.c
@@ -945,7 +945,7 @@ static int hwpoison_user_mappings(struct
 			 * to it. Similarly, page lock is shifted.
 			 */
 			if (hpage != p) {
-				if (!(flags && MF_COUNT_INCREASED)) {
+				if (!(flags & MF_COUNT_INCREASED)) {
 					put_page(hpage);
 					get_page(p);
 				}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

