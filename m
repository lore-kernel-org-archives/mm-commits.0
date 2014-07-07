From: akpm@linux-foundation.org
Subject: [merged]
 hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:28 -0700
Message-ID: <53bae2d0.wPyottnXIzXEFjcZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:51446 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaGGSL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:29 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so989590obc.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slaoub@gmail.com, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison: fix the handling path of the victimized page frame that belong to non-LRU
has been removed from the -mm tree.  Its filename was
     hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: hwpoison: fix the handling path of the victimized page frame that belong to non-LRU

Until now, the kernel has the same policy to handle victimized page frames
that belong to kernel-space(reserved/slab-subsystem) or non-LRU(unknown
page state).  In other word, the result of handling either of these
victimized page frames is (IGNORED | FAILED), and the return value of
memory_failure() is -EBUSY.

This patch is to avoid that memory_failure() returns very soon due to the
"true" value of (!PageLRU(p)), and it also ensures that action_result()
can report more precise information("reserved kernel", "kernel slab", and
"unknown page state") instead of "non LRU", especially for memory errors
which are detected by memory-scrubbing.

Andi said:

: While running the mcelog test suite on 3.14 I hit the following VM_BUG_ON:
: 
: soft_offline: 0x56d4: unknown non LRU page type 3ffff800008000
: page:ffffea000015b400 count:3 mapcount:2097169 mapping:          (null) index:0xffff8800056d7000
: page flags: 0x3ffff800004081(locked|slab|head)
: ------------[ cut here ]------------
: kernel BUG at mm/rmap.c:1495!
: 
: I think what happened is that a LRU page turned into a slab page in
: parallel with offlining.  memory_failure initially tests for this case,
: but doesn't retest later after the page has been locked.
: 
: ...
:
: I ran this patch in a loop over night with some stress plus 
: the mcelog test suite running in a loop. I cannot guarantee it hit it,
: but it should have given it a good beating.
: 
: The kernel survived with no messages, although the mcelog test suite
: got killed at some point because it couldn't fork anymore. Probably
: some unrelated problem.
: 
: So the patch is ok for me for .16.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur
+++ a/mm/memory-failure.c
@@ -895,7 +895,7 @@ static int hwpoison_user_mappings(struct
 	struct page *hpage = *hpagep;
 	struct page *ppage;
 
-	if (PageReserved(p) || PageSlab(p))
+	if (PageReserved(p) || PageSlab(p) || !PageLRU(p))
 		return SWAP_SUCCESS;
 
 	/*
@@ -1159,9 +1159,6 @@ int memory_failure(unsigned long pfn, in
 					action_result(pfn, "free buddy, 2nd try", DELAYED);
 				return 0;
 			}
-			action_result(pfn, "non LRU", IGNORED);
-			put_page(p);
-			return -EBUSY;
 		}
 	}
 
@@ -1194,6 +1191,9 @@ int memory_failure(unsigned long pfn, in
 		return 0;
 	}
 
+	if (!PageHuge(p) && !PageTransTail(p) && !PageLRU(p))
+		goto identify_page_state;
+
 	/*
 	 * For error on the tail page, we should set PG_hwpoison
 	 * on the head page to show that the hugepage is hwpoisoned
@@ -1243,6 +1243,7 @@ int memory_failure(unsigned long pfn, in
 		goto out;
 	}
 
+identify_page_state:
 	res = -EBUSY;
 	/*
 	 * The first check uses the current page flags which may not have any
_

Patches currently in -mm which might be from slaoub@gmail.com are


