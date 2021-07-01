Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2A2C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11B726146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbhGABvX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABvX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E9066120C;
        Thu,  1 Jul 2021 01:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104133;
        bh=HRL8VpJjpH2u4FSHjGZdMu7W0aM7i2zTf2sdnsmrkcs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MDoGtfY/oaCp/PaGRzUUk4DfhJWBfMDGppD1Ji27maKXOoMCFmgwBNqGhTfpjaEaR
         MDGgcVFw8qQsUiNF8oO41GM/5LARD5aq/Xhj8qexcZM1Gh/MEmiVXXQDIwNZAg77qC
         6wQNsfCgKlB/Bz6239H4swpyRZcMOD9ZOiEhY+qk=
Date:   Wed, 30 Jun 2021 18:48:52 -0700
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
Subject:  [patch 033/192] userfaultfd/selftests: only dump counts
 if mode enabled
Message-ID: <20210701014852.RuvkWyfWK%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
