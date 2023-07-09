Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BE6EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjGIAzi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjGIAzb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:55:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7061B9
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1941D60B6B
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B08C433C8;
        Sun,  9 Jul 2023 00:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688864129;
        bh=P4RT42CUpMeNsb4U2Uvj0XMrr0gwLQ3ApuOldjvs4Mw=;
        h=Date:To:From:Subject:From;
        b=mxbHjpm/uPrQCyxhZwxIOokWZv4mmkGsDMLc6VlzJ8xxyiTsOsk+4Jx3A56Xl+t05
         11jY2M6To8uBGX5pVtnbA5Ib37yJm5DoYSP+D4xvsrAIXKA+U/7Ro/aD4fIl9c1k+P
         7/9Vgh2fgIsLlQ0UCQcb19iRZ3VbAPyarcaT5+Z8=
Date:   Sat, 08 Jul 2023 17:55:28 -0700
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
Subject: + mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch added to mm-unstable branch
Message-Id: <20230709005529.62B08C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: document and enable new UFFDIO_POISON feature
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch

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
Subject: mm: userfaultfd: document and enable new UFFDIO_POISON feature
Date: Fri, 7 Jul 2023 14:55:38 -0700

Update the userfaultfd API to advertise this feature as part of feature
flags and supported ioctls (returned upon registration).

Add basic documentation describing the new feature.

Link: https://lkml.kernel.org/r/20230707215540.2324998-7-axelrasmussen@google.com
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

 Documentation/admin-guide/mm/userfaultfd.rst |   15 +++++++++++++++
 include/uapi/linux/userfaultfd.h             |    9 ++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~mm-userfaultfd-document-and-enable-new-uffdio_poison-feature
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -244,6 +244,21 @@ write-protected (so future writes will a
 support a mode flag (``UFFDIO_COPY_MODE_WP`` or ``UFFDIO_CONTINUE_MODE_WP``
 respectively) to configure the mapping this way.
 
+Memory Poisioning Emulation
+---------------------------
+
+In response to a fault (either missing or minor), an action userspace can
+take to "resolve" it is to issue a ``UFFDIO_POISON``. This will cause any
+future faulters to either get a SIGBUS, or in KVM's case the guest will
+receive an MCE as if there were hardware memory poisoning.
+
+This is used to emulate hardware memory poisoning. Imagine a VM running on a
+machine which experiences a real hardware memory error. Later, we live migrate
+the VM to another physical machine. Since we want the migration to be
+transparent to the guest, we want that same address range to act as if it was
+still poisoned, even though it's on a new physical host which ostensibly
+doesn't have a memory error in the exact same spot.
+
 QEMU/KVM
 ========
 
--- a/include/uapi/linux/userfaultfd.h~mm-userfaultfd-document-and-enable-new-uffdio_poison-feature
+++ a/include/uapi/linux/userfaultfd.h
@@ -39,7 +39,8 @@
 			   UFFD_FEATURE_MINOR_SHMEM |		\
 			   UFFD_FEATURE_EXACT_ADDRESS |		\
 			   UFFD_FEATURE_WP_HUGETLBFS_SHMEM |	\
-			   UFFD_FEATURE_WP_UNPOPULATED)
+			   UFFD_FEATURE_WP_UNPOPULATED |	\
+			   UFFD_FEATURE_POISON)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -49,12 +50,14 @@
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_ZEROPAGE |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
-	 (__u64)1 << _UFFDIO_CONTINUE)
+	 (__u64)1 << _UFFDIO_CONTINUE |		\
+	 (__u64)1 << _UFFDIO_POISON)
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
+	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_WRITEPROTECT)
+	 (__u64)1 << _UFFDIO_POISON)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
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

