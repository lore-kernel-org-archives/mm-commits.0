Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873CAC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42418206C3
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhA0Csn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbhAZVmq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 16:42:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12F9A2053B;
        Tue, 26 Jan 2021 21:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611697326;
        bh=Su9CkimX1lGfOFMRNuIa4Ifa5xZDaqPruSvaQkclfd4=;
        h=Date:From:To:Subject:From;
        b=nNIiurJqulP5/wlZigb8vDR7jUifUvGUuKEt74FAH/0fJ4ey5aQxjpOGEbCHlOrDy
         +GB32haIxw564CpLtp6YkyeBgZGYjq7nU700ZUPd7HycsSYGhayT/muFez2hXD2Smk
         0wxBziWIaSZlRnsfl4lME+pQQb3KLXHBhT0h9QUY=
Date:   Tue, 26 Jan 2021 13:42:05 -0800
From:   akpm@linux-foundation.org
To:     hubert.jasudowicz@gmail.com, mikelley@microsoft.com,
        mm-commits@vger.kernel.org, mortonm@chromium.org,
        peterz@infradead.org, thomascedeno@google.com, xiang@kernel.org
Subject:  +
 groups-use-flexible-array-member-in-struct-group_info.patch added to -mm
 tree
Message-ID: <20210126214205.BHCUWFLCe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: groups: use flexible-array member in struct group_info
has been added to the -mm tree.  Its filename is
     groups-use-flexible-array-member-in-struct-group_info.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/groups-use-flexible-array-member-in-struct-group_info.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/groups-use-flexible-array-member-in-struct-group_info.patch

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

groups-use-flexible-array-member-in-struct-group_info.patch
groups-simplify-struct-group_info-allocation.patch

