Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE146ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiIEWC0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiIEWCZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD79B2B27A
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B34960C94
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2605C433D6;
        Mon,  5 Sep 2022 22:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662415343;
        bh=mdJUWRmLzZbl69fFUaP7FACYEi06uxIk1DHxIFuoqxo=;
        h=Date:To:From:Subject:From;
        b=LMLCZ6vJCkhrRGw/LZ3Blns17v8xbv0Zsk0z8qZ0hDXLGq8p9EWX4I6KFWUVEGC2o
         JZdaULY6rw0yvXi0B5qRY/1dEfWed9ahNqzmfshEFnd+e/a9706u/FRyQrEUrXbXvM
         ckSrBrNc+7Q3YiYJveMf6kdY/H8f3Mq4Czh5p0rA=
Date:   Mon, 05 Sep 2022 15:02:23 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unnecessary-0-values-from-err.patch added to mm-unstable branch
Message-Id: <20220905220223.D2605C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: remove unnecessary initialization of local `err'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unnecessary-0-values-from-err.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unnecessary-0-values-from-err.patch

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
From: Li zeming <zeming@nfschina.com>
Subject: mm/hugetlb.c: remove unnecessary initialization of local `err'
Date: Mon, 5 Sep 2022 10:09:18 +0800

Link: https://lkml.kernel.org/r/20220905020918.3552-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-remove-unnecessary-0-values-from-err
+++ a/mm/hugetlb.c
@@ -3732,7 +3732,7 @@ static ssize_t demote_store(struct kobje
 	unsigned long nr_available;
 	nodemask_t nodes_allowed, *n_mask;
 	struct hstate *h;
-	int err = 0;
+	int err;
 	int nid;
 
 	err = kstrtoul(buf, 10, &nr_demote);
_

Patches currently in -mm which might be from zeming@nfschina.com are

mm-remove-unnecessary-0-values-from-err.patch

