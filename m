Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A246C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 16 May 2022 20:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiEPUeS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 May 2022 16:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349085AbiEPUcK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2022 16:32:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918AB112A
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 13:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CD08611D6
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 20:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722FDC385AA;
        Mon, 16 May 2022 20:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652732140;
        bh=U1emzNC4d02SSBzt4vnS/j5O2FMjYkVw1fH2HNIsTVc=;
        h=Date:To:From:Subject:From;
        b=TnkRa+j3SZp6M5uyHuUD2mCe5bJ1FrSDrXVrdhMkPrh2sAablcMFyQNbnXlsBmL5R
         HayHe97RSKlbWnTrMnNkSR+z7VLbNmX8vho8u1othVG/tMu1q4EOqs0OWAlJ/R/WBN
         1KCwERYgGl8YVIy1yYE9MWfZuTBJxuyNWYlg01VA=
Date:   Mon, 16 May 2022 13:15:39 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        bh1scw@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ownerc-add-missing-__initdata-attribute.patch added to mm-unstable branch
Message-Id: <20220516201540.722FDC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: add missing __initdata attribute
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ownerc-add-missing-__initdata-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ownerc-add-missing-__initdata-attribute.patch

This patch will later appear in the mm-unstable branch at
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

mm-page_ownerc-add-missing-__initdata-attribute.patch

