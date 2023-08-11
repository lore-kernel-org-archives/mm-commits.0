Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDB1C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbjHKXBP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237149AbjHKXAC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F390235B6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798F967B33
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EA9C433C8;
        Fri, 11 Aug 2023 22:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794793;
        bh=f8iH/sNxi4pWiVoH7KCp7q8fqi7ibKgiApKbDigATBE=;
        h=Date:To:From:Subject:From;
        b=DM4QBicEcVjnDQzMwqhIiPQJ8vKXQ0Y+GIFx96LuufVNMCgezx3Lt6M7UGQIteypz
         Ux+8mUH1vvGPlR+Sv5VWRnvyVEDNGgLqj1blS3JpRfRjP579q9t0ZZV75pPSpfez2i
         fWMgYSJ7+knGAOCcGR3BEMdEqBrJjqKR+8TxScJY=
Date:   Fri, 11 Aug 2023 15:59:53 -0700
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
Subject: [merged mm-stable] mm-userfaultfd-add-new-uffdio_poison-ioctl.patch removed from -mm tree
Message-Id: <20230811225953.C0EA9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: add new UFFDIO_POISON ioctl
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-add-new-uffdio_poison-ioctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: add new UFFDIO_POISON ioctl
Date: Fri, 7 Jul 2023 14:55:36 -0700

The basic idea here is to "simulate" memory poisoning for VMs.  A VM
running on some host might encounter a memory error, after which some
page(s) are poisoned (i.e., future accesses SIGBUS).  They expect that
once poisoned, pages can never become "un-poisoned".  So, when we live
migrate the VM, we need to preserve the poisoned status of these pages.

When live migrating, we try to get the guest running on its new host as
quickly as possible.  So, we start it running before all memory has been
copied, and before we're certain which pages should be poisoned or not.

So the basic way to use this new feature is:

- On the new host, the guest's memory is registered with userfaultfd, in
  either MISSING or MINOR mode (doesn't really matter for this purpose).
- On any first access, we get a userfaultfd event. At this point we can
  communicate with the old host to find out if the page was poisoned.
- If so, we can respond with a UFFDIO_POISON - this places a swap marker
  so any future accesses will SIGBUS. Because the pte is now "present",
  future accesses won't generate more userfaultfd events, they'll just
  SIGBUS directly.

UFFDIO_POISON does not handle unmapping previously-present PTEs.  This
isn't needed, because during live migration we want to intercept all
accesses with userfaultfd (not just writes, so WP mode isn't useful for
this).  So whether minor or missing mode is being used (or both), the PTE
won't be present in any case, so handling that case isn't needed.

Similarly, UFFDIO_POISON won't replace existing PTE markers.  This might
be okay to do, but it seems to be safer to just refuse to overwrite any
existing entry (like a UFFD_WP PTE marker).

Link: https://lkml.kernel.org/r/20230707215540.2324998-5-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
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

 fs/userfaultfd.c                 |   58 +++++++++++++++++++++++++++++
 include/linux/userfaultfd_k.h    |    4 ++
 include/uapi/linux/userfaultfd.h |   16 ++++++++
 mm/userfaultfd.c                 |   48 +++++++++++++++++++++++-
 4 files changed, 125 insertions(+), 1 deletion(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-add-new-uffdio_poison-ioctl
+++ a/fs/userfaultfd.c
@@ -1967,6 +1967,61 @@ out:
 	return ret;
 }
 
+static inline int userfaultfd_poison(struct userfaultfd_ctx *ctx, unsigned long arg)
+{
+	__s64 ret;
+	struct uffdio_poison uffdio_poison;
+	struct uffdio_poison __user *user_uffdio_poison;
+	struct userfaultfd_wake_range range;
+
+	user_uffdio_poison = (struct uffdio_poison __user *)arg;
+
+	ret = -EAGAIN;
+	if (atomic_read(&ctx->mmap_changing))
+		goto out;
+
+	ret = -EFAULT;
+	if (copy_from_user(&uffdio_poison, user_uffdio_poison,
+			   /* don't copy the output fields */
+			   sizeof(uffdio_poison) - (sizeof(__s64))))
+		goto out;
+
+	ret = validate_range(ctx->mm, uffdio_poison.range.start,
+			     uffdio_poison.range.len);
+	if (ret)
+		goto out;
+
+	ret = -EINVAL;
+	if (uffdio_poison.mode & ~UFFDIO_POISON_MODE_DONTWAKE)
+		goto out;
+
+	if (mmget_not_zero(ctx->mm)) {
+		ret = mfill_atomic_poison(ctx->mm, uffdio_poison.range.start,
+					  uffdio_poison.range.len,
+					  &ctx->mmap_changing, 0);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+
+	if (unlikely(put_user(ret, &user_uffdio_poison->updated)))
+		return -EFAULT;
+	if (ret < 0)
+		goto out;
+
+	/* len == 0 would wake all */
+	BUG_ON(!ret);
+	range.len = ret;
+	if (!(uffdio_poison.mode & UFFDIO_POISON_MODE_DONTWAKE)) {
+		range.start = uffdio_poison.range.start;
+		wake_userfault(ctx, &range);
+	}
+	ret = range.len == uffdio_poison.range.len ? 0 : -EAGAIN;
+
+out:
+	return ret;
+}
+
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
@@ -2068,6 +2123,9 @@ static long userfaultfd_ioctl(struct fil
 	case UFFDIO_CONTINUE:
 		ret = userfaultfd_continue(ctx, arg);
 		break;
+	case UFFDIO_POISON:
+		ret = userfaultfd_poison(ctx, arg);
+		break;
 	}
 	return ret;
 }
--- a/include/linux/userfaultfd_k.h~mm-userfaultfd-add-new-uffdio_poison-ioctl
+++ a/include/linux/userfaultfd_k.h
@@ -46,6 +46,7 @@ enum mfill_atomic_mode {
 	MFILL_ATOMIC_COPY,
 	MFILL_ATOMIC_ZEROPAGE,
 	MFILL_ATOMIC_CONTINUE,
+	MFILL_ATOMIC_POISON,
 	NR_MFILL_ATOMIC_MODES,
 };
 
@@ -83,6 +84,9 @@ extern ssize_t mfill_atomic_zeropage(str
 extern ssize_t mfill_atomic_continue(struct mm_struct *dst_mm, unsigned long dst_start,
 				     unsigned long len, atomic_t *mmap_changing,
 				     uffd_flags_t flags);
+extern ssize_t mfill_atomic_poison(struct mm_struct *dst_mm, unsigned long start,
+				   unsigned long len, atomic_t *mmap_changing,
+				   uffd_flags_t flags);
 extern int mwriteprotect_range(struct mm_struct *dst_mm,
 			       unsigned long start, unsigned long len,
 			       bool enable_wp, atomic_t *mmap_changing);
--- a/include/uapi/linux/userfaultfd.h~mm-userfaultfd-add-new-uffdio_poison-ioctl
+++ a/include/uapi/linux/userfaultfd.h
@@ -71,6 +71,7 @@
 #define _UFFDIO_ZEROPAGE		(0x04)
 #define _UFFDIO_WRITEPROTECT		(0x06)
 #define _UFFDIO_CONTINUE		(0x07)
+#define _UFFDIO_POISON			(0x08)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -91,6 +92,8 @@
 				      struct uffdio_writeprotect)
 #define UFFDIO_CONTINUE		_IOWR(UFFDIO, _UFFDIO_CONTINUE,	\
 				      struct uffdio_continue)
