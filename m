From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page.patch added to -mm tree
Date: Wed, 26 Apr 2017 15:30:52 -0700
Message-ID: <59011f9c.GKRHLNjwlwaIvtnZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031659AbdDZWay (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Apr 2017 18:30:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, gong.chen@linux.intel.com, lkp@intel.com, xiaolong.ye@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: call shake_page() after try_to_unmap() for mlocked page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: call shake_page() after try_to_unmap() for mlocked page

Memory error handler calls try_to_unmap() for error pages in various
states. If the error page is a mlocked page, error handling could fail
with "still referenced by 1 users" message. This is because the page
is linked to and stays in lru cache after the following call chain.

  try_to_unmap_one
    page_remove_rmap
      clear_page_mlock
        putback_lru_page
          lru_cache_add

memory_failure() calls shake_page() to hanlde the similar issue, but
current code doesn't cover because shake_page() is called only before
try_to_unmap(). So this patches adds shake_page().

Fixes: 23a003bfd23ea9ea0b7756b920e51f64b284b468 ("mm/madvise: pass return code of memory_failure() to userspace")
Link: http://lkml.kernel.org/r/20170417055948.GM31394@yexl-desktop
Link: http://lkml.kernel.org/r/1493197841-23986-3-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Xiaolong Ye <xiaolong.ye@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page
+++ a/mm/memory-failure.c
@@ -919,6 +919,7 @@ static bool hwpoison_user_mappings(struc
 	bool unmap_success;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
+	bool mlocked = PageMlocked(hpage);
 
 	/*
 	 * Here we are interested only in user-mapped pages, so skip any
@@ -983,6 +984,13 @@ static bool hwpoison_user_mappings(struc
 		       pfn, page_mapcount(hpage));
 
 	/*
+	 * try_to_unmap() might put mlocked page in lru cache, so call
+	 * shake_page() again to ensure that it's flushed.
+	 */
+	if (mlocked)
+		shake_page(hpage, 0);
+
+	/*
 	 * Now that the dirty bit has been propagated to the
 	 * struct page and all unmaps done we can decide if
 	 * killing is needed or not.  Only kill when the page
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hwpoison-call-shake_page-unconditionally.patch
mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page.patch

