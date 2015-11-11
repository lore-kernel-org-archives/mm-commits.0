From: akpm@linux-foundation.org
Subject: +
 mm-mmapc-remove-redundant-local-variables-for-may_expand_vm.patch added to
 -mm tree
Date: Wed, 11 Nov 2015 15:22:19 -0800
Message-ID: <5643cdab.V3w7sGz6vfKf+I+Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbbKKXWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 18:22:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove redundant local variables for may_expand_vm()
has been added to the -mm tree.  Its filename is
     mm-mmapc-remove-redundant-local-variables-for-may_expand_vm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-remove-redundant-local-variables-for-may_expand_vm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-remove-redundant-local-variables-for-may_expand_vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------

Chen Gang <gang.chen.5i5j@gmail.com>
Subject: mm/mmap.c: remove redundant local variables for may_expand_vm()

Simplify may_expand_vm()

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-remove-redundant-local-variables-for-may_expand_vm mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-remove-redundant-local-variables-for-may_expand_vm
+++ a/mm/mmap.c
@@ -2988,12 +2988,7 @@ out:
  */
 int may_expand_vm(struct mm_struct *mm, unsigned long npages)
 {
-	unsigned long cur = mm->total_vm;	/* pages */
-	unsigned long lim;
-
-	lim = rlimit(RLIMIT_AS) >> PAGE_SHIFT;
