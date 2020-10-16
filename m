Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE8BC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E802B20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816577;
	bh=WY9umP2X8xAtIKuZSClRbMG3KoynN6JyJGKq77fSARs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=pADXJS3dYEGGR17dQPixgbrvgZDH9L0vCFYNijDizXPXF1kdbV2hGl9pp5XgAXDKN
	 VMMhhoVyeYNarmYTWhzDbsxu9ViGMZcZHd2etuHjEAlvsZFT+r4lr2HEUeSklcl76t
	 RhZ4Zp9sbUxB/P6rhaE6Hbo1NkLKXGma+JYqfZBE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404341AbgJPCtg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404384AbgJPCtd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:49:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEC6C208C7;
        Fri, 16 Oct 2020 02:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816572;
        bh=WY9umP2X8xAtIKuZSClRbMG3KoynN6JyJGKq77fSARs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qzXxwrPyh1JtBC0jXOJoK13oN3yTY+nyi2U06nzlPVWGDnmsYjp3afrkOu+Io5STf
         sisDpAAfqVLvSzbEI7E8AbVUd3Ol0xMteyl2kbSSOoDg5XYzDLApIl3geG2GA+lV7L
         Jz5sw7GaiuKzlKds/4ZdQxIb3liZ4TDtY3CCxeB8=
Date:   Thu, 15 Oct 2020 19:49:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        ckennelly@google.com, hughd@google.com, irogers@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        maskray@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        rientjes@google.com, shuah@kernel.org, songliubraving@fb.com,
        sspatil@google.com, surenb@google.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 135/156] tools/testing/selftests: add self-test
 for verifying load alignment
Message-ID: <20201016024930.dbP1l-soX%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chris Kennelly <ckennelly@google.com>
Subject: tools/testing/selftests: add self-test for verifying load alignment

This produces a PIE binary with a variety of p_align requirements,
suitable for verifying that the load address meets that alignment
requirement.

Link: https://lkml.kernel.org/r/20200820170541.1132271-3-ckennelly@google.com
Link: https://lkml.kernel.org/r/20200821233848.3904680-3-ckennelly@google.com
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
