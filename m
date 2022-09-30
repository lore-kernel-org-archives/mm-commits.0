Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26ACC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 30 Sep 2022 22:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiI3Wfa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Sep 2022 18:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiI3Wf3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2022 18:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5878A8334
        for <mm-commits@vger.kernel.org>; Fri, 30 Sep 2022 15:35:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61F266252B
        for <mm-commits@vger.kernel.org>; Fri, 30 Sep 2022 22:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5868C433C1;
        Fri, 30 Sep 2022 22:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664577326;
        bh=vSCP3uDawzjgjIdWqzHt8w2EmyRkn1hUjCrHUWbxwcg=;
        h=Date:To:From:Subject:From;
        b=oZy9+berTM4+XKaQVK9gCoIOuGrsuXV3vgsE+wb7Mf9Lj6w7ug/ZB2Yk1nh1clSUU
         /XSLFRvjhciL0/B+HGsKE8iSWp1zpf42dZnrzZP+PD6CEum/lGfVDIeKPOJzTpq5S5
         KMlAlhv0uajdoWX1x+faznJGe2nASZZ3fsUGts+o=
Date:   Fri, 30 Sep 2022 15:35:25 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, xu.panda@zte.com.cn,
        baihaowen@meizu.com, xu.xin16@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-mca-use-strscpy-is-more-robust-and-safer.patch added to mm-nonmm-unstable branch
Message-Id: <20220930223526.B5868C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: mca: use strscpy() is more robust and safer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-mca-use-strscpy-is-more-robust-and-safer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-mca-use-strscpy-is-more-robust-and-safer.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ia64: mca: use strscpy() is more robust and safer
Date: Fri, 30 Sep 2022 06:19:50 +0000

The implementation of strscpy() is more robust and safer.  That's now the
recommended way to copy NUL terminated strings.

Link: https://lkml.kernel.org/r/20220930061950.288290-1-xu.xin16@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/mca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/mca.c~ia64-mca-use-strscpy-is-more-robust-and-safer
+++ a/arch/ia64/kernel/mca.c
@@ -1793,7 +1793,7 @@ format_mca_init_stack(void *mca_data, un
 	p->parent = p->real_parent = p->group_leader = p;
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
-	strncpy(p->comm, type, sizeof(p->comm)-1);
+	strscpy(p->comm, type, sizeof(p->comm)-1);
 }
 
 /* Caller prevents this from being called after init */
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ia64-mca-use-strscpy-is-more-robust-and-safer.patch

