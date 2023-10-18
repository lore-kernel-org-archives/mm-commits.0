Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78288CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbjJRV7w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbjJRVf2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8411B1
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E1FC433D9;
        Wed, 18 Oct 2023 21:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664895;
        bh=I/dhhNKO+VmKv3p9uyG2HwmUqaR5tMBx08+M/1iegAg=;
        h=Date:To:From:Subject:From;
        b=t1hV4ZOA4nREqKn3p348cOwcVpFpdyXMQklzSOkWKjllXTSZn6MUJch1ryPrWH8hj
         I2jdaH/A/EUPPtmgBDKddGBAegMrSDzM2C2FvvgAcvTPG98RLxJn6vuEUKkg0uqZ9K
         KDiQMXUT2K4ToVcEq5UpxgPgVHnt63DKVxqQDZfo=
Date:   Wed, 18 Oct 2023 14:34:54 -0700
To:     mm-commits@vger.kernel.org, yun.zhou@windriver.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, vbabka@suse.cz,
        surenb@google.com, shy828301@gmail.com, shuah@kernel.org,
        rppt@kernel.org, pgofman@codeweavers.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, namit@vmware.com,
        mirq-linux@rere.qmqm.pl, Liam.Howlett@oracle.com,
        gustavoars@kernel.org, gregkh@linuxfoundation.org,
        gorcunov@gmail.com, emmir@google.com, david@redhat.com,
        dan.j.williams@intel.com, brauner@kernel.org,
        axelrasmussen@google.com, avagin@gmail.com, alex.sierra@amd.com,
        usama.anjum@collabora.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-add-fast-paths-to-get-clear-page_is_written-flag.patch removed from -mm tree
Message-Id: <20231018213455.04E1FC433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-add-fast-paths-to-get-clear-page_is_written-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag
Date: Mon, 21 Aug 2023 19:15:15 +0500

Adding fast code paths to handle specifically only get and/or clear
operation of PAGE_IS_WRITTEN, increases its performance by 0-35%.  The
results of some test cases are given below:

Test-case-1
t1 = (Get + WP) time
t2 = WP time
                       t1            t2
Without this patch:    140-170mcs    90-115mcs
With this patch:       110mcs        80mcs
Worst case diff:       35% faster    30% faster

Test-case-2
t3 = atomic Get and WP
                      t3
Without this patch:   120-140mcs
With this patch:      100-110mcs
Worst case diff:      21% faster

Link: https://lkml.kernel.org/r/20230821141518.870589-4-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Miroslaw <emmir@google.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul Gofman <pgofman@codeweavers.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yun Zhou <yun.zhou@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-add-fast-paths-to-get-clear-page_is_written-flag
+++ a/fs/proc/task_mmu.c
@@ -2145,6 +2145,41 @@ static int pagemap_scan_pmd_entry(pmd_t
 		return 0;
 	}
 
+	if (!p->vec_out) {
+		/* Fast path for performing exclusive WP */
+		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
+			if (pte_uffd_wp(ptep_get(pte)))
+				continue;
+			make_uffd_wp_pte(vma, addr, pte);
+			if (!flush_end)
+				start = addr;
+			flush_end = addr + PAGE_SIZE;
+		}
+		goto flush_and_return;
+	}
+
+	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	    p->arg.category_mask == PAGE_IS_WRITTEN &&
+	    p->arg.return_mask == PAGE_IS_WRITTEN) {
+		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
+			unsigned long next = addr + PAGE_SIZE;
+
+			if (pte_uffd_wp(ptep_get(pte)))
+				continue;
+			ret = pagemap_scan_output(p->cur_vma_category | PAGE_IS_WRITTEN,
+						  p, addr, &next);
+			if (next == addr)
+				break;
+			if (~p->arg.flags & PM_SCAN_WP_MATCHING)
+				continue;
+			make_uffd_wp_pte(vma, addr, pte);
+			if (!flush_end)
+				start = addr;
+			flush_end = next;
+		}
+		goto flush_and_return;
+	}
+
 	for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
 		unsigned long categories = p->cur_vma_category |
 					   pagemap_page_category(p, vma, addr, ptep_get(pte));
@@ -2168,6 +2203,7 @@ static int pagemap_scan_pmd_entry(pmd_t
 		flush_end = next;
 	}
 
+flush_and_return:
 	if (flush_end)
 		flush_tlb_range(vma, start, addr);
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


