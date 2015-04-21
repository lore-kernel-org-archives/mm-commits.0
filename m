From: akpm@linux-foundation.org
Subject: + mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
 added to -mm tree
Date: Tue, 21 Apr 2015 16:38:56 -0700
Message-ID: <5536df90.LiNGVbYOCUdCFKLB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868AbbDUXi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Apr 2015 19:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: add comment describing when to add new cases
has been added to the -mm tree.  Its filename is
     mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-memory-failure-call-shake_page-when-error-hits-thp-tail-page.patch
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
hexdump-make-test-data-really-const.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

