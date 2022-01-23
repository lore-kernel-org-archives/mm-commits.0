Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F308C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbiAWX5o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiAWX5o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A2EC06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7A11B80D38
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F7EC340E3;
        Sun, 23 Jan 2022 23:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982261;
        bh=gKRKVAaM394Ycr6Txkso+llXE1R9eOVRkIZ85raUKW0=;
        h=Date:From:To:Subject:From;
        b=S96fgW5lWjO/SeeDpaYll8y3/rig1F3IBR2epO1PlQ19n1vTE3OF9fTMNiavhBvPG
         W4vebL0MfcRt5pnYYh4lC9DfsVF91IatDhbksSsEk63HFG9zB2xEoobdW4y7WjDDg3
         fb2E03aymX5Unrj+2LzD6AOXjgMNSmYNQVIrMxQ0=
Date:   Sun, 23 Jan 2022 15:57:41 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 kernel-sysctlc-remove-unused-variable-ten_thousand.patch removed from -mm
 tree
Message-ID: <20220123235741.kgiLUxiaI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: remove unused variable ten_thousand
has been removed from the -mm tree.  Its filename was
     kernel-sysctlc-remove-unused-variable-ten_thousand.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: kernel/sysctl.c: remove unused variable ten_thousand

The const variable ten_thousand is not used, it is redundant and can be
removed.

Cleans up clang warning:
kernel/sysctl.c:99:18: warning: unused variable 'ten_thousand' [-Wunused-const-variable]
static const int ten_thousand = 10000;

Link: https://lkml.kernel.org/r/20211221184501.574670-1-colin.i.king@gmail.com
Fixes: c26da54dc8ca ("printk: move printk sysctl to printk/sysctl.c")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/sysctl.c~kernel-sysctlc-remove-unused-variable-ten_thousand
+++ a/kernel/sysctl.c
@@ -96,9 +96,6 @@
 
 /* Constants used for minimum and  maximum */
 
-#ifdef CONFIG_PRINTK
-static const int ten_thousand = 10000;
-#endif
 #ifdef CONFIG_PERF_EVENTS
 static const int six_hundred_forty_kb = 640 * 1024;
 #endif
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


