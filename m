Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73ECDC636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBMXwG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjBMXwF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:52:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F49E1632D
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:52:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18B216134B
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D188C433D2;
        Mon, 13 Feb 2023 23:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332323;
        bh=Ww8xlPST34pD9pkk3tCwlrr4aCNgiLqnF7BnJQC/ctI=;
        h=Date:To:From:Subject:From;
        b=QTGRwMnqZFKluxHkVcsCc5KIC9g4xEylX+XL3ia0DskZ6rfNFyUydFUp7UnEB278N
         h7YyAJt8yMLFryg/Mys8wjQw6sqz5ZMifl6OizCUItU8SEXz6dDRxWcP1GxZB5NBPX
         oQ3WMCgTeGqmgaZvBLb5sbk74IaxJ17LyW0B3aT8=
Date:   Mon, 13 Feb 2023 15:52:02 -0800
To:     mm-commits@vger.kernel.org, rdunlap@xenotime.net, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix.patch removed from -mm tree
Message-Id: <20230213235203.6D188C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix.patch

This patch was dropped because it was folded into mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix
Date: Fri, 10 Feb 2023 04:48:38 +0000

split DAMON debugfs file open warning message, per Randy


Link: https://lkml.kernel.org/r/20230209192009.7885-4-sj@kernel.org
Link: https://lkml.kernel.org/r/20230210044838.63723-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix
+++ a/mm/damon/dbgfs.c
@@ -22,7 +22,10 @@ static DEFINE_MUTEX(damon_dbgfs_lock);
 
 static void damon_dbgfs_warn_deprecation(void)
 {
-	pr_warn_once("DAMON debugfs interface is deprecated, so users should move to the sysfs interface (DAMON_SYSFS).  If you depend on this and cannot move, please report your usecase to damon@lists.linux.dev and linux-mm@kvack.org.\n");
+	pr_warn_once("DAMON debugfs interface is deprecated, "
+		     "so users should move to DAMON_SYSFS. If you cannot, "
+		     "please report your usecase to damon@lists.linux.dev and "
+		     "linux-mm@kvack.org.\n");
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch
mm-damon-kconfig-add-damon-debugfs-interface-deprecation-notice.patch
mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch

