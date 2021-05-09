Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C4FC433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D83766142B
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhEIELY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhEIELY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BE1C61401;
        Sun,  9 May 2021 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533421;
        bh=xiReAWTpzq/LuIBv7K6NSGzh1A/WekGAb5bFbCr0wZI=;
        h=Date:From:To:Subject:From;
        b=ISMX8kAP/uI7fURGZ/D5J0TXp3Onpej+opekAiegMdGZwW9bV/32qpGIp9k3p7Sjw
         PjjRDn0MHR3kET8ZbO3zOWk54+gSMEI3DWn61V9trAOa1dw72Nc7cwGGIc6qy6QJbR
         Gj+8xJvmPO6vSprCcvidSrW0TYofiJaTFP8Z3TjM=
Date:   Sat, 08 May 2021 21:10:20 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  +
 mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch added to
 -mm tree
Message-ID: <20210509041020.3ZKk-6nZp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: fail uffd-wp registeration if not supported
has been added to the -mm tree.  Its filename is
     mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: fail uffd-wp registeration if not supported

We should fail uffd-wp registration immediately if the arch does not even
have CONFIG_HAVE_ARCH_USERFAULTFD_WP defined.  That'll block also relevant
ioctls on e.g.  UFFDIO_WRITEPROTECT because that'll check against
VM_UFFD_WP, which can only be applied with a success registration.

Remove the WP feature bit too for those archs when handling UFFDIO_API
ioctl.

Link: https://lkml.kernel.org/r/20210428225030.9708-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported
+++ a/fs/userfaultfd.c
@@ -1304,8 +1304,12 @@ static int userfaultfd_register(struct u
 	vm_flags = 0;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
 		vm_flags |= VM_UFFD_MISSING;
-	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP)
+	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
+#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+		goto out;
+#endif
 		vm_flags |= VM_UFFD_WP;
+	}
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR) {
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 		goto out;
@@ -1943,6 +1947,9 @@ static int userfaultfd_api(struct userfa
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 	uffdio_api.features &= ~UFFD_FEATURE_MINOR_HUGETLBFS;
 #endif
+#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+	uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+#endif
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch
mm-gup_benchmark-support-threading.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch
mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch
mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
mm-pagemap-export-uffd-wp-protection-information.patch
userfaultfd-selftests-add-pagemap-uffd-wp-test.patch

