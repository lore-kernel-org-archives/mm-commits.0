Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FCAC43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1409C613C8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhEGBHd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhEGBH3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA16C613C5;
        Fri,  7 May 2021 01:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349591;
        bh=3vOfPZdEqjajFYUBF62//7cmyTYtxeJ+N4yRmAHPPzs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rPk5rbw/VLGXcbLNfAyTG/zS5eTotjD1ieplObjpXcqUc6ttRlyToakpAPKWvLBw6
         6we1xANCpYqqpsc+Sniw39Qihy5/gdl+LfvbHxbujQ7vassZyiDfc63ing+Kt2XTV3
         l+XUfPJTe+HWUL3b3GJsTSezh9e5ZLV+2ISliA74=
Date:   Thu, 06 May 2021 18:06:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, caoxiaofeng@yulong.com,
        cxfcosmos@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 84/91] kernel/user_namespace.c: fix typos
Message-ID: <20210507010630.Z4YFEyWlo%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaofeng Cao <cxfcosmos@gmail.com>
Subject: kernel/user_namespace.c: fix typos

change 'verifing' to 'verifying'
change 'certaint' to 'certain'
change 'approprpiate' to 'appropriate'

Link: https://lkml.kernel.org/r/20210317100129.12440-1-caoxiaofeng@yulong.com
Signed-off-by: Xiaofeng Cao <caoxiaofeng@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/user_namespace.c~kernel-user_namespace-fix-typo-issue
+++ a/kernel/user_namespace.c
@@ -85,7 +85,7 @@ int create_user_ns(struct cred *new)
 	/*
 	 * Verify that we can not violate the policy of which files
 	 * may be accessed that is specified by the root directory,
-	 * by verifing that the root directory is at the root of the
+	 * by verifying that the root directory is at the root of the
 	 * mount namespace which allows all files to be accessed.
 	 */
 	ret = -EPERM;
@@ -1014,7 +1014,7 @@ static ssize_t map_write(struct file *fi
 			goto out;
 		ret = -EINVAL;
 	}
-	/* Be very certaint the new map actually exists */
+	/* Be very certain the new map actually exists */
 	if (new_map.nr_extents == 0)
 		goto out;
 
@@ -1169,7 +1169,7 @@ static bool new_idmap_permitted(const st
 
 	/* Allow the specified ids if we have the appropriate capability
 	 * (CAP_SETUID or CAP_SETGID) over the parent user namespace.
-	 * And the opener of the id file also had the approprpiate capability.
+	 * And the opener of the id file also has the appropriate capability.
 	 */
 	if (ns_capable(ns->parent, cap_setid) &&
 	    file_ns_capable(file, ns->parent, cap_setid))
_
