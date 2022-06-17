Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF5BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379852AbiFQCt4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379827AbiFQCto (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B0A65418
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41259B826F2
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD219C34114;
        Fri, 17 Jun 2022 02:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434180;
        bh=uVPPOuA48PD6qxLVangzdEGfoIIo0KMax5huukEYklY=;
        h=Date:To:From:Subject:From;
        b=D2TMRUk/CJE2GGnxWrVyAplFHf9npiftx0EvP5bxE0fjsS+lkY2mPjlfNTDDCjeSd
         fzHTIQJ7p2CaPXxjnc6JiAzSPZaSt61IoPP9Bl8qRKu7ftD5PuAVkCPXDSA6rtgSJL
         rtMHr76GnKi+OUBHnpf24TuLVX5CNwvJsLSamNWQ=
Date:   Thu, 16 Jun 2022 19:49:40 -0700
To:     mm-commits@vger.kernel.org, wangxiang@cdjrlc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-selftests-fix-typo-in-comment.patch removed from -mm tree
Message-Id: <20220617024940.CD219C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd/selftests: fix typo in comment
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-fix-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiang wangx <wangxiang@cdjrlc.com>
Subject: userfaultfd/selftests: fix typo in comment
Date: Fri, 10 Jun 2022 15:12:44 +0800

Delete the redundant word 'in'.

Link: https://lkml.kernel.org/r/20220610071244.59679-1-wangxiang@cdjrlc.com
Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-typo-in-comment
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -860,7 +860,7 @@ static int stress(struct uffd_stats *uff
 	/*
 	 * Be strict and immediately zap area_src, the whole area has
 	 * been transferred already by the background treads. The
-	 * area_src could then be faulted in in a racy way by still
+	 * area_src could then be faulted in a racy way by still
 	 * running uffdio_threads reading zeropages after we zapped
 	 * area_src (but they're guaranteed to get -EEXIST from
 	 * UFFDIO_COPY without writing zero pages into area_dst
_

Patches currently in -mm which might be from wangxiang@cdjrlc.com are


