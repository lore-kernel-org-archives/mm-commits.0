From: akpm@linux-foundation.org
Subject: +
 hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch added to -mm tree
Date: Wed, 11 Jun 2014 13:56:38 -0700
Message-ID: <5398c286.L8RSIdZlkfH2jxTU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaFKU4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 16:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, slaoub@gmail.com

Subject: + hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch added to -mm tree
To: slaoub@gmail.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 13:56:38 -0700


The patch titled
     Subject: hwpoison: fix the handling path of the victimized page frame that belong to non-LRU
has been added to the -mm tree.  Its filename is
     hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch
hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch

