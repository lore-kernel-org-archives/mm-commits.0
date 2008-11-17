From: akpm@linux-foundation.org
Subject: + memcg-handle-swap-caches-build-fix.patch added to -mm tree
Date: Sun, 16 Nov 2008 17:15:49 -0800
Message-ID: <200811170115.mAH1Fn4G023425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbYKQBQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Nov 2008 20:16:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: handle swap caches build fix
has been added to the -mm tree.  Its filename is
     memcg-handle-swap-caches-build-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: memcg: handle swap caches build fix
=46rom: Hugh Dickins <hugh@veritas.com>

=46ix to build error when CONFIG_SHMEM=3Dy but CONFIG_SWAP is not set:
mm/shmem.c: In function =E2=80=98shmem_unuse_inode=E2=80=99:
mm/shmem.c:927: error: implicit declaration of function =E2=80=98mem_cg=
roup_cache_charge_swapin=E2=80=99

Yes, there's a lot of code in mm/shmem.c which only comes into play whe=
n
CONFIG_SWAP=3Dy: better than this quick fix would be to restructure shm=
em.c
with all swap stuff in a separate file; that's on my mind, but now is n=
ot
the moment for it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/swap.h~memcg-handle-swap-caches-build-fix inclu=
de/linux/swap.h
--- a/include/linux/swap.h~memcg-handle-swap-caches-build-fix
+++ a/include/linux/swap.h
@@ -434,6 +434,12 @@ static inline swp_entry_t get_swap_page(
 #define has_swap_token(x) 0
 #define disable_swap_token() do { } while(0)
=20
+static inline int mem_cgroup_cache_charge_swapin(struct page *page,
+			struct mm_struct *mm, gfp_t mask, bool locked)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
lib-scatterlistc-fix-kunmap-argument-in-sg_miter_stop.patch
linux-next.patch
sprint_symbol-use-less-stack.patch
migration-fix-writepage-error.patch
vmscan-let-gfp_nofs-go-to-swap-again.patch
dont-unlink-an-active-swapfile.patch
mm-remove-unevictables-show_page_path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-memswap-controller-core.patch
prio_tree-debugging-patch.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
