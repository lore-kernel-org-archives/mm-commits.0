Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB09BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 21:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiCaVxG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 17:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242038AbiCaVxA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 17:53:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5DD5A159
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 14:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BADE60748
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 21:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82F2C340F0;
        Thu, 31 Mar 2022 21:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648763471;
        bh=tP+5KMVnhqiFmN4DBi95s3HoyZGAfAhhl1zIZ3VfXag=;
        h=Date:To:From:Subject:From;
        b=SoXZefPebe+XeHU9hheWgDhLOyXtMnXpPpfawHNN3myD9JguDGkXLQB2G1de/o1Lx
         uKOj+DFvXapTovVNFZeXIuLpTnQdK9kGsyAKNw77HGLf+M8/8pU8mqTZFslryNtUUG
         RXnr/wRpL1+bZgnco9PV3bvQBDVxDiyqpRxKNjMU=
Date:   Thu, 31 Mar 2022 14:51:10 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftest-vm-clarify-error-statement-in-gup_test.patch removed from -mm tree
Message-Id: <20220331215111.A82F2C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: clarify error statement in gup_test
has been removed from the -mm tree.  Its filename was
     selftest-vm-clarify-error-statement-in-gup_test.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: selftest/vm: clarify error statement in gup_test

Print two possible reasons /sys/kernel/debug/gup_test cannot be opened to
help users of this test diagnose failures.

Link: https://lkml.kernel.org/r/20220330215257.112029-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/gup_test.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/gup_test.c~selftest-vm-clarify-error-statement-in-gup_test
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -206,7 +206,9 @@ int main(int argc, char **argv)
 
 	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
 	if (gup_fd == -1) {
-		perror("open");
+		perror("failed to open /sys/kernel/debug/gup_test");
+		printf("check if CONFIG_GUP_TEST is enabled in kernel config\n");
+		printf("check if debugfs is mounted at /sys/kernel/debug\n");
 		exit(1);
 	}
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


