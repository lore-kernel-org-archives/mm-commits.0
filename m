Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86FAC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjHKW0B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbjHKW0B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:26:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8060D7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DFE9651AA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B607DC433C7;
        Fri, 11 Aug 2023 22:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691792759;
        bh=TugQojQIiP+bG5Yetad/EAkOddBA/4MklUGDwfX+Ers=;
        h=Date:To:From:Subject:From;
        b=qP4JhJuU3PTJST3/hk+HntQng8trgCO0wCV4Ek3UAXcLai3hknFez36rahnRrtRUR
         qcB6SWP7NL5N0gebVcXZZI/sjJkTECcuFE7SMDdqE0q26uqRiQgHQ8yz860SLALlNp
         kfu2PJGJ4Oru5/ASYpw3WVJYP0NTaOrvuOIukvD8=
Date:   Fri, 11 Aug 2023 15:25:59 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix.patch removed from -mm tree
Message-Id: <20230811222559.B607DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: check for start + len overflow in validate_range: fix
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix.patch

This patch was dropped because it was folded into mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch

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
mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix-2.patch
mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl.patch
mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch
mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch
selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch
selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch

