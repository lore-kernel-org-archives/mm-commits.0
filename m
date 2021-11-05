Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BB4C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E799861216
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhKESoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhKESoi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:44:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A576761186;
        Fri,  5 Nov 2021 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137718;
        bh=fUsLVj50xiZCrHjm4TMSE/ffD2BofHlCEECgIUZXRf8=;
        h=Date:From:To:Subject:From;
        b=lInp896EAWmvHNeywaTD6aoG7Pshs8A5El9LjiAFhqYCWIaKhx5tN0F0ePwL3yMYC
         6q/CU883b32uquWRQ26uJRs91J2jHZwmVhwEZ1ry3lrC6gsHRJV97i8ZIJCWYOHoBu
         GErW3ZogfIZCHg2C2tE20l3KDmTwTHUjd/tMxDxU=
Date:   Fri, 05 Nov 2021 11:41:58 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, mm-commits@vger.kernel.org,
        wanjiabing@vivo.com
Subject:  [folded-merged]
 mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix.patch removed from -mm tree
Message-ID: <20211105184158.1zKTzqmTc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: remove duplicated include in hugepage-mremap
has been removed from the -mm tree.  Its filename was
     mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix.patch

This patch was dropped because it was folded into mm-hugepages-add-hugetlb-vma-mremap-test.patch

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: selftests: vm: remove duplicated include in hugepage-mremap

Fix following checkinclude.pl warning:
./tools/testing/selftests/vm/hugepage-mremap.c: fcntl.h is included
more than once.

Link: https://lkml.kernel.org/r/20211021122944.8857-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -12,7 +12,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
-#include <fcntl.h>
 #include <errno.h>
 #include <fcntl.h> /* Definition of O_* constants */
 #include <sys/syscall.h> /* Definition of SYS_* constants */
_

Patches currently in -mm which might be from wanjiabing@vivo.com are

mm-hugepages-add-hugetlb-vma-mremap-test.patch

