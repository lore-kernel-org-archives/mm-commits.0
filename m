Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EC7C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjDRXUP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjDRXUO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8AC526E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A90E9601C3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABF5C433D2;
        Tue, 18 Apr 2023 23:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860013;
        bh=xJTmbjg0B9tFH/01qe+TPlwmfxSrk81vt5vJ4qkJR2g=;
        h=Date:To:From:Subject:From;
        b=I+mY5sYdrLGrcnH0UFLNMEfklasSvy1uADVpjC64QUvMmHe0zqhP7t6wSDC4qaagv
         NVLWxUrdX0PB7zYLHgObGFCGUzjmEFZcjAZAYuIUuxA6MTUFmW5jh6YDqDwKbsu4BM
         7xwyttI3iI5zOS8scucfNErL1YilhG2V2EX/f1ro=
Date:   Tue, 18 Apr 2023 16:20:12 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege-fix.patch removed from -mm tree
Message-Id: <20230418232013.0ABF5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: Fix spelling mistake "priviledge" -> "privilege"
has been removed from the -mm tree.  Its filename was
     selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege-fix.patch

This patch was dropped because it was folded into selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch

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

selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch

