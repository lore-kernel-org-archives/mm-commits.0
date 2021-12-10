Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33426C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344906AbhLJWul (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57278 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344904AbhLJWuf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89297CE2D92
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCBAC341CC;
        Fri, 10 Dec 2021 22:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176416;
        bh=mD4CIeQP3OlEtgt+GGwrORFtaN/76MVbatN9fnivMKM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FZugMRl9e8qdHTEh6XBtyUtzDNNu/V2wX8yNUgiCsBCbR06el7rHelleBuCpgrY1F
         dT5m3GFOZg0MIEjejLxJeT2/amrVUHDFfPbCgB5535nbe1KzNPCXRy9w/+/PUqieMw
         h2379gpnB9AHZzg4J1ps/LZ+YLv3ODpfLEdSM5r4=
Date:   Fri, 10 Dec 2021 14:46:55 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 16/21] selftests/damon: test debugfs file
 reads/writes with huge count
Message-ID: <20211210224655.R3LHIU89Z%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: test debugfs file reads/writes with huge count

DAMON debugfs interface users were able to trigger warning by writing some
files with arbitrarily large 'count' parameter.  The issue is fixed with
commit db7a347b26fe ("mm/damon/dbgfs: use '__GFP_NOWARN' for
user-specified size buffer allocation").  This commit adds a test case for
the issue in DAMON selftests to avoid future regressions.

Link: https://lkml.kernel.org/r/20211201150440.1088-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore              |    2 
 tools/testing/selftests/damon/Makefile                |    2 
 tools/testing/selftests/damon/debugfs_attrs.sh        |   18 ++++
 tools/testing/selftests/damon/huge_count_read_write.c |   39 ++++++++++
 4 files changed, 61 insertions(+)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-test-debugfs-file-reads-writes-with-huge-count
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -105,4 +105,22 @@ orig_monitor_on=$(cat "$DBGFS/monitor_on
 test_write_fail "$DBGFS/monitor_on" "on" "orig_monitor_on" "empty target ids"
 echo "$orig_target_ids" > "$DBGFS/target_ids"
 
+# Test huge count read write
+# ==========================
+
+dmesg -C
+
+for file in "$DBGFS/"*
+do
+	./huge_count_read_write "$file"
+done
+
+if dmesg | grep -q WARNING
+then
+	dmesg
+	exit 1
+else
+	exit 0
+fi
+
 echo "PASS"
--- /dev/null
+++ a/tools/testing/selftests/damon/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+huge_count_read_write
--- /dev/null
+++ a/tools/testing/selftests/damon/huge_count_read_write.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+
+void write_read_with_huge_count(char *file)
+{
+	int filedesc = open(file, O_RDWR);
+	char buf[25];
+	int ret;
+
+	printf("%s %s\n", __func__, file);
+	if (filedesc < 0) {
+		fprintf(stderr, "failed opening %s\n", file);
+		exit(1);
+	}
+
+	write(filedesc, "", 0xfffffffful);
+	perror("after write: ");
+	ret = read(filedesc, buf, 0xfffffffful);
+	perror("after read: ");
+	close(filedesc);
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <file>\n", argv[0]);
+		exit(1);
+	}
+	write_read_with_huge_count(argv[1]);
+
+	return 0;
+}
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-test-debugfs-file-reads-writes-with-huge-count
+++ a/tools/testing/selftests/damon/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for damon selftests
 
+TEST_GEN_FILES += huge_count_read_write
+
 TEST_FILES = _chk_dependency.sh
 TEST_PROGS = debugfs_attrs.sh
 
_
