From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:37:19 -0700
Message-ID: <5591ac7f.3ThezTZTH+LFa2oB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbbF2UhU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: add comment describing when to add new cases
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: mm, hwpoison: add comment describing when to add new cases

Here's another comment fix for hwpoison.

It describes the "guiding principle" on when to add new
memory error recovery code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-add-comment-describing-when-to-add-new-cases mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-add-comment-describing-when-to-add-new-cases
+++ a/mm/memory-failure.c
@@ -20,6 +20,14 @@
  * this code has to be extremely careful. Generally it tries to use 
  * normal locking rules, as in get the standard locks, even if that means 
  * the error handling takes potentially a long time.
+ *
+ * It can be very tempting to add handling for obscure cases here.
+ * In general any code for handling new cases should only be added iff:
+ * - You know how to test it.
+ * - You have a test that can be added to mce-test
+ *   https://git.kernel.org/cgit/utils/cpu/mce/mce-test.git/
+ * - The case actually shows up as a frequent (top 10) page state in
+ *   tools/vm/page-types when running a real workload.
  * 
  * There are several operations here with exponential complexity because
  * of unsuitable VM data structures. For example the operation to map back 
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

