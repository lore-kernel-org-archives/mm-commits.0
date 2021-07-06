Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2A2C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4CD26117A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhGFTMS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhGFTMS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DF3E6023F;
        Tue,  6 Jul 2021 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598578;
        bh=DigdlGayy/xTVAYuG/PJ3QgZQ4IoiAz+cI8XmIPQVfY=;
        h=Date:From:To:Subject:From;
        b=TliT7pOHHqbGnjCa1s4nyTZ0TE9jyCpPxaDYwQY2xYvwTrnkZpaC7r9imVLL0sc89
         0Z1aAgtQ9jdNp+NUoFU2c306bUjRkv9YWjL9Xv3LNt0wsh/bPzttKXKZJg6KLLvCzm
         W9+VzrSdb899asKWgVCKV8QsGtY0Wh13OT9SYuF0=
Date:   Tue, 06 Jul 2021 12:09:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  [merged]
 mm-page-writeback-kill-get_writeback_state-comments.patch removed from -mm
 tree
Message-ID: <20210706190938.su0D89Kku%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page-writeback: kill get_writeback_state() comments
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-kill-get_writeback_state-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page-writeback: kill get_writeback_state() comments

The get_writeback_state() has gone since 2006, kill related comments.

Link: https://lkml.kernel.org/r/20210508125026.56600-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/page-writeback.c~mm-page-writeback-kill-get_writeback_state-comments
+++ a/mm/page-writeback.c
@@ -1869,10 +1869,9 @@ DEFINE_PER_CPU(int, dirty_throttle_leaks
  * which was newly dirtied.  The function will periodically check the system's
  * dirty state and will initiate writeback if needed.
  *
- * On really big machines, get_writeback_state is expensive, so try to avoid
- * calling it too often (ratelimiting).  But once we're over the dirty memory
- * limit we decrease the ratelimiting by a lot, to prevent individual processes
- * from overshooting the limit by (ratelimit_pages) each.
+ * Once we're over the dirty memory limit we decrease the ratelimiting
+ * by a lot, to prevent individual processes from overshooting the limit
+ * by (ratelimit_pages) each.
  */
 void balance_dirty_pages_ratelimited(struct address_space *mapping)
 {
@@ -2045,8 +2044,6 @@ void laptop_sync_completion(void)
 /*
  * If ratelimit_pages is too high then we can get into dirty-data overload
  * if a large number of processes all perform writes at the same time.
- * If it is too low then SMP machines will call the (expensive)
- * get_writeback_state too often.
  *
  * Here we set ratelimit_pages to a level which ensures that when all CPUs are
  * dirtying in parallel, we cannot go more than 3% (1/32) over the dirty memory
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-setup_initial_init_mm-helper.patch
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

