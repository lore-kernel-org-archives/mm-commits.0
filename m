Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10795C11F64
	for <mm-commits@archiver.kernel.org>; Mon, 28 Jun 2021 22:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E024C61D01
	for <mm-commits@archiver.kernel.org>; Mon, 28 Jun 2021 22:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhF1WEu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 18:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236827AbhF1WD5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 18:03:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B245361CF9;
        Mon, 28 Jun 2021 22:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624917690;
        bh=kMIK0j5d8st6yfsst3i3UKSDzDV+0EHkyTjSDvsjO+Y=;
        h=Date:From:To:Subject:From;
        b=N4biExR0fywIG7A3O21uhvxhO3MSgjtGoMEx0CdddAXO9FnEalQV/OT5g9C6Gb10M
         it0Thx7vzdMEM+oac6M+6WnZKVflk7Bfia5bI8M4bAFK2bMw4y4a8zpVzbImplvTK1
         ZeCCt/DYu9PBBTXWtRLxJiaE+L30d8ITXbGUsnEI=
Date:   Mon, 28 Jun 2021 15:01:30 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, cccheng@synology.com,
        christian.brauner@ubuntu.com, jamorris@linux.microsoft.com,
        mm-commits@vger.kernel.org, shepjeng@gmail.com, slava@dubeyko.com
Subject:  + hfsplus-report-create_date-to-kstatbtime.patch added to
 -mm tree
Message-ID: <20210628220130.sw3UlSC4N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: report create_date to kstat.btime
has been added to the -mm tree.  Its filename is
     hfsplus-report-create_date-to-kstatbtime.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hfsplus-report-create_date-to-kstatbtime.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-report-create_date-to-kstatbtime.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chung-Chiang Cheng <shepjeng@gmail.com>
Subject: hfsplus: report create_date to kstat.btime

The create_date field of inode in hfsplus is corresponding to
kstat.btime and could be reported in statx.

Link: https://lkml.kernel.org/r/20210416172147.8736-1-cccheng@synology.com
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/hfsplus/inode.c~hfsplus-report-create_date-to-kstatbtime
+++ a/fs/hfsplus/inode.c
@@ -281,6 +281,11 @@ int hfsplus_getattr(struct user_namespac
 	struct inode *inode = d_inode(path->dentry);
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
 
+	if (request_mask & STATX_BTIME) {
+		stat->result_mask |= STATX_BTIME;
+		stat->btime = hfsp_mt2ut(hip->create_date);
+	}
+
 	if (inode->i_flags & S_APPEND)
 		stat->attributes |= STATX_ATTR_APPEND;
 	if (inode->i_flags & S_IMMUTABLE)
_

Patches currently in -mm which might be from shepjeng@gmail.com are

hfsplus-report-create_date-to-kstatbtime.patch

