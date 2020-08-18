Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C76C433E5
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277112080C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790422;
	bh=IstXMQOfVFWSt3bpXhY5XyPAqBh4cm4kvTDTNxrW0Dw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DF7SPwKyPm1d2PGpaTYwfeJvmIKRp6U1jPyww5DmjgSSXNNjdpnRLvMdssIi9jVV5
	 sneOA9w0peDOQjW2A7k1T5VFN/smRI0Tq0knAme8XeEPD5f9gG51iPNfI+BEq2acth
	 kefrrtY/yroDDw8j5+GVXj5l9dvRcfar5+5mSpNc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgHRWkV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgHRWkS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7032F207DA;
        Tue, 18 Aug 2020 22:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790417;
        bh=IstXMQOfVFWSt3bpXhY5XyPAqBh4cm4kvTDTNxrW0Dw=;
        h=Date:From:To:Subject:From;
        b=QQVvaee1INhHlBBVHGWq3VQ36TYuJt6jQRWSudZ8oMfEHNVkWOmJIsISmaN5z04nP
         rAw9xS2Fny5b8Y3HLfDnfYvXFFeBWTKhwa7p96I1f1lySqeA0ddJBmA9r1MkG9axQG
         zINm+8L6AVCnogUIXxDGQjMhhrMpbYVQUHbG6dLM=
Date:   Tue, 18 Aug 2020 15:40:17 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, maz@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged] selftests-exec-add-file-type-errno-tests.patch
 removed from -mm tree
Message-ID: <20200818224017.PJ_gy65A1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/exec: add file type errno tests
has been removed from the -mm tree.  Its filename was
     selftests-exec-add-file-type-errno-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: selftests/exec: add file type errno tests

Make sure execve() returns the expected errno values for non-regular
files.

Link: http://lkml.kernel.org/r/20200813231723.2725102-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/exec/.gitignore    |    1 
 tools/testing/selftests/exec/Makefile      |    5 
 tools/testing/selftests/exec/non-regular.c |  196 +++++++++++++++++++
 3 files changed, 200 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/exec/.gitignore~selftests-exec-add-file-type-errno-tests
+++ a/tools/testing/selftests/exec/.gitignore
@@ -10,3 +10,4 @@ execveat.denatured
 /recursion-depth
 xxxxxxxx*
 pipe
+S_I*.test
--- a/tools/testing/selftests/exec/Makefile~selftests-exec-add-file-type-errno-tests
+++ a/tools/testing/selftests/exec/Makefile
@@ -3,7 +3,7 @@ CFLAGS = -Wall
 CFLAGS += -Wno-nonnull
 CFLAGS += -D_GNU_SOURCE
 
-TEST_PROGS := binfmt_script
+TEST_PROGS := binfmt_script non-regular
 TEST_GEN_PROGS := execveat
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir pipe
 # Makefile is a run-time dependency, since it's accessed by the execveat test
@@ -11,7 +11,8 @@ TEST_FILES := Makefile
 
 TEST_GEN_PROGS += recursion-depth
 
-EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*
+EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\
+	       $(OUTPUT)/S_I*.test
 
 include ../lib.mk
 
