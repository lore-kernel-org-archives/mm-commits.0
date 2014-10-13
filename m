From: akpm@linux-foundation.org
Subject: [merged]
 mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:20:03 -0700
Message-ID: <543c17d3.fk3FnrcDlxvIiLXY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaJMSUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: change alloc_pages_vma() to use mpol_cond_put()
has been removed from the -mm tree.  Its filename was
     mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: change alloc_pages_vma() to use mpol_cond_put()

Trivial cleanup. alloc_pages_vma() can use mpol_cond_put().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put
+++ a/mm/mempolicy.c
@@ -2046,8 +2046,7 @@ retry_cpuset:
 	page = __alloc_pages_nodemask(gfp, order,
 				      policy_zonelist(gfp, pol, node),
 				      policy_nodemask(gfp, pol));
-	if (unlikely(mpol_needs_cond_ref(pol)))
-		__mpol_put(pol);
+	mpol_cond_put(pol);
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

