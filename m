Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2293EC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 22:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiFKWMO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 18:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiFKWMN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 18:12:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC991A4
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 15:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25B22B80B4D
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 22:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FBAC3411C;
        Sat, 11 Jun 2022 22:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654985527;
        bh=pL5Ei/iEzDgcNHrAPR/oYuf7IoNm9Cj4+6tk37Lo3Hk=;
        h=Date:To:From:Subject:From;
        b=GEElbNYSo7eWB8rD0w2mHaZ9Dj3nl/rii7Yq7G6fVhpxcFmasyzQnc9YleaPn/USV
         LsV5wZ4w1R40lE6ypp69EKEmYJcRiDl5ZdErjPhwpcVz91KUpem6v/3Dvee9hd5SFP
         N3QRW5T12yBCq8vtk6n6EVRlHabKE6mIVLdQseII=
Date:   Sat, 11 Jun 2022 15:12:07 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        npache@redhat.com, jsavitz@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-make-use-of-gup_test_file-macro.patch added to mm-unstable branch
Message-Id: <20220611221207.D4FBAC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: make use of GUP_TEST_FILE macro
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-make-use-of-gup_test_file-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-make-use-of-gup_test_file-macro.patch

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

selftests-make-use-of-gup_test_file-macro.patch

