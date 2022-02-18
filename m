Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EF4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 18 Feb 2022 02:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiBRCsT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Feb 2022 21:48:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiBRCsS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Feb 2022 21:48:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D391DA7D
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 18:48:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1D1661D49
        for <mm-commits@vger.kernel.org>; Fri, 18 Feb 2022 02:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A651C340E8;
        Fri, 18 Feb 2022 02:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645152481;
        bh=W5BjRXYXMJDvG8q1CBcUvNZMTu9jkEJnNeuHqd9JUqo=;
        h=Date:To:From:Subject:From;
        b=wlEDuVuF3t+2m4WDIeMkMK81T1q7mOCDGahmnkNKiZzt9gosT3AB3B5iSsv0XrLrA
         FsN+ZHoVvd+MGhzAJnuE0++65egZ1TIQdqoXfJckhJKaPmXO2irJ1aM5ka/4OaIOIn
         roogGwwzMShYm0JEmU3aCG5pFhSkOmjsjt2ji6zo=
Date:   Thu, 17 Feb 2022 18:48:00 -0800
To:     mm-commits@vger.kernel.org, zhanglianjie@uniontech.com,
        yzaikin@google.com, mcgrof@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-move-page-writeback-sysctls-to-is-own-file-fix.patch removed from -mm tree
Message-Id: <20220218024801.3A651C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-page-writeback-sysctls-to-is-own-file-fix
has been removed from the -mm tree.  Its filename was
     mm-move-page-writeback-sysctls-to-is-own-file-fix.patch

This patch was dropped because it was folded into mm-move-page-writeback-sysctls-to-is-own-file.patch

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

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

