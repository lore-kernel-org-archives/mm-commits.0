Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2132EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379850AbiFQCtw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379823AbiFQCtn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDA765411
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86A0D61D25
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC49C3411A;
        Fri, 17 Jun 2022 02:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434181;
        bh=VnZ6HBEERKXPA7KE6XGGCMLz9YjW9nkJ69s64d3zSCg=;
        h=Date:To:From:Subject:From;
        b=jcr4WzeLloRVdxuHqjqsFoLJg0uSlFz04dwnSCOGDFlOOYfHx/xZJ5l+kjWNmYs1Y
         NVr8H1DMSHv8u33Rhyo5UvkkJfaWnHvXnvlMp4hMiMnvWSXVvY6u4igiWNTXqxj459
         5Lu/QnFPHyvt/3UR8xYJfkmQ2WT1R6Y61lwGe5h0=
Date:   Thu, 16 Jun 2022 19:49:41 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        npache@redhat.com, jsavitz@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-make-use-of-gup_test_file-macro.patch removed from -mm tree
Message-Id: <20220617024941.DAC49C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: make use of GUP_TEST_FILE macro
has been removed from the -mm tree.  Its filename was
     selftests-make-use-of-gup_test_file-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joel Savitz <jsavitz@redhat.com>
Subject: selftests: make use of GUP_TEST_FILE macro
Date: Thu, 9 Jun 2022 16:32:17 -0400

Commit 17de1e559cf1 ("selftests: clarify common error when running
gup_test") had most of its hunks dropped due to a conflict with another
patch accepted into Linux around the same time that implemented the same
behavior as a subset of other changes.

However, the remaining hunk defines the GUP_TEST_FILE macro without making
use of it.  This patch makes use of the macro in the two relevant places.

Furthermore, the above mentioned commit's log message erroneously
describes the changes that were dropped from the patch.

This patch corrects the record.

Link: https://lkml.kernel.org/r/20220609203217.3206247-1-jsavitz@redhat.com
Fixes: 17de1e559cf1 ("selftests: clarify common error when running gup_test")
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/gup_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/gup_test.c~selftests-make-use-of-gup_test_file-macro
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -209,7 +209,7 @@ int main(int argc, char **argv)
 	if (write)
 		gup.gup_flags |= FOLL_WRITE;
 
-	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	gup_fd = open(GUP_TEST_FILE, O_RDWR);
 	if (gup_fd == -1) {
 		switch (errno) {
 		case EACCES:
@@ -224,7 +224,7 @@ int main(int argc, char **argv)
 			printf("check if CONFIG_GUP_TEST is enabled in kernel config\n");
 			break;
 		default:
-			perror("failed to open /sys/kernel/debug/gup_test");
+			perror("failed to open " GUP_TEST_FILE);
 			break;
 		}
 		exit(KSFT_SKIP);
_

Patches currently in -mm which might be from jsavitz@redhat.com are


