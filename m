From: akpm@linux-foundation.org
Subject: + proc-add-kpageidle-file-fix-6-fix-2.patch added to -mm tree
Date: Thu, 06 Aug 2015 12:59:17 -0700
Message-ID: <55c3bc95.kapnMVNOkQUk10R1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbbHFT7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2015 15:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, mhocko@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-kpageidle-file-fix-6-fix-2
has been added to the -mm tree.  Its filename is
     proc-add-kpageidle-file-fix-6-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-kpageidle-file-fix-6-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-kpageidle-file-fix-6-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: proc-add-kpageidle-file-fix-6-fix-2

hunks got lost during reject repairs

Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |  215 -----------------------------------------------
 1 file changed, 215 deletions(-)

diff -puN fs/proc/page.c~proc-add-kpageidle-file-fix-6-fix-2 fs/proc/page.c
--- a/fs/proc/page.c~proc-add-kpageidle-file-fix-6-fix-2
+++ a/fs/proc/page.c
@@ -278,221 +278,6 @@ static const struct file_operations proc
 };
 #endif /* CONFIG_MEMCG */
 
-#ifdef CONFIG_IDLE_PAGE_TRACKING
-/*
- * Idle page tracking only considers user memory pages, for other types of
- * pages the idle flag is always unset and an attempt to set it is silently
- * ignored.
- *
- * We treat a page as a user memory page if it is on an LRU list, because it is
- * always safe to pass such a page to rmap_walk(), which is essential for idle
- * page tracking. With such an indicator of user pages we can skip isolated
- * pages, but since there are not usually many of them, it will hardly affect
- * the overall result.
- *
- * This function tries to get a user memory page by pfn as described above.
- */
-static struct page *kpageidle_get_page(unsigned long pfn)
-{
-	struct page *page;
-	struct zone *zone;
-
-	if (!pfn_valid(pfn))
-		return NULL;
-
-	page = pfn_to_page(pfn);
-	if (!page || !PageLRU(page) ||
-	    !get_page_unless_zero(page))
-		return NULL;
-
-	zone = page_zone(page);
-	spin_lock_irq(&zone->lru_lock);
-	if (unlikely(!PageLRU(page))) {
-		put_page(page);
-		page = NULL;
-	}
-	spin_unlock_irq(&zone->lru_lock);
-	return page;
-}
-
-static int kpageidle_clear_pte_refs_one(struct page *page,
-					struct vm_area_struct *vma,
-					unsigned long addr, void *arg)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	spinlock_t *ptl;
-	pmd_t *pmd;
-	pte_t *pte;
-	bool referenced = false;
-
-	if (unlikely(PageTransHuge(page))) {
-		pmd = page_check_address_pmd(page, mm, addr,
-					     PAGE_CHECK_ADDRESS_PMD_FLAG, &ptl);
-		if (pmd) {
-			referenced = pmdp_clear_young_notify(vma, addr, pmd);
-			spin_unlock(ptl);
-		}
-	} else {
-		pte = page_check_address(page, mm, addr, &ptl, 0);
-		if (pte) {
-			referenced = ptep_clear_young_notify(vma, addr, pte);
-			pte_unmap_unlock(pte, ptl);
-		}
-	}
-	if (referenced) {
-		clear_page_idle(page);
-		/*
-		 * We cleared the referenced bit in a mapping to this page. To
-		 * avoid interference with page reclaim, mark it young so that
-		 * page_referenced() will return > 0.
-		 */
-		set_page_young(page);
-	}
-	return SWAP_AGAIN;
-}
-
-static void kpageidle_clear_pte_refs(struct page *page)
-{
-	/*
-	 * Since rwc.arg is unused, rwc is effectively immutable, so we
-	 * can make it static const to save some cycles and stack.
-	 */
-	static const struct rmap_walk_control rwc = {
-		.rmap_one = kpageidle_clear_pte_refs_one,
-		.anon_lock = page_lock_anon_vma_read,
-	};
-	bool need_lock;
-
-	if (!page_mapped(page) ||
-	    !page_rmapping(page))
-		return;
-
-	need_lock = !PageAnon(page) || PageKsm(page);
-	if (need_lock && !trylock_page(page))
-		return;
-
-	rmap_walk(page, (struct rmap_walk_control *)&rwc);
-
-	if (need_lock)
-		unlock_page(page);
-}
-
-static ssize_t kpageidle_read(struct file *file, char __user *buf,
-			      size_t count, loff_t *ppos)
-{
-	u64 __user *out = (u64 __user *)buf;
-	struct page *page;
-	unsigned long pfn, end_pfn;
-	ssize_t ret = 0;
-	u64 idle_bitmap = 0;
-	int bit;
-
-	if (*ppos & KPMMASK || count & KPMMASK)
-		return -EINVAL;
-
-	pfn = *ppos * BITS_PER_BYTE;
-	if (pfn >= max_pfn)
-		return 0;
-
-	end_pfn = pfn + count * BITS_PER_BYTE;
-	if (end_pfn > max_pfn)
-		end_pfn = ALIGN(max_pfn, KPMBITS);
-
-	for (; pfn < end_pfn; pfn++) {
-		bit = pfn % KPMBITS;
-		page = kpageidle_get_page(pfn);
-		if (page) {
-			if (page_is_idle(page)) {
-				/*
-				 * The page might have been referenced via a
-				 * pte, in which case it is not idle. Clear
-				 * refs and recheck.
-				 */
-				kpageidle_clear_pte_refs(page);
-				if (page_is_idle(page))
-					idle_bitmap |= 1ULL << bit;
-			}
-			put_page(page);
-		}
-		if (bit == KPMBITS - 1) {
-			if (put_user(idle_bitmap, out)) {
-				ret = -EFAULT;
-				break;
-			}
-			idle_bitmap = 0;
-			out++;
-		}
-	}
-
-	*ppos += (char __user *)out - buf;
-	if (!ret)
-		ret = (char __user *)out - buf;
-	return ret;
-}
-
-static ssize_t kpageidle_write(struct file *file, const char __user *buf,
-			       size_t count, loff_t *ppos)
-{
-	const u64 __user *in = (const u64 __user *)buf;
-	struct page *page;
-	unsigned long pfn, end_pfn;
-	ssize_t ret = 0;
-	u64 idle_bitmap = 0;
-	int bit;
-
-	if (*ppos & KPMMASK || count & KPMMASK)
-		return -EINVAL;
-
-	pfn = *ppos * BITS_PER_BYTE;
-	if (pfn >= max_pfn)
-		return -ENXIO;
-
-	end_pfn = pfn + count * BITS_PER_BYTE;
-	if (end_pfn > max_pfn)
-		end_pfn = ALIGN(max_pfn, KPMBITS);
-
-	for (; pfn < end_pfn; pfn++) {
-		bit = pfn % KPMBITS;
-		if (bit == 0) {
-			if (copy_from_user(&idle_bitmap, in, sizeof(u64))) {
-				ret = -EFAULT;
-				break;
-			}
-			in++;
-		}
-		if ((idle_bitmap >> bit) & 1) {
-			page = kpageidle_get_page(pfn);
-			if (page) {
-				kpageidle_clear_pte_refs(page);
-				set_page_idle(page);
-				put_page(page);
-			}
-		}
-	}
-
-	*ppos += (const char __user *)in - buf;
-	if (!ret)
-		ret = (const char __user *)in - buf;
-	return ret;
-}
-
-static const struct file_operations proc_kpageidle_operations = {
-	.llseek = mem_lseek,
-	.read = kpageidle_read,
-	.write = kpageidle_write,
-};
-
-#ifndef CONFIG_64BIT
-static bool need_page_idle(void)
-{
-	return true;
-}
-struct page_ext_operations page_idle_ops = {
-	.need = need_page_idle,
-};
-#endif
-#endif /* CONFIG_IDLE_PAGE_TRACKING */
-
 static int __init proc_page_init(void)
 {
 	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

user_ns-use-correct-check-for-single-threadedness.patch
memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-move-memcg_proto_active-from-sockh.patch
mm-vmscan-never-isolate-more-pages-than-necessary.patch
memcg-add-page_cgroup_ino-helper.patch
memcg-add-page_cgroup_ino-helper-fix.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
mmu-notifier-add-clear_young-callback-fix.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix.patch
proc-add-kpageidle-file-fix-2.patch
proc-add-kpageidle-file-fix-3.patch
proc-add-kpageidle-file-fix-4.patch
proc-add-kpageidle-file-fix-5.patch
proc-add-kpageidle-file-fix-6.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2.patch
proc-export-idle-flag-via-kpageflags.patch
proc-export-idle-flag-via-kpageflags-fix.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch
linux-next.patch

