From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:13:51 -0700
Message-ID: <20170504191351.PS3tNgN75%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756344AbdEDTNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gong.chen@linux.intel.com, lkp@intel.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, xiaolong.ye@intel.com


The patch titled
     Subject: mm: hwpoison: call shake_page() after try_to_unmap() for mlocked page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -916,6 +916,7 @@ static bool hwpoison_user_mappings(struc
 	bool unmap_success;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
+	bool mlocked = PageMlocked(hpage);
 
 	/*
 	 * Here we are interested only in user-mapped pages, so skip any
@@ -980,6 +981,13 @@ static bool hwpoison_user_mappings(struc
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


