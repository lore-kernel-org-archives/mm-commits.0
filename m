Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AC5C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B89E6613FA
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhEIELJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhEIELI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B6BD6135F;
        Sun,  9 May 2021 04:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533405;
        bh=ezqL7q/QICYtPh/JEVWScoLK3XQ8ETZtzpUsDQCfkR0=;
        h=Date:From:To:Subject:From;
        b=VBPS7xdBeYmFaFbkoKMwhLkR8XvLZwChgLzIjbzMwcnb6pmT0bdUMwKnczBIZmkdo
         mXADLR6qm4dlaixMP0Sq9qyuk1P0144c6fMajc7pqoXQnl3DqRyJw7i2U9Ws6pr3Xa
         NHTzp3Kp9PyLd/BIFkUcsPGYg5BfhUbQnp+smYgs=
Date:   Sat, 08 May 2021 21:10:04 -0700
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
 userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch added to -mm
 tree
Message-ID: <20210509041004.45MUpSqVX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: only dump counts if mode enabled
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch

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
Subject: userfaultfd/selftests: only dump counts if mode enabled

WP and MINOR modes are conditionally enabled on specific memory types. 
This patch avoids dumping tons of zeros for those cases when the modes are
not supported at all.

Link: https://lkml.kernel.org/r/20210412232753.1012412-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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

 tools/testing/selftests/vm/userfaultfd.c |   30 ++++++++++++++-------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-only-dump-counts-if-mode-enabled
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -171,16 +171,26 @@ static void uffd_stats_report(struct uff
 		minor_total += stats[i].minor_faults;
 	}
 
-	printf("userfaults: %llu missing (", miss_total);
-	for (i = 0; i < n_cpus; i++)
-		printf("%lu+", stats[i].missing_faults);
-	printf("\b), %llu wp (", wp_total);
-	for (i = 0; i < n_cpus; i++)
-		printf("%lu+", stats[i].wp_faults);
-	printf("\b), %llu minor (", minor_total);
-	for (i = 0; i < n_cpus; i++)
-		printf("%lu+", stats[i].minor_faults);
-	printf("\b)\n");
+	printf("userfaults: ");
+	if (miss_total) {
+		printf("%llu missing (", miss_total);
+		for (i = 0; i < n_cpus; i++)
+			printf("%lu+", stats[i].missing_faults);
+		printf("\b) ");
+	}
+	if (wp_total) {
+		printf("%llu wp (", wp_total);
+		for (i = 0; i < n_cpus; i++)
+			printf("%lu+", stats[i].wp_faults);
+		printf("\b) ");
+	}
+	if (minor_total) {
+		printf("%llu minor (", minor_total);
+		for (i = 0; i < n_cpus; i++)
+			printf("%lu+", stats[i].minor_faults);
+		printf("\b)");
+	}
+	printf("\n");
 }
 
 static int anon_release_pages(char *rel_area)
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

