Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C462FC48BCD
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA376105A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhFHA2x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhFHA2w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:28:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8291E6105A;
        Tue,  8 Jun 2021 00:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112004;
        bh=vHmncLmlYbHYlHxp0LY/gtILrWw9uVgZngJl/IEqC3k=;
        h=Date:From:To:Subject:From;
        b=qLFuaQaCAAH9NVhB0pgXusU83AcYpY1DpOlI10h5mzN6Qa8XUen8ipjQ/0fGgIeNd
         n7DJg7QlEOXwe7GgZQFk3qWuTWSdIG7l7exthTNNfmfTs4GyZbru7Jy/axms6sSlsu
         mcitxvnJZ6yz4hC/pFVXqPe10c/oL1e6YHYwURjQ=
Date:   Mon, 07 Jun 2021 17:26:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        wangkefeng.wang@huawei.com
Subject:  [failures] mm-add-setup_initial_init_mm-helper-v3.patch
 removed from -mm tree
Message-ID: <20210608002644.DmOp1YMAA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-setup_initial_init_mm-helper-v3
has been removed from the -mm tree.  Its filename was
     mm-add-setup_initial_init_mm-helper-v3.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-add-setup_initial_init_mm-helper-v3

uninline setup_initial_init_mm()

Link: https://lkml.kernel.org/r/20210607023611.159804-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/init-mm.c       |    9 +++++++++
 2 files changed, 12 insertions(+)

--- a/include/linux/mm.h~mm-add-setup_initial_init_mm-helper-v3
+++ a/include/linux/mm.h
@@ -244,6 +244,9 @@ int __add_to_page_cache_locked(struct pa
 
 #define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
 
+void setup_initial_init_mm(void *start_code, void *end_code,
+			   void *end_data, void *brk);
+
 /*
  * Linux kernel virtual memory manager primitives.
  * The idea being to have a "virtual" mm in the same way
--- a/mm/init-mm.c~mm-add-setup_initial_init_mm-helper-v3
+++ a/mm/init-mm.c
@@ -40,3 +40,12 @@ struct mm_struct init_mm = {
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
 };
+
+void setup_initial_init_mm(void *start_code, void *end_code,
+			   void *end_data, void *brk)
+{
+	init_mm.start_code = (unsigned long)start_code;
+	init_mm.end_code = (unsigned long)end_code;
+	init_mm.end_data = (unsigned long)end_data;
+	init_mm.brk = (unsigned long)brk;
+}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
arc-convert-to-setup_initial_init_mm.patch
arm-convert-to-setup_initial_init_mm.patch
arm64-convert-to-setup_initial_init_mm.patch
csky-convert-to-setup_initial_init_mm.patch
h8300-convert-to-setup_initial_init_mm.patch
m68k-convert-to-setup_initial_init_mm.patch
nds32-convert-to-setup_initial_init_mm.patch
nios2-convert-to-setup_initial_init_mm.patch
openrisc-convert-to-setup_initial_init_mm.patch
powerpc-convert-to-setup_initial_init_mm.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

