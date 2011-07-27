From: akpm@linux-foundation.org
Subject: [merged] fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:50 -0700
Message-ID: <201107271927.p6RJRaCs003225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359Ab1G0T2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dave@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, matt.fleming@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     fs/exec.c:acct_arg_size(): ptl is no longer needed for add_mm_counter()
has been removed from the -mm tree.  Its filename was
     fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/exec.c:acct_arg_size(): ptl is no longer needed for add_mm_counter()
From: Oleg Nesterov <oleg@redhat.com>

acct_arg_size() takes ->page_table_lock around add_mm_counter() if
!SPLIT_RSS_COUNTING.  This is not needed after 172703b0 ("mm: delete
non-atomic mm counter implementation").

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/exec.c~fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter fs/exec.c
--- a/fs/exec.c~fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter
+++ a/fs/exec.c
@@ -181,14 +181,7 @@ static void acct_arg_size(struct linux_b
 		return;
 
 	bprm->vma_pages = pages;
