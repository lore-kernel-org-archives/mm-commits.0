Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED73C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 005F661481
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238566AbhGAB7S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238606AbhGAB7L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC94361469;
        Thu,  1 Jul 2021 01:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104601;
        bh=0AhemfqD8GVqBCuMQ5lCqSm+IlfuRkwZDWpdpQtehws=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u9+0w7cvSAdHpkR1JfrVE9fEZLYRh3Y1lfN91Oam9jqeXskFbBMozpw4NdEVS24Us
         s6Vie9SuZ9xuQurbrbDTawsqV5sswjsBPPpQoIDiLP3KvczFbiszu0xXaOejYteEtX
         M7Tx9kxC6ig+VYv7J2qE/NH60XHDXnDW5I/HCuLc=
Date:   Wed, 30 Jun 2021 18:56:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, cccheng@synology.com,
        christian.brauner@ubuntu.com, jamorris@linux.microsoft.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shepjeng@gmail.com,
        slava@dubeyko.com, torvalds@linux-foundation.org
Subject:  [patch 180/192] hfsplus: report create_date to
 kstat.btime
Message-ID: <20210701015640.stiIQSnDi%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
