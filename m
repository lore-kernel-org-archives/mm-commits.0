Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5405C77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbjDFCpR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbjDFCot (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C027290
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9258642B8
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19192C433D2;
        Thu,  6 Apr 2023 02:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749087;
        bh=UwMsV+EFHpH8D/1zzmH9paw/VSNeoqdcQgoDb2Zsd8A=;
        h=Date:To:From:Subject:From;
        b=G5TR2xIrMjujrI0AyopQO3ZifYhInC77sznVmvGPeJl244tUNzRwqhdtXN/Q8SvwI
         CjfzhJSnbvywyJr6XQaNoemxoH8zTrg6kR9/vNhKzEorZnhSAtnmv6DFW/8BxhgJwj
         gv/CpzxIyEexfG/u9pL4+QnxT5yDXdq9WahqZNJc=
Date:   Wed, 05 Apr 2023 19:44:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, shuah@kernel.org, rppt@kernel.org,
        peterx@redhat.com, namit@vmware.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, Liam.Howlett@oracle.com, jack@suse.cz,
        hughd@google.com, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes.patch removed from -mm tree
Message-Id: <20230406024447.19192C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: add UFFDIO_CONTINUE_MODE_WP to install WP PTEs
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: add UFFDIO_CONTINUE_MODE_WP to install WP PTEs
Date: Tue, 14 Mar 2023 15:12:50 -0700

UFFDIO_COPY already has UFFDIO_COPY_MODE_WP, so when installing a new PTE
to resolve a missing fault, one can install a write-protected one.  This
is useful when using UFFDIO_REGISTER_MODE_{MISSING,WP} in combination.

This was motivated by testing HugeTLB HGM [1], and in particular its
interaction with userfaultfd features.  Existing userfaultfd code supports
using WP and MINOR modes together (i.e.  you can register an area with
both enabled), but without this CONTINUE flag the combination is in
practice unusable.

So, add an analogous UFFDIO_CONTINUE_MODE_WP, which does the same thing as
UFFDIO_COPY_MODE_WP, but for *minor* faults.

Update the selftest to do some very basic exercising of the new flag.

Update Documentation/ to describe how these flags are used (neither the
COPY nor the new CONTINUE versions of this mode flag were described there
before).

[1]: https://patchwork.kernel.org/project/linux-mm/cover/20230218002819.1486479-1-jthoughton@google.com/

Link: https://lkml.kernel.org/r/20230314221250.682452-5-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/userfaultfd.rst |    8 ++++++++
 fs/userfaultfd.c                             |    8 ++++++--
 include/linux/userfaultfd_k.h                |    3 ++-
 include/uapi/linux/userfaultfd.h             |    7 +++++++
 mm/userfaultfd.c                             |    5 +++--
 tools/testing/selftests/mm/userfaultfd.c     |    4 ++++
 6 files changed, 30 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -236,6 +236,14 @@ newer kernels, one can also detect the f
 and set the feature bit in advance to make sure none ptes will also be
 write protected even upon anonymous memory.
 
+When using ``UFFDIO_REGISTER_MODE_WP`` in combination with either
+``UFFDIO_REGISTER_MODE_MISSING`` or ``UFFDIO_REGISTER_MODE_MINOR``, when
+resolving missing / minor faults with ``UFFDIO_COPY`` or ``UFFDIO_CONTINUE``
+respectively, it may be desirable for the new page / mapping to be
+write-protected (so future writes will also result in a WP fault). These ioctls
+support a mode flag (``UFFDIO_COPY_MODE_WP`` or ``UFFDIO_CONTINUE_MODE_WP``
+respectively) to configure the mapping this way.
+
 QEMU/KVM
 ========
 
--- a/fs/userfaultfd.c~mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes
+++ a/fs/userfaultfd.c
@@ -1893,6 +1893,7 @@ static int userfaultfd_continue(struct u
 	struct uffdio_continue uffdio_continue;
 	struct uffdio_continue __user *user_uffdio_continue;
 	struct userfaultfd_wake_range range;
+	uffd_flags_t flags = 0;
 
 	user_uffdio_continue = (struct uffdio_continue __user *)arg;
 
@@ -1917,13 +1918,16 @@ static int userfaultfd_continue(struct u
 	    uffdio_continue.range.start) {
 		goto out;
 	}
-	if (uffdio_continue.mode & ~UFFDIO_CONTINUE_MODE_DONTWAKE)
+	if (uffdio_continue.mode & ~(UFFDIO_CONTINUE_MODE_DONTWAKE |
+				     UFFDIO_CONTINUE_MODE_WP))
 		goto out;
+	if (uffdio_continue.mode & UFFDIO_CONTINUE_MODE_WP)
+		flags |= MFILL_ATOMIC_WP;
 
 	if (mmget_not_zero(ctx->mm)) {
 		ret = mfill_atomic_continue(ctx->mm, uffdio_continue.range.start,
 					    uffdio_continue.range.len,
-					    &ctx->mmap_changing);
+					    &ctx->mmap_changing, flags);
 		mmput(ctx->mm);
 	} else {
 		return -ESRCH;
--- a/include/linux/userfaultfd_k.h~mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes
+++ a/include/linux/userfaultfd_k.h
@@ -83,7 +83,8 @@ extern ssize_t mfill_atomic_zeropage(str
 				     unsigned long len,
 				     atomic_t *mmap_changing);
 extern ssize_t mfill_atomic_continue(struct mm_struct *dst_mm, unsigned long dst_start,
-				     unsigned long len, atomic_t *mmap_changing);
+				     unsigned long len, atomic_t *mmap_changing,
+				     uffd_flags_t flags);
 extern int mwriteprotect_range(struct mm_struct *dst_mm,
 			       unsigned long start, unsigned long len,
 			       bool enable_wp, atomic_t *mmap_changing);
--- a/include/uapi/linux/userfaultfd.h~mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes
+++ a/include/uapi/linux/userfaultfd.h
@@ -305,6 +305,13 @@ struct uffdio_writeprotect {
 struct uffdio_continue {
 	struct uffdio_range range;
 #define UFFDIO_CONTINUE_MODE_DONTWAKE		((__u64)1<<0)
+	/*
+	 * UFFDIO_CONTINUE_MODE_WP will map the page write protected on
+	 * the fly.  UFFDIO_CONTINUE_MODE_WP is available only if the
+	 * write protected ioctl is implemented for the range
+	 * according to the uffdio_register.ioctls.
+	 */
+#define UFFDIO_CONTINUE_MODE_WP			((__u64)1<<1)
 	__u64 mode;
 
 	/*
--- a/mm/userfaultfd.c~mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes
+++ a/mm/userfaultfd.c
@@ -693,10 +693,11 @@ ssize_t mfill_atomic_zeropage(struct mm_
 }
 
 ssize_t mfill_atomic_continue(struct mm_struct *dst_mm, unsigned long start,
-			      unsigned long len, atomic_t *mmap_changing)
+			      unsigned long len, atomic_t *mmap_changing,
+			      uffd_flags_t flags)
 {
 	return mfill_atomic(dst_mm, start, 0, len, mmap_changing,
-			    uffd_flags_set_mode(0, MFILL_ATOMIC_CONTINUE));
+			    uffd_flags_set_mode(flags, MFILL_ATOMIC_CONTINUE));
 }
 
 long uffd_wp_range(struct vm_area_struct *dst_vma,
--- a/tools/testing/selftests/mm/userfaultfd.c~mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes
+++ a/tools/testing/selftests/mm/userfaultfd.c
@@ -585,6 +585,8 @@ static void continue_range(int ufd, __u6
 	req.range.start = start;
 	req.range.len = len;
 	req.mode = 0;
+	if (test_uffdio_wp)
+		req.mode |= UFFDIO_CONTINUE_MODE_WP;
 
 	if (ioctl(ufd, UFFDIO_CONTINUE, &req))
 		err("UFFDIO_CONTINUE failed for address 0x%" PRIx64,
@@ -1332,6 +1334,8 @@ static int userfaultfd_minor_test(void)
 	uffdio_register.range.start = (unsigned long)area_dst_alias;
 	uffdio_register.range.len = nr_pages * page_size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MINOR;
+	if (test_uffdio_wp)
+		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
_

Patches currently in -mm which might be from axelrasmussen@google.com are


