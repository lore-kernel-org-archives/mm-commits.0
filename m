Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C39C432C3
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C09864F30
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBZBWg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230060AbhBZBVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C92B64F3C;
        Fri, 26 Feb 2021 01:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302464;
        bh=l1n256VGACAvnIN1lwNELVlMM6rCPZVqR8xukU1Rs2w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DqsQ/ABOE6qdcbJ3JF8xE/KSuRwnIo1BDzo2IbHLRnTQWpnFm5X+AXbnVB+jRZl23
         qCAETiH4M2pXMG6fBO9yPjFYV0KWfo3d2p13mTEJD51n6qOUMJDV/AH6RP52/Mx1rG
         A6wH+tr2NdqEWxeKQ8j/3+qmo7Ruaz6q1vbLlc68=
Date:   Thu, 25 Feb 2021 17:21:03 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hubert.jasudowicz@gmail.com,
        linux-mm@kvack.org, mikelley@microsoft.com,
        mm-commits@vger.kernel.org, mortonm@chromium.org,
        peterz@infradead.org, thomascedeno@google.com,
        torvalds@linux-foundation.org, xiang@kernel.org
Subject:  [patch 088/118] groups: use flexible-array member in
 struct group_info
Message-ID: <20210226012103.WcPCc2XlT%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
