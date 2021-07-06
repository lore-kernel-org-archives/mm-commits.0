Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32113C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154DE61CAB
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhGFTZw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhGFTZv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7385F61CA8;
        Tue,  6 Jul 2021 19:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599391;
        bh=SOvU2/4GoIfoNGRC9QYHa/2PplW2sV+BeBsmEm4667c=;
        h=Date:From:To:Subject:From;
        b=P+FvYRIn0CUJGMUvu38x/R/mG5vH+XukUpiXLylhAClbLbGUVy1MKTBoiwmKHSHLG
         PBiONA2jQ0rpSUIemHlsIdNzuM/b1j9BznOfztDha8pZ9v+COPwt2SMfVvGZsKdqaM
         tdE2iPY45sWb/7+IeS4JyzXsnQMpE3lDNcmxkWvU=
Date:   Tue, 06 Jul 2021 12:23:11 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, cccheng@synology.com,
        christian.brauner@ubuntu.com, jamorris@linux.microsoft.com,
        mm-commits@vger.kernel.org, shepjeng@gmail.com, slava@dubeyko.com
Subject:  [merged] hfsplus-report-create_date-to-kstatbtime.patch
 removed from -mm tree
Message-ID: <20210706192311.qICfPjmlH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: report create_date to kstat.btime
has been removed from the -mm tree.  Its filename was
     hfsplus-report-create_date-to-kstatbtime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


