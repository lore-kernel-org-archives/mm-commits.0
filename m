Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8423CC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbjHKXBE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237139AbjHKXAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C993AB3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 668CE678E6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B052DC433C9;
        Fri, 11 Aug 2023 22:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794790;
        bh=K0eD410C9sJOJdpzQ0bxzXIaPYWa1UOMw3KgL80JEpw=;
        h=Date:To:From:Subject:From;
        b=KTCgEYPEvlKJzpr+bYAnsHp8RRXhsMsSIFk2ZCtEC9qrBV2izP47NPHW8yLQBLiHe
         cwsYToE9T7Jmxy5LDYbXhBOkB6yQXFmRoUgQWGhaEo+gX1HZcZ/3iCIvY5bD57VFcw
         OljVbiYR+Bya8okMgl0MepAD9dtW6vjUfODXeX/4=
Date:   Fri, 11 Aug 2023 15:59:50 -0700
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
Subject: [merged mm-stable] mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch removed from -mm tree
Message-Id: <20230811225950.B052DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: check for start + len overflow in validate_range
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[axelrasmussen@google.com: call validate_range() on the src range too]
  Link: https://lkml.kernel.org/r/20230714182932.2608735-1-axelrasmussen@google.com
[axelrasmussen@google.com: fix src/dst validation]
  Link: https://lkml.kernel.org/r/20230810192128.1855570-1-axelrasmussen@google.com
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

 fs/userfaultfd.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-check-for-start-len-overflow-in-validate_range
+++ a/fs/userfaultfd.c
@@ -1289,13 +1289,11 @@ static __always_inline void wake_userfau
 		__wake_userfault(ctx, range);
 }
 
-static __always_inline int validate_range(struct mm_struct *mm,
-					  __u64 start, __u64 len)
+static __always_inline int validate_unaligned_range(
+	struct mm_struct *mm, __u64 start, __u64 len)
 {
 	__u64 task_size = mm->task_size;
 
-	if (start & ~PAGE_MASK)
-		return -EINVAL;
 	if (len & ~PAGE_MASK)
 		return -EINVAL;
 	if (!len)
@@ -1306,9 +1304,20 @@ static __always_inline int validate_rang
 		return -EINVAL;
 	if (len > task_size - start)
 		return -EINVAL;
+	if (start + len <= start)
+		return -EINVAL;
 	return 0;
 }
 
+static __always_inline int validate_range(struct mm_struct *mm,
+					  __u64 start, __u64 len)
+{
+	if (start & ~PAGE_MASK)
+		return -EINVAL;
+
+	return validate_unaligned_range(mm, start, len);
+}
+
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -1757,17 +1766,15 @@ static int userfaultfd_copy(struct userf
 			   sizeof(uffdio_copy)-sizeof(__s64)))
 		goto out;
 
+	ret = validate_unaligned_range(ctx->mm, uffdio_copy.src,
+				       uffdio_copy.len);
+	if (ret)
+		goto out;
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
@@ -1927,11 +1934,6 @@ static int userfaultfd_continue(struct u
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


