From: akpm@linux-foundation.org
Subject: + powerpc-allow-256kb-pages-with-shmem.patch added to -mm tree
Date: Thu, 09 Apr 2009 16:36:23 -0700
Message-ID: <200904092336.n39NaNLG025326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZDIXja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 19:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, paulus@samba.org, yur@emcraft.com


The patch titled
     powerpc: allow 256kB pages with SHMEM
has been added to the -mm tree.  Its filename is
     powerpc-allow-256kb-pages-with-shmem.patch

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
Subject: powerpc: allow 256kB pages with SHMEM
From: Hugh Dickins <hugh@veritas.com>

Now that shmem's divisions by zero and SHMEM_MAX_BYTES are fixed,
let powerpc 256kB pages coexist with CONFIG_SHMEM again.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Yuri Tikhonov <yur@emcraft.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/Kconfig~powerpc-allow-256kb-pages-with-shmem arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-allow-256kb-pages-with-shmem
+++ a/arch/powerpc/Kconfig
@@ -462,7 +462,7 @@ config PPC_64K_PAGES
 
 config PPC_256K_PAGES
 	bool "256k page size" if 44x
-	depends on !STDBINUTILS && (!SHMEM || BROKEN)
+	depends on !STDBINUTILS
 	help
 	  Make the page size 256k.
 
_

Patches currently in -mm which might be from hugh@veritas.com are

clocksource-pass-clocksource-to-read-callback.patch
mm-disable-preemption-in-apply_to_pte_range.patch
shmem-fix-division-by-zero.patch
shmem-respect-max_lfs_filesize.patch
powerpc-allow-256kb-pages-with-shmem.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch

