Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21F4C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 23:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353415AbiD1XvN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353408AbiD1XvJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 19:51:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3969DAAE33
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 16:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C97136212C
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 23:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C29C385AD;
        Thu, 28 Apr 2022 23:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651189671;
        bh=tm9J9F6lEq3znO/l2sUORoZwpzoqIpgk8yNlEF3/BbQ=;
        h=Date:To:From:Subject:From;
        b=2o6oVnG8Iee13HTEoaOSePY8eIROmr1dUNdmMdWB7CPjPfRXISn12t4dsac6/2rri
         1EPDRgc750wh9DNW7IzJQIo3tEJG3xnMlK2I29do3kotofMl0tAlrUahitt7R0hp5A
         T5vXIxeqkGfvB56vjQ0gJbKABkiFT4WLzgSob3rs=
Date:   Thu, 28 Apr 2022 16:47:50 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, dossche.niels@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-test-that-mremap-fails-on-non-existent-vma.patch added to -mm tree
Message-Id: <20220428234751.29C29C385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: test that mremap fails on non-existent vma
has been added to the -mm tree.  Its filename is
     selftest-vm-test-that-mremap-fails-on-non-existent-vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-test-that-mremap-fails-on-non-existent-vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-test-that-mremap-fails-on-non-existent-vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Niels Dossche <dossche.niels@gmail.com>
Subject: selftest/vm: test that mremap fails on non-existent vma

Add a regression test that validates that mremap fails for vma's that
don't exist.

Link: https://lkml.kernel.org/r/20220427224439.23828-3-dossche.niels@gmail.com
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~selftest-vm-test-that-mremap-fails-on-non-existent-vma
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -178,6 +178,12 @@ int main(int argc, char *argv[])
 
 	munmap(addr, length);
 
+	addr = mremap(addr, length, length, 0);
+	if (addr != MAP_FAILED) {
+		printf("mremap: Expected failure, but call succeeded\n");
+		exit(1);
+	}
+
 	close(fd);
 	unlink(argv[argc-1]);
 
_

Patches currently in -mm which might be from dossche.niels@gmail.com are

mm-mremap-fix-sign-for-efault-error-return-value.patch
selftest-vm-test-that-mremap-fails-on-non-existent-vma.patch

