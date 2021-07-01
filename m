Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85927C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7004B61468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238400AbhGABvh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABvh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:51:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A4E61469;
        Thu,  1 Jul 2021 01:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104147;
        bh=zdOaIlOLdN22SKbBP9VrmQ4d6AMoLYE4qirfKewrXKc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Heowlqhpeb8YspTqqkVik2xtlG3jAr1W1DMbr2FeCAkITy3ypMv7+PAtBDPYs7OYQ
         b6wk2DifsuSMGhWvct+5uRPYwd0p1QB1ZsdY/pEiGZy1WKkjB6wCW8j6ipcfNvPJuk
         tonQMa/TmkQkdKYPoVXzQLX8i/RGCkkcfvPe7GBY=
Date:   Wed, 30 Jun 2021 18:49:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        almasrymina@google.com, axelrasmussen@google.com,
        bgeffon@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, kirill@shutemov.name,
        linux-mm@kvack.org, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        wangqing@vivo.com
Subject:  [patch 037/192] mm/userfaultfd: fail uffd-wp registration
 if not supported
Message-ID: <20210701014906.8qOxw6Ozk%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: fail uffd-wp registration if not supported

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
