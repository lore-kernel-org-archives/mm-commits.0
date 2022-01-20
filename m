Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5202C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358167AbiATCIL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41588 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5C51615C2
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5B8C004E1;
        Thu, 20 Jan 2022 02:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644490;
        bh=j2cofkI3mNswBUXxEt4eNVtlnxBYvQn69ZcQZ+MG/dE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BfJd1O81DsHDPqSvg3ICBa9z4VEYI/9VfublE7OtzGJjwXjwrD37jOUt8A7AhIGFz
         R1uHqfsjWDjJK6CE5Tjabf6bl81cqKtb/8t7rSdlMmZeDaz8lLQm4X1DIxsvR7KCaS
         2uwfvSdg/UP8J4tIFmXdSp7Xnl5GP2SY9x3GQRBM=
Date:   Wed, 19 Jan 2022 18:08:09 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        luo.penghao@zte.com.cn, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zealci@zte.com.cn
Subject:  [patch 09/55] sysctl: remove redundant ret assignment
Message-ID: <20220120020809.QepbJ2Fov%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>
Subject: sysctl: remove redundant ret assignment

Subsequent if judgments will assign new values to ret, so the statement
here should be deleted

The clang_analyzer complains as follows:

fs/proc/proc_sysctl.c:

Value stored to 'ret' is never read

Link: https://lkml.kernel.org/r/20211230063622.586360-1-luo.penghao@zte.com.cn
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/proc/proc_sysctl.c~sysctl-remove-redundant-ret-assignment
+++ a/fs/proc/proc_sysctl.c
@@ -1053,7 +1053,6 @@ static int sysctl_follow_link(struct ctl
 	struct ctl_dir *dir;
 	int ret;
 
-	ret = 0;
 	spin_lock(&sysctl_lock);
 	root = (*pentry)->data;
 	set = lookup_header_set(root);
_
