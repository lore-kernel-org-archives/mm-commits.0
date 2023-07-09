Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DECEB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjGIAzZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjGIAzV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:55:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45B01B1
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:55:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D92860B68
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9301C433C7;
        Sun,  9 Jul 2023 00:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688864119;
        bh=EmGWZXtRYErt42cKWWkqdUC8+HRkew8p1iUcE7RAFjA=;
        h=Date:To:From:Subject:From;
        b=YtHH/Igqrrqs9h+8ZB+PBvkZ64vAMJ1WqvZ0qXkoRdErZg1TvZGLDTOd2AVXR5dVV
         8WvhNAc2tcZV+jNEqYZSgl4Md37G49BvtcJVWazgzeem9G1Imy9qrF25LPZ9hQNXSJ
         IbhgjZwmcOsTo/eQRhKEdVH4T6ikuhA9xyd0QBDw=
Date:   Sat, 08 Jul 2023 17:55:19 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        yuzhao@google.com, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, viro@zeniv.linux.org.uk,
        talumbau@google.com, surenb@google.com, suleiman@google.com,
        shuah@kernel.org, ryan.roberts@arm.com, rppt@kernel.org,
        peterx@redhat.com, naoya.horiguchi@nec.com, namit@vmware.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, Liam.Howlett@oracle.com,
        jthoughton@google.com, jiaqiyan@google.com, hughd@google.com,
        heftig@archlinux.org, david@redhat.com, cuigaosheng1@huawei.com,
        corbet@lwn.net, brauner@kernel.org, bgeffon@google.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch added to mm-unstable branch
Message-Id: <20230709005519.B9301C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: check for start + len overflow in validate_range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch

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
Subject: mm: userfaultfd: check for start + len overflow in validate_range
Date: Fri, 7 Jul 2023 14:55:34 -0700

Most userfaultfd ioctls take a `start + len` range as an argument.  We
have the validate_range helper to check that such ranges are valid. 
However, some (but not all!) ioctls *also* check that `start + len`
doesn't wrap around (overflow).

Just check for this in validate_range.  This saves some repetitive code,
and adds the check to some ioctls which weren't bothering to check for it
before.

Link: https://lkml.kernel.org/r/20230707215540.2324998-3-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-check-for-start-len-overflow-in-validate_range
+++ a/fs/userfaultfd.c
@@ -1300,6 +1300,8 @@ static __always_inline int validate_rang
 		return -EINVAL;
 	if (len > task_size - start)
 		return -EINVAL;
+	if (start + len <= start)
+		return -EINVAL;
 	return 0;
 }
 
@@ -1754,14 +1756,8 @@ static int userfaultfd_copy(struct userf
 	ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
 	if (ret)
 		goto out;
-	/*
-	 * double check for wraparound just in case. copy_from_user()
-	 * will later check uffdio_copy.src + uffdio_copy.len to fit
-	 * in the userland range.
-	 */
+
 	ret = -EINVAL;
-	if (uffdio_copy.src + uffdio_copy.len <= uffdio_copy.src)
-		goto out;
 	if (uffdio_copy.mode & ~(UFFDIO_COPY_MODE_DONTWAKE|UFFDIO_COPY_MODE_WP))
 		goto out;
 	if (uffdio_copy.mode & UFFDIO_COPY_MODE_WP)
@@ -1921,11 +1917,6 @@ static int userfaultfd_continue(struct u
 		goto out;
 
 	ret = -EINVAL;
-	/* double check for wraparound just in case. */
-	if (uffdio_continue.range.start + uffdio_continue.range.len <=
-	    uffdio_continue.range.start) {
-		goto out;
-	}
 	if (uffdio_continue.mode & ~(UFFDIO_CONTINUE_MODE_DONTWAKE |
 				     UFFDIO_CONTINUE_MODE_WP))
 		goto out;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mm-make-pte_marker_swapin_error-more-general.patch
mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch
mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl.patch
mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch
mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch
selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch
selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch

