From: akpm@linux-foundation.org
Subject: + memcg-remove-experimental-from-swap-account-config.patch added to -mm tree
Date: Fri, 04 Jun 2010 13:59:14 -0700
Message-ID: <201006042059.o54KxEmU017440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756789Ab0FDU7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 16:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: remove experimental from swap account config
has been added to the -mm tree.  Its filename is
     memcg-remove-experimental-from-swap-account-config.patch

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
Subject: memcg: remove experimental from swap account config
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It's 11 months since we changed swap_map[] to indicates SWAP_HAS_CACHE.
Since that, memcg's swap accounting has been very stable and it seems
it can be maintained.

So, I'd like to remove EXPERIMENTAL from the config.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/Kconfig~memcg-remove-experimental-from-swap-account-config init/Kconfig
--- a/init/Kconfig~memcg-remove-experimental-from-swap-account-config
+++ a/init/Kconfig
@@ -577,8 +577,8 @@ config CGROUP_MEM_RES_CTLR
 	  could in turn add some fork/exit overhead.
 
 config CGROUP_MEM_RES_CTLR_SWAP
-	bool "Memory Resource Controller Swap Extension(EXPERIMENTAL)"
-	depends on CGROUP_MEM_RES_CTLR && SWAP && EXPERIMENTAL
+	bool "Memory Resource Controller Swap Extension"
+	depends on CGROUP_MEM_RES_CTLR && SWAP
 	help
 	  Add swap management feature to memory resource controller. When you
 	  enable this, you can limit mem+swap usage per cgroup. In other words,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

cgroup-alloc_css_id-increments-hierarchy-depth.patch
vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
memcg-remove-experimental-from-swap-account-config.patch

