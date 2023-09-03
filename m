Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226ABC71153
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 23:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbjICXm7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Sep 2023 19:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjICXm7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Sep 2023 19:42:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CFDED
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 16:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5175760B60
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 23:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50A7C433C8;
        Sun,  3 Sep 2023 23:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693784574;
        bh=6AaN5g/FU0uSFZyZmKFKL1iaHHz4hZFORwl+H5HzRTM=;
        h=Date:To:From:Subject:From;
        b=PU14jLm9OjgxDQ9Pz91vob3GGMq+npmaj147YnYsQ92LT0IKvatlnDXomMhEouYpG
         oQDskIqfOH7ztOJdXnCMbazlJTyz9yRSKN2yj6mXiUJTAtvUXCsffdmrtEXGHw5oj/
         m/x69VhN5liyBIUHwWTlbHOt4wCBw/BhQ5FdD2/0=
Date:   Sun, 03 Sep 2023 16:42:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, paulmck@kernel.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        tongtiangen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-use-rcu-lock-instead-of-tasklist_lock-when-collect_procs.patch added to mm-hotfixes-unstable branch
Message-Id: <20230903234254.A50A7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: use rcu lock instead of tasklist_lock when collect_procs()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-use-rcu-lock-instead-of-tasklist_lock-when-collect_procs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-use-rcu-lock-instead-of-tasklist_lock-when-collect_procs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: mm: memory-failure: use rcu lock instead of tasklist_lock when collect_procs()
Date: Mon, 28 Aug 2023 10:25:27 +0800

We found a softlock issue in our test, analyzed the logs, and found that
the relevant CPU call trace as follows:

CPU0:
  _do_fork
    -> copy_process()
      -> write_lock_irq(&tasklist_lock)  //Disable irq,waiting for
      					 //tasklist_lock

CPU1:
  wp_page_copy()
    ->pte_offset_map_lock()
      -> spin_lock(&page->ptl);        //Hold page->ptl
    -> ptep_clear_flush()
      -> flush_tlb_others() ...
        -> smp_call_function_many()
          -> arch_send_call_function_ipi_mask()
            -> csd_lock_wait()         //Waiting for other CPUs respond
	                               //IPI

CPU2:
  collect_procs_anon()
    -> read_lock(&tasklist_lock)       //Hold tasklist_lock
      ->for_each_process(tsk)
        -> page_mapped_in_vma()
          -> page_vma_mapped_walk()
	    -> map_pte()
              ->spin_lock(&page->ptl)  //Waiting for page->ptl

We can see that CPU1 waiting for CPU0 respond IPI，CPU0 waiting for CPU2
unlock tasklist_lock, CPU2 waiting for CPU1 unlock page->ptl. As a result,
softlockup is triggered.

For collect_procs_anon(), what we're doing is task list iteration, during
the iteration, with the help of call_rcu(), the task_struct object is freed
only after one or more grace periods elapse. the logic as follows:

release_task()
  -> __exit_signal()
    -> __unhash_process()
      -> list_del_rcu()

  -> put_task_struct_rcu_user()
    -> call_rcu(&task->rcu, delayed_put_task_struct)

delayed_put_task_struct()
  -> put_task_struct()
  -> if (refcount_sub_and_test())
     	__put_task_struct()
          -> free_task()

Therefore, under the protection of the rcu lock, we can safely use
get_task_struct() to ensure a safe reference to task_struct during the
iteration.

By removing the use of tasklist_lock in task list iteration, we can break
the softlock chain above.

The same logic can also be applied to:
 - collect_procs_file()
 - collect_procs_fsdax()
 - collect_procs_ksm()

Link: https://lkml.kernel.org/r/20230828022527.241693-1-tongtiangen@huawei.com
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c        |    3 ---
 mm/ksm.c            |    4 ++--
 mm/memory-failure.c |   16 ++++++++--------
 3 files changed, 10 insertions(+), 13 deletions(-)

--- a/mm/filemap.c~mm-memory-failure-use-rcu-lock-instead-of-tasklist_lock-when-collect_procs
+++ a/mm/filemap.c
@@ -121,9 +121,6 @@
  *    bdi.wb->list_lock		(zap_pte_range->set_page_dirty)
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
- *
- * ->i_mmap_rwsem
- *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
 static void page_cache_delete(struct address_space *mapping,
--- a/mm/ksm.c~mm-memory-failure-use-rcu-lock-instead-of-tasklist_lock-when-collect_procs
+++ a/mm/ksm.c
@@ -2909,7 +2909,7 @@ void collect_procs_ksm(struct page *page
 		struct anon_vma *av = rmap_item->anon_vma;
 
 		anon_vma_lock_read(av);
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		for_each_process(tsk) {
 			struct anon_vma_chain *vmac;
 			unsigned long addr;
@@ -2928,7 +2928,7 @@ void collect_procs_ksm(struct page *page
 				}
 			}
 		}
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		anon_vma_unlock_read(av);
 	}
 }
--- a/mm/memory-failure.c~mm-memory-failure-use-rcu-lock-instead-of-tasklist_lock-when-collect_procs
+++ a/mm/memory-failure.c
@@ -551,8 +551,8 @@ static void kill_procs(struct list_head
  * on behalf of the thread group. Return task_struct of the (first found)
  * dedicated thread if found, and return NULL otherwise.
  *
- * We already hold read_lock(&tasklist_lock) in the caller, so we don't
- * have to call rcu_read_lock/unlock() in this function.
+ * We already hold rcu lock in the caller, so we don't have to call
+ * rcu_read_lock/unlock() in this function.
  */
 static struct task_struct *find_early_kill_thread(struct task_struct *tsk)
 {
@@ -613,7 +613,7 @@ static void collect_procs_anon(struct pa
 		return;
 
 	pgoff = page_to_pgoff(page);
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
@@ -630,7 +630,7 @@ static void collect_procs_anon(struct pa
 			add_to_kill_anon_file(t, page, vma, to_kill);
 		}
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	anon_vma_unlock_read(av);
 }
 
@@ -646,7 +646,7 @@ static void collect_procs_file(struct pa
 	pgoff_t pgoff;
 
 	i_mmap_lock_read(mapping);
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	pgoff = page_to_pgoff(page);
 	for_each_process(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
@@ -666,7 +666,7 @@ static void collect_procs_file(struct pa
 				add_to_kill_anon_file(t, page, vma, to_kill);
 		}
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 
@@ -689,7 +689,7 @@ static void collect_procs_fsdax(struct p
 	struct task_struct *tsk;
 
 	i_mmap_lock_read(mapping);
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	for_each_process(tsk) {
 		struct task_struct *t = task_early_kill(tsk, true);
 
@@ -700,7 +700,7 @@ static void collect_procs_fsdax(struct p
 				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 #endif /* CONFIG_FS_DAX */
_

Patches currently in -mm which might be from tongtiangen@huawei.com are

mm-memory-failure-use-rcu-lock-instead-of-tasklist_lock-when-collect_procs.patch

