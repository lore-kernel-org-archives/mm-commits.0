Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7055C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A834D64F3E
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhB0Ccz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhB0Cci (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ED5464F45;
        Sat, 27 Feb 2021 02:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393114;
        bh=1bmBZGnm0DA6PVYk8OhY5I+zn4ajZRBMMHkLelVySB8=;
        h=Date:From:To:Subject:From;
        b=DG8JbSzw/iHL0qLTlvjdFXqlW3gvPY/9Erlc6GYa0N/5as7i07/3AGzpK+UUR6D3L
         fAnvuk8yJ55j6WvZrzTRSsedTbnalQI8FyngV98kBAI+IFwuA33lNnmDmG2Q9QU0BY
         4ApmPy86H7FF65bUK9Fhuu1/P/7jsBNKr4VCPBQM=
Date:   Fri, 26 Feb 2021 18:31:54 -0800
From:   akpm@linux-foundation.org
To:     hubert.jasudowicz@gmail.com, mikelley@microsoft.com,
        mm-commits@vger.kernel.org, mortonm@chromium.org,
        peterz@infradead.org, thomascedeno@google.com, xiang@kernel.org
Subject:  [merged]
 groups-simplify-struct-group_info-allocation.patch removed from -mm tree
Message-ID: <20210227023154.Rnvg1Q7MC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: groups: simplify struct group_info allocation
has been removed from the -mm tree.  Its filename was
     groups-simplify-struct-group_info-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
Subject: groups: simplify struct group_info allocation

Combine kmalloc and vmalloc into a single call.  Use struct_size macro
instead of direct size calculation.

Link: https://lkml.kernel.org/r/ba9ba5beea9a44b7196c41a0d9528abd5f20dd2e.1611620846.git.hubert.jasudowicz@gmail.com
Signed-off-by: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Micah Morton <mortonm@chromium.org>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Thomas Cedeno <thomascedeno@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/groups.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/groups.c~groups-simplify-struct-group_info-allocation
+++ a/kernel/groups.c
@@ -15,12 +15,7 @@
 struct group_info *groups_alloc(int gidsetsize)
 {
 	struct group_info *gi;
-	unsigned int len;
-
-	len = sizeof(struct group_info) + sizeof(kgid_t) * gidsetsize;
-	gi = kmalloc(len, GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY);
-	if (!gi)
-		gi = __vmalloc(len, GFP_KERNEL_ACCOUNT);
+	gi = kvmalloc(struct_size(gi, gid, gidsetsize), GFP_KERNEL_ACCOUNT);
 	if (!gi)
 		return NULL;
 
_

Patches currently in -mm which might be from hubert.jasudowicz@gmail.com are


