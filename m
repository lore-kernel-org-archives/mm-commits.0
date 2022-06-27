Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28682C43334
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 17:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbiF0Rql (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 13:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237628AbiF0Rqk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 13:46:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F89D111
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 10:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 805A8614ED
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 17:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF401C3411D;
        Mon, 27 Jun 2022 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656351998;
        bh=f8EMWkd5CZBvWCpDoDQIKWkRoyaUH4vWBBsdstGQwdI=;
        h=Date:To:From:Subject:From;
        b=JAUUj8VjTkdZDqRwCtsqa8nPPB79rvGQbZNaLMfgo9cme7p4wcgVvZ9yHYyGfJW0C
         Urx+Gyt4kNCQxAl875VlyK32ddQ2JGw2+MRejnyAWh3fqS7BYJnK2Yj4jFBM49wtla
         +1LlEnLCJf40I8GlT7OO5oMHq3XeZlk0m8b/CmUk=
Date:   Mon, 27 Jun 2022 10:46:38 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        dingxiang@cmss.chinamobile.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-vm-fix-resource-leak-when-return-error.patch removed from -mm tree
Message-Id: <20220627174638.CF401C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/testing/selftests/vm/ksm_tests.c: fix resource leak when return error
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-resource-leak-when-return-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: tools/testing/selftests/vm/ksm_tests.c: fix resource leak when return error
Date: Wed, 15 Jun 2022 17:36:29 +0800

When return on an error path, file handle need to be closed to prevent
resource leak

Link: https://lkml.kernel.org/r/20220615093629.1330809-1-dingxiang@cmss.chinamobile.com
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-fix-resource-leak-when-return-error
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -54,6 +54,7 @@ static int ksm_write_sysfs(const char *f
 	}
 	if (fprintf(f, "%lu", val) < 0) {
 		perror("fprintf");
+		fclose(f);
 		return 1;
 	}
 	fclose(f);
@@ -72,6 +73,7 @@ static int ksm_read_sysfs(const char *fi
 	}
 	if (fscanf(f, "%lu", val) != 1) {
 		perror("fscanf");
+		fclose(f);
 		return 1;
 	}
 	fclose(f);
_

Patches currently in -mm which might be from dingxiang@cmss.chinamobile.com are


