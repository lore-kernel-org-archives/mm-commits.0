Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DCDC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67239613B9
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhEGBD3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234008AbhEGBDZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18B0B610F7;
        Fri,  7 May 2021 01:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349345;
        bh=a1b2FGOpu3Cm5cuZDuo2hBzaZp5z8d/369E9bi3CgnY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AdjkEdSFAdlhEFEzBnCZQFUSZV263WBSRk70DJ+15X3k8HQdJyMZwBq9rHmdThqg3
         X4djjLOFh6syhdMyKsGTIsRpdPXhVD/Kxtj7oY53ryRUTeHY60iMtvv5rSM+ZKTjB9
         +hw19tgU+GykX3wFK5lkep05R0F0egNONLbUFnAc=
Date:   Thu, 06 May 2021 18:02:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhouchuangao@vivo.com
Subject:  [patch 08/91] proc/sysctl: fix function name error in
 comments
Message-ID: <20210507010224.wbLnBEgCv%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: zhouchuangao <zhouchuangao@vivo.com>
Subject: proc/sysctl: fix function name error in comments

The function name should be modified to register_sysctl_paths instead of
register_sysctl_table_path.

Link: https://lkml.kernel.org/r/1615807194-79646-1-git-send-email-zhouchuangao@vivo.com
Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/proc_sysctl.c~proc-sysctl-fix-function-name-error-in-comments
+++ a/fs/proc/proc_sysctl.c
@@ -1563,7 +1563,7 @@ err_register_leaves:
 }
 
 /**
- * register_sysctl_table_path - register a sysctl table hierarchy
+ * register_sysctl_paths - register a sysctl table hierarchy
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
  *
_
