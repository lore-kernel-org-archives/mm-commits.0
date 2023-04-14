Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872BBC77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 21:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDNVXi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 17:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjDNVXi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 17:23:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3D392
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 14:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59D4464A5A
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 21:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FAFC433EF;
        Fri, 14 Apr 2023 21:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681507415;
        bh=P7no0iZA8EWsfUTheIXErHxxmYdWwJL4f8DWfbQTN2Y=;
        h=Date:To:From:Subject:From;
        b=gCA/c5GeGHEta7RvD2Q8BnP+D03n8UIs+VrCw0p9mSav5JVtIbBUW9YcqRDRxpWhE
         3qp1PkaPUa6xw3lXiSFY4SUtL8g2oUT0/p7ct6Qt1hpjQgpizJI9cEk4WPsl1OjIDh
         wV0aJOa8vJj7F88y3n6EBoQa3v7pjeK2utUSn/+A=
Date:   Fri, 14 Apr 2023 14:23:35 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, xialonglong1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-refactor-add_to_kill.patch added to mm-unstable branch
Message-Id: <20230414212335.B2FAFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: refactor add_to_kill()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-refactor-add_to_kill.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-refactor-add_to_kill.patch

This patch will later appear in the mm-unstable branch at
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

mm-memory-failure-refactor-add_to_kill.patch
mm-ksm-support-hwpoison-for-ksm-page.patch

