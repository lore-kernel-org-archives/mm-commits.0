Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D27C43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiKIBl7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiKIBkO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A00E65E6D
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 388E7B81CC9
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94E0C433D6;
        Wed,  9 Nov 2022 01:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957976;
        bh=eQjZqqJaXayLk9jQaIwjiS53Kubr9KqB3f3kouvG/3w=;
        h=Date:To:From:Subject:From;
        b=gMrBui4i8aVXik9W4pXA7jGj5pfYnVW+sU9hKtYFFR7fOvy9vpuPgqfr5Jgte289j
         ZjNnDdxYdCqIOTcvBMhuDQz3w1sIxVo0sjt85Yimx5Mp9Ci3J0nv2Rau/TMZ3bwjJd
         EiUnHc1d+HbXNl1qmHI0oh0Ve/UY4eKykFcRgbYE=
Date:   Tue, 08 Nov 2022 17:39:36 -0800
To:     mm-commits@vger.kernel.org, kasong@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-add-a-limit-for-readahead-page-cluster-value.patch removed from -mm tree
Message-Id: <20221109013936.D94E0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: add a limit for readahead page-cluster value
has been removed from the -mm tree.  Its filename was
     swap-add-a-limit-for-readahead-page-cluster-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: swap: add a limit for readahead page-cluster value
Date: Mon, 24 Oct 2022 00:25:33 +0800

Currenty there is no upper limit for /proc/sys/vm/page-cluster, and it's a
bit shift value, so it could result in overflow of the 32-bit integer. 
Add a reasonable upper limit for it, read-in at most 2**31 pages, which is
a large enough value for readahead.

Link: https://lkml.kernel.org/r/20221023162533.81561-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 kernel/sysctl.c    |    1 +
 mm/swap.c          |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~swap-add-a-limit-for-readahead-page-cluster-value
+++ a/include/linux/mm.h
@@ -74,6 +74,7 @@ static inline void totalram_pages_add(lo
 
 extern void * high_memory;
 extern int page_cluster;
+extern const int page_cluster_max;
 
 #ifdef CONFIG_SYSCTL
 extern int sysctl_legacy_va_layout;
--- a/kernel/sysctl.c~swap-add-a-limit-for-readahead-page-cluster-value
+++ a/kernel/sysctl.c
@@ -2125,6 +2125,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
+		.extra2		= (void *)&page_cluster_max,
 	},
 	{
 		.procname	= "dirtytime_expire_seconds",
--- a/mm/swap.c~swap-add-a-limit-for-readahead-page-cluster-value
+++ a/mm/swap.c
@@ -43,8 +43,9 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/pagemap.h>
 
-/* How many pages do we try to swap or page in/out together? */
+/* How many pages do we try to swap or page in/out together? As a power of 2 */
 int page_cluster;
+const int page_cluster_max = 31;
 
 /* Protecting only lru_rotate.fbatch which requires disabling interrupts */
 struct lru_rotate {
_

Patches currently in -mm which might be from kasong@tencent.com are


