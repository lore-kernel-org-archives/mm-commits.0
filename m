Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390A4EB64DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 18:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbjGNSb5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 14:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbjGNSb4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 14:31:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DAB1BEB
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 11:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28CE461DC1
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 18:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7469BC433C7;
        Fri, 14 Jul 2023 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689359514;
        bh=wxpz5CRWE3crfPx8CeoEZSNeKoKw4aOh1uIy7LquDqw=;
        h=Date:To:From:Subject:From;
        b=m7GSdWHplY47XcfbeBxMqDZnxEJPTxXQ8QtBVDratKaEkUu0u7VQwhUitc3bkYKmH
         sZmyTKFniwdzlWc9/TzjP2m9nluVf0VDQs3Fkqm5pnFIfPNsPgyG7CPQCvMr6G1+Ay
         5FjIC6I9r9ittM3DXUW1riKYy9AMcU8HGXa2nZnA=
Date:   Fri, 14 Jul 2023 11:31:53 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix.patch added to mm-unstable branch
Message-Id: <20230714183154.7469BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: check for start + len overflow in validate_range: fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix.patch

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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: check for start + len overflow in validate_range: fix
Date: Fri, 14 Jul 2023 11:29:32 -0700

This commit removed an extra check for zero-length ranges, and folded it
into the common validate_range() helper used by all UFFD ioctls.

It failed to notice though that UFFDIO_COPY *only* called validate_range
on the dst range, not the src range.  So removing this check actually let
us proceed with zero-length source ranges, eventually hitting a BUG
further down in the call stack.

The correct fix seems clear: call validate_range() on the src range too.

Other ioctls are not affected by this, as they only have one range, not
two (src + dst).

Link: https://lkml.kernel.org/r/20230714182932.2608735-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reported-by: syzbot+42309678e0bc7b32f8e9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=42309678e0bc7b32f8e9
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/userfaultfd.c~mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix
+++ a/fs/userfaultfd.c
@@ -1753,6 +1753,9 @@ static int userfaultfd_copy(struct userf
 			   sizeof(uffdio_copy)-sizeof(__s64)))
 		goto out;
 
+	ret = validate_range(ctx->mm, uffdio_copy.src, uffdio_copy.len);
+	if (ret)
+		goto out;
 	ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
 	if (ret)
 		goto out;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mm-make-pte_marker_swapin_error-more-general.patch
mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch
mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix.patch
mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl.patch
mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch
mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch
selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch
selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch

