Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5814CA4A
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AdnJSIzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9AFC433F1;
	Wed, 10 Jan 2024 05:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704863739;
	bh=pv+2xXI0vdnj58xGuHOUADzlYjPwkkU1Mhjj87nDF0Y=;
	h=Date:To:From:Subject:From;
	b=AdnJSIzEyzEPJj3T8t5DIOIOOq49E6oEgN2QNSgsyxRdU/X+0V9CAJoFToYiJbH07
	 0okB7hfK83yeRWjSsM+t6W2MGBlodBdh4U5g7+CbSRKfdpjcPrdm8vmnqEbSvRv6Nz
	 zIFkLJQXys8QxhcDUeJ3loui+SAl6rF+euoDRpN4=
Date: Tue, 09 Jan 2024 21:15:38 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,rostedt@goodmis.org,pengfei.xu@intel.com,mszeredi@redhat.com,mathieu.desnoyers@efficios.com,javierm@redhat.com,brauner@kernel.org,avagin@google.com,wenyang.linux@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-add-eventfd-selftests.patch added to mm-nonmm-unstable branch
Message-Id: <20240110051539.4A9AFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: add eventfd selftests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-add-eventfd-selftests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-add-eventfd-selftests.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wen Yang <wenyang.linux@foxmail.com>
Subject: selftests: add eventfd selftests
Date: Mon, 8 Jan 2024 23:51:32 +0800

This adds the promised selftest for eventfd.  It will verify the flags of
eventfd2, including EFD_CLOEXEC, EFD_NONBLOCK and EFD_SEMAPHORE.

Link: https://lkml.kernel.org/r/tencent_3C9A298878D22B5D8F79DC2FEE99BB4A8F05@qq.com
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Pengfei Xu <pengfei.xu@intel.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/eventfd/.gitignore     |    2 
 tools/testing/selftests/filesystems/eventfd/Makefile       |    7 
 tools/testing/selftests/filesystems/eventfd/eventfd_test.c |  186 ++++++++++
 3 files changed, 195 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/filesystems/eventfd/eventfd_test.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <asm/unistd.h>
+#include <linux/time_types.h>
+#include <unistd.h>
+#include <assert.h>
+#include <signal.h>
+#include <pthread.h>
+#include <sys/epoll.h>
+#include <sys/eventfd.h>
+#include "../../kselftest_harness.h"
+
+struct error {
+	int  code;
+	char msg[512];
+};
+
+static int error_set(struct error *err, int code, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	if (code == 0 || !err || err->code != 0)
+		return code;
+
+	err->code = code;
+	va_start(args, fmt);
+	r = vsnprintf(err->msg, sizeof(err->msg), fmt, args);
+	assert((size_t)r < sizeof(err->msg));
+	va_end(args);
+
+	return code;
+}
+
+static inline int sys_eventfd2(unsigned int count, int flags)
+{
+	return syscall(__NR_eventfd2, count, flags);
+}
+
+TEST(eventfd01)
+{
+	int fd, flags;
+
+	fd = sys_eventfd2(0, 0);
+	ASSERT_GE(fd, 0);
+
+	flags = fcntl(fd, F_GETFL);
+	// since the kernel automatically added O_RDWR.
+	EXPECT_EQ(flags, O_RDWR);
+
+	close(fd);
+}
+
+TEST(eventfd02)
+{
+	int fd, flags;
+
+	fd = sys_eventfd2(0, EFD_CLOEXEC);
+	ASSERT_GE(fd, 0);
+
+	flags = fcntl(fd, F_GETFD);
+	ASSERT_GT(flags, -1);
+	EXPECT_EQ(flags, FD_CLOEXEC);
+
+	close(fd);
+}
+
+TEST(eventfd03)
+{
+	int fd, flags;
+
+	fd = sys_eventfd2(0, EFD_NONBLOCK);
+	ASSERT_GE(fd, 0);
+
+	flags = fcntl(fd, F_GETFL);
+	ASSERT_GT(flags, -1);
+	EXPECT_EQ(flags & EFD_NONBLOCK, EFD_NONBLOCK);
+	EXPECT_EQ(flags & O_RDWR, O_RDWR);
+
+	close(fd);
+}
+
+TEST(eventfd04)
+{
+	int fd, flags;
+
+	fd = sys_eventfd2(0, EFD_CLOEXEC|EFD_NONBLOCK);
+	ASSERT_GE(fd, 0);
+
+	flags = fcntl(fd, F_GETFL);
+	ASSERT_GT(flags, -1);
+	EXPECT_EQ(flags & EFD_NONBLOCK, EFD_NONBLOCK);
+	EXPECT_EQ(flags & O_RDWR, O_RDWR);
+
+	flags = fcntl(fd, F_GETFD);
+	ASSERT_GT(flags, -1);
+	EXPECT_EQ(flags, FD_CLOEXEC);
+
+	close(fd);
+}
+
+static inline void trim_newline(char *str)
+{
+	char *pos = strrchr(str, '\n');
+
+	if (pos)
+		*pos = '\0';
+}
+
+static int verify_fdinfo(int fd, struct error *err, const char *prefix,
+		size_t prefix_len, const char *expect, ...)
+{
+	char buffer[512] = {0, };
+	char path[512] = {0, };
+	va_list args;
+	FILE *f;
+	char *line = NULL;
+	size_t n = 0;
+	int found = 0;
+	int r;
+
+	va_start(args, expect);
+	r = vsnprintf(buffer, sizeof(buffer), expect, args);
+	assert((size_t)r < sizeof(buffer));
+	va_end(args);
+
+	snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", fd);
+	f = fopen(path, "re");
+	if (!f)
+		return error_set(err, -1, "fdinfo open failed for %d", fd);
+
+	while (getline(&line, &n, f) != -1) {
+		char *val;
+
+		if (strncmp(line, prefix, prefix_len))
+			continue;
+
+		found = 1;
+
+		val = line + prefix_len;
+		r = strcmp(val, buffer);
+		if (r != 0) {
+			trim_newline(line);
+			trim_newline(buffer);
+			error_set(err, -1, "%s '%s' != '%s'",
+				  prefix, val, buffer);
+		}
+		break;
+	}
+
+	free(line);
+	fclose(f);
+
+	if (found == 0)
+		return error_set(err, -1, "%s not found for fd %d",
+				 prefix, fd);
+
+	return 0;
+}
+
+TEST(eventfd05)
+{
+	struct error err = {0};
+	int fd, ret;
+
+	fd = sys_eventfd2(0, EFD_SEMAPHORE);
+	ASSERT_GE(fd, 0);
+
+	ret = fcntl(fd, F_GETFL);
+	ASSERT_GT(ret, -1);
+	EXPECT_EQ(ret & O_RDWR, O_RDWR);
+
+	// The semaphore could only be obtained from fdinfo.
+	ret = verify_fdinfo(fd, &err, "eventfd-semaphore: ", 19, "1\n");
+	if (ret != 0)
+		ksft_print_msg("eventfd-semaphore check failed, msg: %s\n",
+				err.msg);
+	EXPECT_EQ(ret, 0);
+
+	close(fd);
+}
+
+TEST_HARNESS_MAIN
--- /dev/null
+++ a/tools/testing/selftests/filesystems/eventfd/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+eventfd_test
--- /dev/null
+++ a/tools/testing/selftests/filesystems/eventfd/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+CFLAGS += $(KHDR_INCLUDES)
+LDLIBS += -lpthread
+TEST_GEN_PROGS := eventfd_test
+
+include ../../lib.mk
_

Patches currently in -mm which might be from wenyang.linux@foxmail.com are

selftests-add-eventfd-selftests.patch

