Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A694C43217
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiESW0Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245518AbiESW0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:26:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781832ED58
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1523961693
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A50EC385B8;
        Thu, 19 May 2022 22:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999159;
        bh=cVuVTPCWSfeglwzZbCqGycOaflfGXz0JvR5Xd5yIEzg=;
        h=Date:To:From:Subject:From;
        b=uBzZ3mIMk8H+pOPA9Nywhb+8iFvRxoXkW9Z6E2ApH60DePmia5yDQ48x6onH6Va4S
         KYYH3wTWE9JcqbcebtnbHx+hF17647DkaZt8FfKjaGQKV/vJWjXlCUxVfEl1XB9uf8
         H2qbggL0U7d3piJnjcP2Y4ZmAMzPReo548klDHBc=
Date:   Thu, 19 May 2022 15:25:58 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        bh1scw@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ownerc-add-missing-__initdata-attribute.patch removed from -mm tree
Message-Id: <20220519222559.6A50EC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_owner.c: add missing __initdata attribute
has been removed from the -mm tree.  Its filename was
     mm-page_ownerc-add-missing-__initdata-attribute.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fanjun Kong <bh1scw@gmail.com>
Subject: mm/page_owner.c: add missing __initdata attribute
Date: Mon, 16 May 2022 11:00:42 +0800

This patch fixes two issues:
1. Add __initdata attribute according to include/linux/init.h:
	For initialized data:
	You should insert __initdata between the variable name and equal
	sign followed by value

2. Fix below error reported by checkpatch.pl:
	ERROR: do not initialise statics to false

Special thanks to Muchun Song :)

Link: https://lkml.kernel.org/r/20220516030039.1487005-1-bh1scw@gmail.com
Signed-off-by: Fanjun Kong <bh1scw@gmail.com>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_ownerc-add-missing-__initdata-attribute
+++ a/mm/page_owner.c
@@ -34,7 +34,7 @@ struct page_owner {
 	pid_t tgid;
 };
 
-static bool page_owner_enabled = false;
+static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
 static depot_stack_handle_t dummy_handle;
_

Patches currently in -mm which might be from bh1scw@gmail.com are