+#define UFFDIO_POISON		_IOWR(UFFDIO, _UFFDIO_POISON, \
+				      struct uffdio_poison)
 
 /* read() structure */
 struct uffd_msg {
@@ -225,6 +228,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_EXACT_ADDRESS		(1<<11)
 #define UFFD_FEATURE_WP_HUGETLBFS_SHMEM		(1<<12)
 #define UFFD_FEATURE_WP_UNPOPULATED		(1<<13)
+#define UFFD_FEATURE_POISON			(1<<14)
 	__u64 features;
 
 	__u64 ioctls;
@@ -321,6 +325,18 @@ struct uffdio_continue {
 	__s64 mapped;
 };
 
+struct uffdio_poison {
+	struct uffdio_range range;
+#define UFFDIO_POISON_MODE_DONTWAKE		((__u64)1<<0)
+	__u64 mode;
+
+	/*
+	 * Fields below here are written by the ioctl and must be at the end:
+	 * the copy_from_user will not read past here.
+	 */
+	__s64 updated;
+};
+
 /*
  * Flags for the userfaultfd(2) system call itself.
  */
--- a/mm/userfaultfd.c~mm-userfaultfd-add-new-uffdio_poison-ioctl
+++ a/mm/userfaultfd.c
@@ -288,6 +288,40 @@ out_release:
 	goto out;
 }
 
+/* Handles UFFDIO_POISON for all non-hugetlb VMAs. */
+static int mfill_atomic_pte_poison(pmd_t *dst_pmd,
+				   struct vm_area_struct *dst_vma,
+				   unsigned long dst_addr,
+				   uffd_flags_t flags)
+{
+	int ret;
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	pte_t _dst_pte, *dst_pte;
+	spinlock_t *ptl;
+
+	_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
+	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
+
+	if (mfill_file_over_size(dst_vma, dst_addr)) {
+		ret = -EFAULT;
+		goto out_unlock;
+	}
+
+	ret = -EEXIST;
+	/* Refuse to overwrite any PTE, even a PTE marker (e.g. UFFD WP). */
+	if (!pte_none(*dst_pte))
+		goto out_unlock;
+
+	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+
+	/* No need to invalidate - it was non-present before */
+	update_mmu_cache(dst_vma, dst_addr, dst_pte);
+	ret = 0;
+out_unlock:
+	pte_unmap_unlock(dst_pte, ptl);
+	return ret;
+}
+
 static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
 {
 	pgd_t *pgd;
@@ -339,7 +373,8 @@ static __always_inline ssize_t mfill_ato
 	 * by THP.  Since we can not reliably insert a zero page, this
 	 * feature is not supported.
 	 */
-	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE) ||
+	    uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
 		mmap_read_unlock(dst_mm);
 		return -EINVAL;
 	}
@@ -483,6 +518,9 @@ static __always_inline ssize_t mfill_ato
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE)) {
 		return mfill_atomic_pte_continue(dst_pmd, dst_vma,
 						 dst_addr, flags);
+	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
+		return mfill_atomic_pte_poison(dst_pmd, dst_vma,
+					       dst_addr, flags);
 	}
 
 	/*
@@ -704,6 +742,14 @@ ssize_t mfill_atomic_continue(struct mm_
 			    uffd_flags_set_mode(flags, MFILL_ATOMIC_CONTINUE));
 }
 
+ssize_t mfill_atomic_poison(struct mm_struct *dst_mm, unsigned long start,
+			    unsigned long len, atomic_t *mmap_changing,
+			    uffd_flags_t flags)
+{
+	return mfill_atomic(dst_mm, start, 0, len, mmap_changing,
+			    uffd_flags_set_mode(flags, MFILL_ATOMIC_POISON));
+}
+
 long uffd_wp_range(struct vm_area_struct *dst_vma,
 		   unsigned long start, unsigned long len, bool enable_wp)
 {
_

Patches currently in -mm which might be from axelrasmussen@google.com are


