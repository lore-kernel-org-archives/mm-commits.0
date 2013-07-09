From: akpm@linux-foundation.org
Subject: [merged]
 mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:01 -0700
Message-ID: <51dc9aa1.etHKTKTwurUV7S+H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3GIXUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,rientjes@google.com,toshi.kani@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:01 -0700


The patch titled
     Subject: mm/sparse.c: put clear_hwpoisoned_pages within CONFIG_MEMORY_HOTREMOVE
has been removed from the -mm tree.  Its filename was
     mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/sparse.c: put clear_hwpoisoned_pages within CONFIG_MEMORY_HOTREMOVE

With CONFIG_MEMORY_HOTREMOVE unset, there is a compile warning:

mm/sparse.c:755: warning: `clear_hwpoisoned_pages' defined but not used

And Bisecting it ended up pointing to 4edd7ceff ("mm, hotplug: avoid
compiling memory hotremove functions when disabled").

This is because the commit above put sparse_remove_one_section() within
the protection of CONFIG_MEMORY_HOTREMOVE but the only user of
clear_hwpoisoned_pages() is sparse_remove_one_section(), and it is not
within the protection of CONFIG_MEMORY_HOTREMOVE.

So put clear_hwpoisoned_pages within CONFIG_MEMORY_HOTREMOVE should fix
the warning.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove mm/sparse.c
--- a/mm/sparse.c~mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove
+++ a/mm/sparse.c
@@ -753,6 +753,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 #ifdef CONFIG_MEMORY_FAILURE
 static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
 {
@@ -774,7 +775,6 @@ static inline void clear_hwpoisoned_page
 }
 #endif
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 {
 	struct page *usemap_page;
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch

