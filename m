Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59341C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3161964F3C
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhB0Ccs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhB0Cci (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF8864F47;
        Sat, 27 Feb 2021 02:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393111;
        bh=jR2PGrohaZZYsxW2gjnxebGrygr0h0G5vLc27R0w1oc=;
        h=Date:From:To:Subject:From;
        b=tuXJY3sh5IEGmpYNSEJNC7y+UHUrFcFZzQS0pVLTUt1U+KuyX3g6e2HiGy/XPeiq/
         350QUfThtwg/l6ECX5z8x/aniWhBXmjbAhjtPh78STLEfI2asEgJjuGLiyJl7LuUNu
         gOTC4cNdp9feJmG5qzerMf6WkBlzWQmtgghzHEHQ=
Date:   Fri, 26 Feb 2021 18:31:51 -0800
From:   akpm@linux-foundation.org
To:     hubert.jasudowicz@gmail.com, mikelley@microsoft.com,
        mm-commits@vger.kernel.org, mortonm@chromium.org,
        peterz@infradead.org, thomascedeno@google.com, xiang@kernel.org
Subject:  [merged]
 groups-use-flexible-array-member-in-struct-group_info.patch removed from
 -mm tree
Message-ID: <20210227023151.iAr2IwILu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: groups: use flexible-array member in struct group_info
has been removed from the -mm tree.  Its filename was
     groups-use-flexible-array-member-in-struct-group_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
Subject: groups: use flexible-array member in struct group_info

Replace zero-size array with flexible array member, as recommended by
the docs.

Link: https://lkml.kernel.org/r/155995eed35c3c1bdcc56e69d8997c8e4c46740a.1611620846.git.hubert.jasudowicz@gmail.com
Signed-off-by: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Micah Morton <mortonm@chromium.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Thomas Cedeno <thomascedeno@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/cred.h~groups-use-flexible-array-member-in-struct-group_info
+++ a/include/linux/cred.h
@@ -25,7 +25,7 @@ struct inode;
 struct group_info {
 	atomic_t	usage;
 	int		ngroups;
-	kgid_t		gid[0];
+	kgid_t		gid[];
 } __randomize_layout;
 
 /**
_

Patches currently in -mm which might be from hubert.jasudowicz@gmail.com are


