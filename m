Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3C1C38A2D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiJYAZG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiJYAYr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:24:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E24DDBBCB
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 656E2B810B2
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039DBC433D6;
        Mon, 24 Oct 2022 22:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666651682;
        bh=luY9V0B3NpvBMusOVlslZQlh8CDnUztfvKkoa9rQ7Lw=;
        h=Date:To:From:Subject:From;
        b=KoSMVIDP9kpigoTUSr8ewdAx8eD7ha7HdLNfHUKfGdUlbm+4SzJxS2GJ0Ojtn2B4Z
         vTWbVvILz+bkhRJ3aP3YblZJA05E2kUTopU1NeQz3CUMTzsgqMZOCWrB7gJj7kW+Vq
         3sO8Fzb22raTwh8AroExL69gxucOYu55LT9Gxgqk=
Date:   Mon, 24 Oct 2022 15:48:01 -0700
To:     mm-commits@vger.kernel.org, kasong@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-add-a-limit-for-readahead-page-cluster-value.patch added to mm-unstable branch
Message-Id: <20221024224802.039DBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: add a limit for readahead page-cluster value
has been added to the -mm mm-unstable branch.  Its filename is
     swap-add-a-limit-for-readahead-page-cluster-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-add-a-limit-for-readahead-page-cluster-value.patch

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

swap-add-a-limit-for-readahead-page-cluster-value.patch

