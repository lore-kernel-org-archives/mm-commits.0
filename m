Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D21C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 23:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiAaXYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiAaXYH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 18:24:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F589C061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 15:24:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3307BB82CC6
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 23:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F80C340E8;
        Mon, 31 Jan 2022 23:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643671444;
        bh=9zt3gn8ikk4pHkUBQKJy7i3AN8nUATvUfAn7g7usE1s=;
        h=Date:To:From:Subject:From;
        b=I4N8mvS7Mmsg+P1iHd4Tm+lRDvFTosXjKqt+VLi69Sig/m0BqrnjfsaBkSsA/HlTu
         sNNWo2+sx8t4HD5H96njDjZgv7CA3wNRKwVyuTvJ9r5bNCXXoAQWNT7FPV/P/dUvGU
         5kTBKtArpfzk3QLlYWlDODf2hvQdwwCYEmRCEQOQ=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 15:24:02 -0800
Date:   Mon, 31 Jan 2022 15:24:02 -0800
To:     mm-commits@vger.kernel.org, zhanglianjie@uniontech.com,
        yzaikin@google.com, mcgrof@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-page-writeback-sysctls-to-is-own-file-fix.patch added to -mm tree
Message-Id: <20220131232402.C5F80C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-page-writeback-sysctls-to-is-own-file-fix
has been added to the -mm tree.  Its filename is
     mm-move-page-writeback-sysctls-to-is-own-file-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-page-writeback-sysctls-to-is-own-file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-move-page-writeback-sysctls-to-is-own-file-fix

fix CONFIG_SYSCTL=n warnings

Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: zhanglianjie <zhanglianjie@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page-writeback.c~mm-move-page-writeback-sysctls-to-is-own-file-fix
+++ a/mm/page-writeback.c
@@ -506,6 +506,7 @@ bool node_dirty_ok(struct pglist_data *p
 	return nr_pages <= limit;
 }
 
+#ifdef CONFIG_SYSCTL
 static int dirty_background_ratio_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -555,6 +556,7 @@ static int dirty_bytes_handler(struct ct
 	}
 	return ret;
 }
+#endif
 
 static unsigned long wp_next_time(unsigned long cur_time)
 {
@@ -1996,6 +1998,7 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	return false;
 }
 
+#ifdef CONFIG_SYSCTL
 /*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
@@ -2020,6 +2023,7 @@ static int dirty_writeback_centisecs_han
 
 	return ret;
 }
+#endif
 
 void laptop_mode_timer_fn(struct timer_list *t)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

