Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E671FE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjJDURl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjJDURi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3339CBF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF3FC433C8;
        Wed,  4 Oct 2023 20:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450654;
        bh=Wl8MDOXsyV+re82n420o4qpE8lJCzgu+iBFL5bXWV+Y=;
        h=Date:To:From:Subject:From;
        b=zOT2Cwv7JM1payEu4qVajrBTHm8Ro4bmrbDjTxL+bx9a49PW10/ysKaoSEe4B4Bwx
         atAclXBtjfddNmFyhwKOMpknPym1aa7Hml9UyG9b3xVm9XXb3FMszPLhIVkLdJP5+U
         WFz9y53frfoO0CZsi/L0e8dHMDakvzCgOWEvChFE=
Date:   Wed, 04 Oct 2023 13:17:33 -0700
To:     mm-commits@vger.kernel.org, dingxiang@cmss.chinamobile.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gup_longterm-fix-a-resource-leak.patch removed from -mm tree
Message-Id: <20231004201734.6CF3FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: gup_longterm: fix a resource leak
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_longterm-fix-a-resource-leak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: selftests/mm: gup_longterm: fix a resource leak
Date: Thu, 31 Aug 2023 17:31:44 +0800

The opened file should be closed in run_with_tmpfile(), otherwise resource
leak will occur

Link: https://lkml.kernel.org/r/20230831093144.7520-1-dingxiang@cmss.chinamobile.com
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-gup_longterm-fix-a-resource-leak
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -265,10 +265,11 @@ static void run_with_tmpfile(test_fn fn,
 	fd = fileno(file);
 	if (fd < 0) {
 		ksft_test_result_fail("fileno() failed\n");
-		return;
+		goto close;
 	}
 
 	fn(fd, pagesize);
+close:
 	fclose(file);
 }
 
_

Patches currently in -mm which might be from dingxiang@cmss.chinamobile.com are


