Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61660C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjDRXjk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjDRXhi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C3910271
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C786660EF0
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F43C433EF;
        Tue, 18 Apr 2023 23:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860964;
        bh=tAsdBnCN3zgcds/G7IU28WaGaEJGfhhrAM9Q7paUVzw=;
        h=Date:To:From:Subject:From;
        b=wrJalviQc4GYwm06k000La5kbIPHGE3XZLeuoxkNXVtJbIDVmgYvpIARrg+swdzRC
         sht91gFT59kNBnPjoSSol8vSxXTnBJ5lWpoThbTitBCDCCFEG06OOWYStBRoNXimMX
         u2Ygp4cuf84jXA45aUbiZEE2NpXnklgOkQrKdyEI=
Date:   Tue, 18 Apr 2023 16:36:03 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, xialonglong1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-refactor-add_to_kill.patch removed from -mm tree
Message-Id: <20230418233604.28F43C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: refactor add_to_kill()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-refactor-add_to_kill.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong1@huawei.com>
Subject: mm: memory-failure: refactor add_to_kill()
Date: Fri, 14 Apr 2023 10:17:40 +0800

Patch series "mm: ksm: support hwpoison for ksm page", v2.

Currently, ksm does not support hwpoison.  As ksm is being used more
widely for deduplication at the system level, container level, and process
level, supporting hwpoison for ksm has become increasingly important. 
However, ksm pages were not processed by hwpoison in 2009 [1].

The main method of implementation:

1. Refactor add_to_kill() and add new add_to_kill_*() to better
   accommodate the handling of different types of pages.

2.  Add collect_procs_ksm() to collect processes when the error hit an
   ksm page.

3. Add task_in_to_kill_list() to avoid duplicate addition of tsk to
   the to_kill list.  

4. Try_to_unmap ksm page (already supported).

5. Handle related processes such as sending SIGBUS.

Tested with poisoning to ksm page from
1) different process
2) one process

and with/without memory_failure_early_kill set, the processes are killed
as expected with the patchset.  

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
commit/?h=01e00f880ca700376e1845cf7a2524ebe68e47d6


This patch (of 2):

The page_address_in_vma() is used to find the user virtual address of page
in add_to_kill(), but it doesn't support ksm due to the ksm page->index
unusable, add an ksm_addr as parameter to add_to_kill(), let's the caller
to pass it, also rename the function to __add_to_kill(), and adding
add_to_kill_anon_file() for handling anonymous pages and file pages,
adding add_to_kill_fsdax() for handling fsdax pages.

Link: https://lkml.kernel.org/r/20230414021741.2597273-1-xialonglong1@huawei.com
Link: https://lkml.kernel.org/r/20230414021741.2597273-2-xialonglong1@huawei.com
Signed-off-by: Longlong Xia <xialonglong1@huawei.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-refactor-add_to_kill
+++ a/mm/memory-failure.c
@@ -405,9 +405,9 @@ static unsigned long dev_pagemap_mapping
  * page->mapping are sufficient for mapping the page back to its
  * corresponding user virtual address.
  */
-static void add_to_kill(struct task_struct *tsk, struct page *p,
-			pgoff_t fsdax_pgoff, struct vm_area_struct *vma,
-			struct list_head *to_kill)
+static void __add_to_kill(struct task_struct *tsk, struct page *p,
+			  struct vm_area_struct *vma, struct list_head *to_kill,
+			  unsigned long ksm_addr, pgoff_t fsdax_pgoff)
 {
 	struct to_kill *tk;
 
@@ -417,7 +417,7 @@ static void add_to_kill(struct task_stru
 		return;
 	}
 
-	tk->addr = page_address_in_vma(p, vma);
+	tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
 	if (is_zone_device_page(p)) {
 		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
 			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
@@ -448,6 +448,13 @@ static void add_to_kill(struct task_stru
 	list_add_tail(&tk->nd, to_kill);
 }
 
+static void add_to_kill_anon_file(struct task_struct *tsk, struct page *p,
+				  struct vm_area_struct *vma,
+				  struct list_head *to_kill)
+{
+	__add_to_kill(tsk, p, vma, to_kill, 0, FSDAX_INVALID_PGOFF);
+}
+
 /*
  * Kill the processes that have been collected earlier.
  *
@@ -573,7 +580,7 @@ static void collect_procs_anon(struct pa
 				continue;
 			if (!page_mapped_in_vma(page, vma))
 				continue;
-			add_to_kill(t, page, FSDAX_INVALID_PGOFF, vma, to_kill);
+			add_to_kill_anon_file(t, page, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -609,8 +616,7 @@ static void collect_procs_file(struct pa
 			 * to be informed of all such data corruptions.
 			 */
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, FSDAX_INVALID_PGOFF, vma,
-					    to_kill);
+				add_to_kill_anon_file(t, page, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -618,6 +624,13 @@ static void collect_procs_file(struct pa
 }
 
 #ifdef CONFIG_FS_DAX
+static void add_to_kill_fsdax(struct task_struct *tsk, struct page *p,
+			      struct vm_area_struct *vma,
+			      struct list_head *to_kill, pgoff_t pgoff)
+{
+	__add_to_kill(tsk, p, vma, to_kill, 0, pgoff);
+}
+
 /*
  * Collect processes when the error hit a fsdax page.
  */
@@ -637,7 +650,7 @@ static void collect_procs_fsdax(struct p
 			continue;
 		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, pgoff, vma, to_kill);
+				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
 	}
 	read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from xialonglong1@huawei.com are

mm-ksm-support-hwpoison-for-ksm-page.patch

