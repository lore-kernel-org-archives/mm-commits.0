Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2581BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jan 2022 22:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiALWmS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jan 2022 17:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiALWmS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jan 2022 17:42:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE0FC06173F
        for <mm-commits@vger.kernel.org>; Wed, 12 Jan 2022 14:42:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81BA061B23
        for <mm-commits@vger.kernel.org>; Wed, 12 Jan 2022 22:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF365C36AE5;
        Wed, 12 Jan 2022 22:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642027336;
        bh=U85Gw7kNMdnBJd98gnPfBzYk5ad7I6maKdgXzAymhFQ=;
        h=Date:From:To:Subject:From;
        b=O52ETVeor6aLY/+FIEJJGlQELoXkpZPR7DdWX3k/yZdx67a38ASXnH08Bel7QPTkX
         6w1m6fTs4Nz1EAAeC/iwni8GXQQubyfQpqfZfVJpj9Tpx7oXLCIz5CidJ2l8mGoB/S
         V7ptOKmRceINkKG6aLiG55+9EUX3TggeRx0ra3pI=
Date:   Wed, 12 Jan 2022 14:42:16 -0800
From:   akpm@linux-foundation.org
To:     luo.penghao@zte.com.cn, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, zealci@zte.com.cn
Subject:  + sysctl-remove-redundant-ret-assignment.patch added to
 -mm tree
Message-ID: <20220112224216.IkBM-94uC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: Remove redundant ret assignment
has been added to the -mm tree.  Its filename is
     sysctl-remove-redundant-ret-assignment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-remove-redundant-ret-assignment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-remove-redundant-ret-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: luo penghao <luo.penghao@zte.com.cn>
Subject: sysctl: Remove redundant ret assignment

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

Patches currently in -mm which might be from luo.penghao@zte.com.cn are

sysctl-remove-redundant-ret-assignment.patch

