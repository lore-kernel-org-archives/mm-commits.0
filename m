Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79492C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6189361090
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbhGABvM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABvL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E89A61468;
        Thu,  1 Jul 2021 01:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104122;
        bh=T//CElXVE7xBFxBiOkfV6NqZ/Uq66JZRJynSpcZPrWg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GRh3Y7umnWDBY8ssFfANHqhlKyzcH6/pIH7N8Nhl2nQL+o/xDHXAJscWv05yP6zIP
         NF1vQxhMuaRNVXgcaEU6J/3z4YrgJhciEyxIhzT633cFvcCrUno9neLxObVgKa8VG5
         Wltlqbe0cusl1dhMxKcBxsjq8yp2jP20p+sA+HOw=
Date:   Wed, 30 Jun 2021 18:48:41 -0700
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
Subject:  [patch 030/192] userfaultfd/selftests: use user mode only
Message-ID: <20210701014841.w-4MhufHn%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: use user mode only

Patch series "userfaultfd/selftests: A few cleanups", v2.

I wanted to cleanup userfaultfd.c fault handling for a long time.  If it's
not cleaned, when the new code grows the file it'll also grow the size
that needs to be cleaned...  This is my attempt to cleanup the userfaultfd
selftest on fault handling, to use an err() macro instead of either
fprintf() or perror() then another exit() call.

The huge cleanup is done in the last patch.  The first 4 patches are some
other standalone cleanups for the same file, so I put them together.


This patch (of 5):

Userfaultfd selftest does not need to handle kernel initiated fault.  Set
user mode so it can be run even if unprivileged_userfaultfd=0 (which is
the default).

Link: https://lkml.kernel.org/r/20210412232753.1012412-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-use-user-mode-only
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -831,7 +831,7 @@ static int userfaultfd_open_ext(uint64_t
 {
 	struct uffdio_api uffdio_api;
 
-	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
 	if (uffd < 0) {
 		fprintf(stderr,
 			"userfaultfd syscall not available in this kernel\n");
_
