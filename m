Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB481C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 01:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbiCaB4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242593AbiCaB4C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 21:56:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B7A4BFD0
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 18:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF780B81E23
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 01:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E054C340EC;
        Thu, 31 Mar 2022 01:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648691652;
        bh=7D4FH2v0/7Sb+cbdlQNvH1xEnts29xAoBSBMZjQqiq8=;
        h=Date:To:From:Subject:From;
        b=lO8Wmft1c+IgfeAksWygfadh2ihPubcPqw0o4wmOC7ACl8C1gNs5iONjPs/Bvb/ln
         RMxbi9LYcNYXrE2GZKlJcJzij1R2LOhwIGp3f2OrIYOM6gPW0rwSOUgEKU1sN3Po4c
         zfSUHljG88DUCZV0X248oJTySHljDe7AOMITfDsk=
Date:   Wed, 30 Mar 2022 18:54:11 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-clarify-error-statement-in-gup_test.patch added to -mm tree
Message-Id: <20220331015412.6E054C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: clarify error statement in gup_test
has been added to the -mm tree.  Its filename is
     selftest-vm-clarify-error-statement-in-gup_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-clarify-error-statement-in-gup_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-clarify-error-statement-in-gup_test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

selftest-vm-clarify-error-statement-in-gup_test.patch

