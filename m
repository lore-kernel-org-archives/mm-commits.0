Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60377C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14EAE206CB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhA0Csn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbhAZVmu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 16:42:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0870820656;
        Tue, 26 Jan 2021 21:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611697329;
        bh=9KPD4rIfkYh4cmtDv2RDTyM/Ym1GpKBGsDnhMJhHcIg=;
        h=Date:From:To:Subject:From;
        b=xSQAvdaCv7nZ25SvPpn2fWYOfuZBkRH8/wYzxNFJmKXBeFB39psvJgzpy6j5N/Yw/
         Wqtg5A54E9/4yrhQ9igfYExf0YDQgAFlItJhvFwyuZ4olKvP5e1j7dGi0BPPiveEpx
         ZFf9J5i7n6eiuAetXsFEqSoRUI2st5AtKGqki1KY=
Date:   Tue, 26 Jan 2021 13:42:08 -0800
From:   akpm@linux-foundation.org
To:     hubert.jasudowicz@gmail.com, mikelley@microsoft.com,
        mm-commits@vger.kernel.org, mortonm@chromium.org,
        peterz@infradead.org, thomascedeno@google.com, xiang@kernel.org
Subject:  + groups-simplify-struct-group_info-allocation.patch
 added to -mm tree
Message-ID: <20210126214208.SqMg2ur3y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: groups: simplify struct group_info allocation
has been added to the -mm tree.  Its filename is
     groups-simplify-struct-group_info-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/groups-simplify-struct-group_info-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/groups-simplify-struct-group_info-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

groups-use-flexible-array-member-in-struct-group_info.patch
groups-simplify-struct-group_info-allocation.patch

