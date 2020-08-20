Return-Path: <SRS0=nxWc=B6=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99743C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 20:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD6B208C7
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 20:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597954080;
	bh=pgw701eTCYM/pI1ICqjBTWDkTetWqOUnvGytHebNI7k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KN/VjHV4hkoP2WgKT41FYLWzElRA+jeQK6WJiNbH2dQ1gCshsmrB8bNx/SMMTGTag
	 vpLBW2pSrSW4tJt/kFp5mYlg6PpaGuZaWNQUH+Shsto6IIkTbxXincqljfa0w5e+uf
	 JbaCY3slZcrDM/sJ+SmBfiwl7YTHBQkqNUlQNnGo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgHTUH7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 16:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbgHTUH5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 16:07:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09E6E207DF;
        Thu, 20 Aug 2020 20:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597954076;
        bh=pgw701eTCYM/pI1ICqjBTWDkTetWqOUnvGytHebNI7k=;
        h=Date:From:To:Subject:From;
        b=cXeV3RcqjC6n6ZWA8vB1988Yj+x/8EUIs0fZ1In2UBMZE2Xaa9j/D8YoFsLkH/du4
         XDUmQuWAjvlmDGxhVhqkzMgM6C7NYySO0eYCW9JO7Zv5B85WLTyM9cX9cIBNt2E7Qj
         Br5EKZwkQAdKKQ+Co2xoq1V24QkegtAiaJj6RbrQ=
Date:   Thu, 20 Aug 2020 13:07:55 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, ckennelly@google.com, hughd@google.com,
        irogers@google.com, kirill.shutemov@linux.intel.com,
        maskray@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        rientjes@google.com, shuah@kernel.org, songliubraving@fb.com,
        sspatil@google.com, surenb@google.com, viro@zeniv.linux.org.uk
Subject:  + add-self-test-for-verifying-load-alignment.patch added
 to -mm tree
Message-ID: <20200820200755.qpcTpxWke%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests: add self-test for verifying load alignment
has been added to the -mm tree.  Its filename is
     add-self-test-for-verifying-load-alignment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/add-self-test-for-verifying-load-alignment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/add-self-test-for-verifying-load-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Kennelly <ckennelly@google.com>
Subject: tools/testing/selftests: add self-test for verifying load alignment

This produces a PIE binary with a variety of p_align requirements,
suitable for verifying that the load address meets that alignment
requirement.

Link: https://lkml.kernel.org/r/20200820170541.1132271-3-ckennelly@google.com
Signed-off-by: Chris Kennelly <ckennelly@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/exec/.gitignore     |    1 
 tools/testing/selftests/exec/Makefile       |    9 +-
 tools/testing/selftests/exec/load_address.c |   68 ++++++++++++++++++
 3 files changed, 76 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/exec/.gitignore~add-self-test-for-verifying-load-alignment
+++ a/tools/testing/selftests/exec/.gitignore
@@ -7,6 +7,7 @@ execveat.moved
 execveat.path.ephemeral
 execveat.ephemeral
 execveat.denatured
+/load_address_*
 /recursion-depth
 xxxxxxxx*
 pipe
--- /dev/null
+++ a/tools/testing/selftests/exec/load_address.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <link.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+struct Statistics {
+	unsigned long long load_address;
+	unsigned long long alignment;
+};
+
+int ExtractStatistics(struct dl_phdr_info *info, size_t size, void *data)
+{
+	struct Statistics *stats = (struct Statistics *) data;
+	int i;
+
+	if (info->dlpi_name != NULL && info->dlpi_name[0] != '\0') {
+		// Ignore headers from other than the executable.
+		return 2;
+	}
+
+	stats->load_address = (unsigned long long) info->dlpi_addr;
+	stats->alignment = 0;
+
+	for (i = 0; i < info->dlpi_phnum; i++) {
+		if (info->dlpi_phdr[i].p_type != PT_LOAD)
+			continue;
+
+		if (info->dlpi_phdr[i].p_align > stats->alignment)
+			stats->alignment = info->dlpi_phdr[i].p_align;
+	}
+
+	return 1;  // Terminate dl_iterate_phdr.
+}
+
+int main(int argc, char **argv)
+{
+	struct Statistics extracted;
+	unsigned long long misalign;
+	int ret;
+
+	ret = dl_iterate_phdr(ExtractStatistics, &extracted);
+	if (ret != 1) {
+		fprintf(stderr, "FAILED\n");
+		return 1;
+	}
+
+	if (extracted.alignment == 0) {
+		fprintf(stderr, "No alignment found\n");
+		return 1;
+	} else if (extracted.alignment & (extracted.alignment - 1)) {
+		fprintf(stderr, "Alignment is not a power of 2\n");
+		return 1;
+	}
+
+	misalign = extracted.load_address & (extracted.alignment - 1);
+	if (misalign) {
+		printf("alignment = %llu, load_address = %llu\n",
+			extracted.alignment, extracted.load_address);
+		fprintf(stderr, "FAILED\n");
+		return 1;
+	}
+
+	fprintf(stderr, "PASS\n");
+	return 0;
+}
--- a/tools/testing/selftests/exec/Makefile~add-self-test-for-verifying-load-alignment
+++ a/tools/testing/selftests/exec/Makefile
@@ -4,7 +4,7 @@ CFLAGS += -Wno-nonnull
 CFLAGS += -D_GNU_SOURCE
 
 TEST_PROGS := binfmt_script non-regular
-TEST_GEN_PROGS := execveat
+TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir pipe
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
@@ -27,4 +27,9 @@ $(OUTPUT)/execveat.symlink: $(OUTPUT)/ex
 $(OUTPUT)/execveat.denatured: $(OUTPUT)/execveat
 	cp $< $@
 	chmod -x $@
-
+$(OUTPUT)/load_address_4096: load_address.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000 -pie $< -o $@
+$(OUTPUT)/load_address_2097152: load_address.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x200000 -pie $< -o $@
+$(OUTPUT)/load_address_16777216: load_address.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000000 -pie $< -o $@
_

Patches currently in -mm which might be from ckennelly@google.com are

fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch
add-self-test-for-verifying-load-alignment.patch

