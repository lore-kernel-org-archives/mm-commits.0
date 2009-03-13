From: akpm@linux-foundation.org
Subject: + nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch added to -mm tree
Date: Fri, 13 Mar 2009 13:05:47 -0700
Message-ID: <200903132005.n2DK5lsV020866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbZCMULj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 16:11:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, Enrik.Berkhan@ge.com, a.p.zijlstra@chello.nl, gerg@snapgear.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     nommu: make CONFIG_UNEVICTABLE_LRU available when CONFIG_MMU=n
has been added to the -mm tree.  Its filename is
     nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: make CONFIG_UNEVICTABLE_LRU available when CONFIG_MMU=n
From: David Howells <dhowells@redhat.com>

Make CONFIG_UNEVICTABLE_LRU available when CONFIG_MMU=n.  There's no logical
reason it shouldn't be available, and it can be used for ramfs.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Enrik Berkhan <Enrik.Berkhan@ge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/Kconfig~nommu-make-config_unevictable_lru-available-when-config_mmu=n mm/Kconfig
--- a/mm/Kconfig~nommu-make-config_unevictable_lru-available-when-config_mmu=n
+++ a/mm/Kconfig
@@ -206,7 +206,6 @@ config VIRT_TO_BUS
 config UNEVICTABLE_LRU
 	bool "Add LRU list to track non-evictable pages"
 	default y
-	depends on MMU
 	help
 	  Keeps unevictable pages off of the active and inactive pageout
 	  lists, so kswapd will not waste CPU time or have its balancing
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch
nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch
linux-next.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-present-backing-device-capabilities-for-mtd-chardevs.patch
nommu-add-support-for-direct-mapping-through-mtdconcat-if-possible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly-fix.patch
mtd-fix-a-bad-dependency-in-the-blackfin-code.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

