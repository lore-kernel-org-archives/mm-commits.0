Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84A8C77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 20:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjDNUYk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 16:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjDNUYj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 16:24:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5390810B
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 13:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6594625C9
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 20:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4429AC433EF;
        Fri, 14 Apr 2023 20:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681503877;
        bh=qiudelpbNdBpqap71ytKs9m+4PV2dtL4Be3UPDoPuTI=;
        h=Date:To:From:Subject:From;
        b=IBw5LlNbitivc6zWcEGxNvRv8DPcYtrl7uWQmR3FTKNarWnIS+o6ZkmGWTqc8Za2X
         6+DG/ek+BgdinFYISTeyVx9ToMLe3tziK6pjVwfvKQ2seoPdDMfs+EmJ7TAu+w258K
         t8fsungeoO5D2qaTCv0pYIlQzukVM/4rXzDGXmC8=
Date:   Fri, 14 Apr 2023 13:24:36 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege-fix.patch added to mm-unstable branch
Message-Id: <20230414202437.4429AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: Fix spelling mistake "priviledge" -> "privilege"
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege-fix.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftests/mm: Fix spelling mistake "priviledge" -> "privilege"
Date: Fri, 14 Apr 2023 09:15:06 +0100

There is a spelling mistake in an error message string. Fix it.

Link: https://lkml.kernel.org/r/20230414081506.1678998-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege-fix
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -314,7 +314,7 @@ int uffd_test_ctx_init(uint64_t features
 	ret = userfaultfd_open(&features);
 	if (ret) {
 		if (errmsg)
-			*errmsg = "possible lack of priviledge";
+			*errmsg = "possible lack of privilege";
 		return ret;
 	}
 
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mm-truncate-remove-redundant-initialization-of-new_order.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege-fix.patch

