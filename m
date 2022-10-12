Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D889C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 01:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJLBvt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJLBvr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 21:51:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF82A486F
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 18:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22969B818B6
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 01:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31F7C433D7;
        Wed, 12 Oct 2022 01:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665539503;
        bh=vBts5Vz36baSeAQjVSJTQxSerbMN+4/+yxLnnpI8bM0=;
        h=Date:To:From:Subject:From;
        b=gEFxdvuh2Q0Y/j4Dq2ODOAvTy360u81JTOWIZfqQaAFMI3a0w3quXLTVhLa/6Y4GG
         W1AzbkdZoE98QBfnp6vMyYdKnI+TRTHYy/Oe0m1FKpQQQV+kRkdoUcRTzzuMjYOhWS
         qJeO6zN44OBcVWrxLY2zaDYLDP4/eGObFwbGJU8w=
Date:   Tue, 11 Oct 2022 18:51:43 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, xu.panda@zte.com.cn,
        baihaowen@meizu.com, xu.xin16@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-mca-use-strscpy-is-more-robust-and-safer.patch removed from -mm tree
Message-Id: <20221012015143.B31F7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: mca: use strscpy() is more robust and safer
has been removed from the -mm tree.  Its filename was
     ia64-mca-use-strscpy-is-more-robust-and-safer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


