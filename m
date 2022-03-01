Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A11FC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 17:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiCAR3r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 12:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236492AbiCAR3p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 12:29:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AD81FA58
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 09:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AECFB81B9D
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 17:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7C0C340EE;
        Tue,  1 Mar 2022 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646155740;
        bh=UU6oWgwfex4gFnn/iLrydz+UiI6++ncSBSIVMeUI/YA=;
        h=Date:To:From:Subject:From;
        b=eG9kMJ50qHeTWUszSQKemkhLKDA22JnUdsBwmBNEXKU4yq4jJu5jushh6qMfSEpOj
         3uO17a7Xogm2WXIUsBoPqd5v+9JeDE8qEYk/qDii7h6zWJ74+KbepkAeH2ZqhSCTtn
         LTihF7dz+j4z211OVTveMztJ4HedDKUJVj/6ec1o=
Date:   Tue, 01 Mar 2022 09:29:00 -0800
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        weizhenliang@huawei.com, sfr@canb.auug.org.au,
        caoyixuan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-add-a-security-check.patch added to -mm tree
Message-Id: <20220301172900.BC7C0C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: add a security check
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-add-a-security-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-add-a-security-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-add-a-security-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: add a security check

Add a security check after using malloc() to allocate memory.

Link: https://lkml.kernel.org/r/20220301151438.166118-2-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-add-a-security-check
+++ a/tools/vm/page_owner_sort.c
@@ -217,7 +217,13 @@ static void add_list(char *buf, int len)
 		printf("max_size too small??\n");
 		exit(1);
 	}
+
 	list[list_size].txt = malloc(len+1);
+	if (!list[list_size].txt) {
+		printf("Out of memory\n");
+		exit(1);
+	}
+
 	list[list_size].len = len;
 	list[list_size].num = 1;
 	list[list_size].page_num = get_page_num(buf);
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are

tools-vm-page_owner_sortc-fix-comments.patch
tools-vm-page_owner_sortc-add-a-security-check.patch
tools-vm-page_owner_sortc-support-sorting-by-tgid-and-update-documentation.patch

