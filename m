From: akpm@linux-foundation.org
Subject: + unevictable-lru-infrastructure-nommu-fix.patch added to -mm tree
Date: Mon, 28 Jul 2008 23:51:26 -0700
Message-ID: <200807290651.m6T6pQ3h019642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYG2Gwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 02:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     unevictable-lru-infrastructure-nommu-fix
has been added to the -mm tree.  Its filename is
     unevictable-lru-infrastructure-nommu-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable-lru-infrastructure-nommu-fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Current unevictable infrastructure code depend on MMU.  Then, nommu build
cause following error.

mm/built-in.o(.text+0x1bb70): In function `truncate_complete_page':
: undefined reference to `__clear_page_mlock'
mm/built-in.o(.text+0x1ca90): In function `__invalidate_mapping_pages':
: undefined reference to `__clear_page_mlock'
mm/built-in.o(.text+0x1d29c): In function `invalidate_inode_pages2_range':
: undefined reference to `__clear_page_mlock'

So, adding dependency to Kconfig is better.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~unevictable-lru-infrastructure-nommu-fix mm/Kconfig
--- a/mm/Kconfig~unevictable-lru-infrastructure-nommu-fix
+++ a/mm/Kconfig
@@ -212,6 +212,7 @@ config VIRT_TO_BUS
 config UNEVICTABLE_LRU
 	bool "Add LRU list to track non-evictable pages"
 	default y
+	depends on MMU
 	help
 	  Keeps unevictable pages off of the active and inactive pageout
 	  lists, so kswapd will not waste CPU time or have its balancing
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

