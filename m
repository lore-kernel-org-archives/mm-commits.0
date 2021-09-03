Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54639C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DACD610E9
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhICVCu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350079AbhICVCt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E18360EE3;
        Fri,  3 Sep 2021 21:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702908;
        bh=hhuxmvuU5qfighVdiLy7nqUgaYt8EnlGp+Ap4RZ+qLE=;
        h=Date:From:To:Subject:From;
        b=eCzT+GCcl7kJc0nX1FtZU6p2aPsTRqrrn/wf187ZGXlnwcdnbbpSUWPMkIcz1DKVY
         kxq0HSsYp62l7xJOlEJZd3kA76t0+CtqIvmzuW0Ew9yt8VWSYXYuaqWY5OhiFdzq4j
         EURvrSPg3Ezxez+cWwAl4Qo0iqHXKD/Qk/qLWJUs=
Date:   Fri, 03 Sep 2021 14:01:48 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, zhangkui@oppo.com
Subject:  [merged]
 mm-madvise-add-madv_willneed-to-process_madvise.patch removed from -mm tree
Message-ID: <20210903210148.QP8UEPB6y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: add MADV_WILLNEED to process_madvise()
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-madv_willneed-to-process_madvise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhangkui <zhangkui@oppo.com>
Subject: mm/madvise: add MADV_WILLNEED to process_madvise()

There is a usecase in Android that an app process's memory is swapped out
by process_madvise() with MADV_PAGEOUT, such as the memory is swapped to
zram or a backing device.  When the process is scheduled to running, like
switch to foreground, multiple page faults may cause the app dropped
frames.

To reduce the problem, System Management Software can read-ahead memory
of the process immediately when the app switches to forground.  Calling
process_madvise() with MADV_WILLNEED can meet this need.

Link: https://lkml.kernel.org/r/20210804082010.12482-1-zhangkui@oppo.com
Signed-off-by: zhangkui <zhangkui@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-add-madv_willneed-to-process_madvise
+++ a/mm/madvise.c
@@ -1048,6 +1048,7 @@ process_madvise_behavior_valid(int behav
 	switch (behavior) {
 	case MADV_COLD:
 	case MADV_PAGEOUT:
+	case MADV_WILLNEED:
 		return true;
 	default:
 		return false;
_

Patches currently in -mm which might be from zhangkui@oppo.com are