--- /dev/null
+++ a/tools/testing/selftests/exec/non-regular.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <sys/types.h>
+
+#include "../kselftest_harness.h"
+
+/* Remove a file, ignoring the result if it didn't exist. */
+void rm(struct __test_metadata *_metadata, const char *pathname,
+	int is_dir)
+{
+	int rc;
+
+	if (is_dir)
+		rc = rmdir(pathname);
+	else
+		rc = unlink(pathname);
+
+	if (rc < 0) {
+		ASSERT_EQ(errno, ENOENT) {
+			TH_LOG("Not ENOENT: %s", pathname);
+		}
+	} else {
+		ASSERT_EQ(rc, 0) {
+			TH_LOG("Failed to remove: %s", pathname);
+		}
+	}
+}
+
+FIXTURE(file) {
+	char *pathname;
+	int is_dir;
+};
+
+FIXTURE_VARIANT(file)
+{
+	const char *name;
+	int expected;
+	int is_dir;
+	void (*setup)(struct __test_metadata *_metadata,
+		      FIXTURE_DATA(file) *self,
+		      const FIXTURE_VARIANT(file) *variant);
+	int major, minor, mode; /* for mknod() */
+};
+
+void setup_link(struct __test_metadata *_metadata,
+		FIXTURE_DATA(file) *self,
+		const FIXTURE_VARIANT(file) *variant)
+{
+	const char * const paths[] = {
+		"/bin/true",
+		"/usr/bin/true",
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(paths); i++) {
+		if (access(paths[i], X_OK) == 0) {
+			ASSERT_EQ(symlink(paths[i], self->pathname), 0);
+			return;
+		}
+	}
+	ASSERT_EQ(1, 0) {
+		TH_LOG("Could not find viable 'true' binary");
+	}
+}
+
+FIXTURE_VARIANT_ADD(file, S_IFLNK)
+{
+	.name = "S_IFLNK",
+	.expected = ELOOP,
+	.setup = setup_link,
+};
+
+void setup_dir(struct __test_metadata *_metadata,
+	       FIXTURE_DATA(file) *self,
+	       const FIXTURE_VARIANT(file) *variant)
+{
+	ASSERT_EQ(mkdir(self->pathname, 0755), 0);
+}
+
+FIXTURE_VARIANT_ADD(file, S_IFDIR)
+{
+	.name = "S_IFDIR",
+	.is_dir = 1,
+	.expected = EACCES,
+	.setup = setup_dir,
+};
+
+void setup_node(struct __test_metadata *_metadata,
+		FIXTURE_DATA(file) *self,
+		const FIXTURE_VARIANT(file) *variant)
+{
+	dev_t dev;
+	int rc;
+
+	dev = makedev(variant->major, variant->minor);
+	rc = mknod(self->pathname, 0755 | variant->mode, dev);
+	ASSERT_EQ(rc, 0) {
+		if (errno == EPERM)
+			SKIP(return, "Please run as root; cannot mknod(%s)",
+				variant->name);
+	}
+}
+
+FIXTURE_VARIANT_ADD(file, S_IFBLK)
+{
+	.name = "S_IFBLK",
+	.expected = EACCES,
+	.setup = setup_node,
+	/* /dev/loop0 */
+	.major = 7,
+	.minor = 0,
+	.mode = S_IFBLK,
+};
+
+FIXTURE_VARIANT_ADD(file, S_IFCHR)
+{
+	.name = "S_IFCHR",
+	.expected = EACCES,
+	.setup = setup_node,
+	/* /dev/zero */
+	.major = 1,
+	.minor = 5,
+	.mode = S_IFCHR,
+};
+
+void setup_fifo(struct __test_metadata *_metadata,
+		FIXTURE_DATA(file) *self,
+		const FIXTURE_VARIANT(file) *variant)
+{
+	ASSERT_EQ(mkfifo(self->pathname, 0755), 0);
+}
+
+FIXTURE_VARIANT_ADD(file, S_IFIFO)
+{
+	.name = "S_IFIFO",
+	.expected = EACCES,
+	.setup = setup_fifo,
+};
+
+FIXTURE_SETUP(file)
+{
+	ASSERT_GT(asprintf(&self->pathname, "%s.test", variant->name), 6);
+	self->is_dir = variant->is_dir;
+
+	rm(_metadata, self->pathname, variant->is_dir);
+	variant->setup(_metadata, self, variant);
+}
+
+FIXTURE_TEARDOWN(file)
+{
+	rm(_metadata, self->pathname, self->is_dir);
+}
+
+TEST_F(file, exec_errno)
+{
+	char * const argv[2] = { (char * const)self->pathname, NULL };
+
+	EXPECT_LT(execv(argv[0], argv), 0);
+	EXPECT_EQ(errno, variant->expected);
+}
+
+/* S_IFSOCK */
+FIXTURE(sock)
+{
+	int fd;
+};
+
+FIXTURE_SETUP(sock)
+{
+	self->fd = socket(AF_INET, SOCK_STREAM, 0);
+	ASSERT_GE(self->fd, 0);
+}
+
+FIXTURE_TEARDOWN(sock)
+{
+	if (self->fd >= 0)
+		ASSERT_EQ(close(self->fd), 0);
+}
+
+TEST_F(sock, exec_errno)
+{
+	char * const argv[2] = { " magic socket ", NULL };
+	char * const envp[1] = { NULL };
+
+	EXPECT_LT(fexecve(self->fd, argv, envp), 0);
+	EXPECT_EQ(errno, EACCES);
+}
+
+TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from keescook@chromium.org are


