Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730AF33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293211; cv=none; b=uTFsKnYQYh5JvUUFJtZhO1sfaRkvpHdEBPqdjD55xwA+A+5UlRj4iIGBzRClEufZ7Rew/fx0B29dDVjuFPepYZADrxoTjWHoWvf0wz8xbhby2UfgQSrQUjykdYFdghP3fpriwdNS71WuHRhmsXxamvDqzNX6ReHZlpIzu6TcqHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293211; c=relaxed/simple;
	bh=QU6lcAf9b1xiyfw0mlCU/8S8077fp12pj9/ff4SzcgE=;
	h=Date:To:From:Subject:Message-Id; b=fnxGWzgyA0h475JbhKn0yPir22FSJQHuI3qnOW3CIfwmbWXqlNp6qp1rk4WeFSeK53JzX8H3ZR+H8JstFcZq3AhR60r+O+JJPkXm3rfsgYqtCFpnMDtG5enXEG93xLPORc8KLAdXG+/VS4i/LXNhnUVDNFw4jOp/kLyNmys45zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EwiHcppe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EwiHcppe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48160C32782;
	Tue, 25 Jun 2024 05:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293211;
	bh=QU6lcAf9b1xiyfw0mlCU/8S8077fp12pj9/ff4SzcgE=;
	h=Date:To:From:Subject:From;
	b=EwiHcppe3rxW4Y3AwIWsed5HHuW346ZMMO8bfIqMvAPdITs5OYN6lgP3EnhkeuQ9L
	 tnZ3Larupqb70RckA/CbOl0ody2PW5S1cFbYSiudG8pvnsPyUWDnGJnM41urUTZTI/
	 KRuUuutma6+ULvc1qBLpSTjV+WDIrkWTStpDUQug=
Date: Mon, 24 Jun 2024 22:26:50 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,fullspring2018@gmail.com,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-test-kthread-field.patch removed from -mm tree
Message-Id: <20240625052651.48160C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: test "Kthread:" field
has been removed from the -mm tree.  Its filename was
     proc-test-kthread-field.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: test "Kthread:" field
Date: Fri, 7 Jun 2024 18:14:29 +0300

/proc/${pid}/status got Kthread field recently.

Test that userspace program is not reported as kernel thread.

Test that kernel thread is reported as kernel thread.
Use kthreadd with pid 2 for this.

Link: https://lkml.kernel.org/r/818c4c41-8668-4566-97a9-7254abf819ee@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chunguang Wu <fullspring2018@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/.gitignore               |    2 
 tools/testing/selftests/proc/Makefile                 |    2 
 tools/testing/selftests/proc/proc-2-is-kthread.c      |   53 ++++++++++
 tools/testing/selftests/proc/proc-self-isnt-kthread.c |   37 ++++++
 4 files changed, 94 insertions(+)

--- a/tools/testing/selftests/proc/.gitignore~proc-test-kthread-field
+++ a/tools/testing/selftests/proc/.gitignore
@@ -2,6 +2,7 @@
 /fd-001-lookup
 /fd-002-posix-eq
 /fd-003-kthread
+/proc-2-is-kthread
 /proc-fsconfig-hidepid
 /proc-loadavg-001
 /proc-multiple-procfs
@@ -9,6 +10,7 @@
 /proc-pid-vm
 /proc-self-map-files-001
 /proc-self-map-files-002
+/proc-self-isnt-kthread
 /proc-self-syscall
 /proc-self-wchan
 /proc-subset-pid
--- a/tools/testing/selftests/proc/Makefile~proc-test-kthread-field
+++ a/tools/testing/selftests/proc/Makefile
@@ -7,11 +7,13 @@ TEST_GEN_PROGS :=
 TEST_GEN_PROGS += fd-001-lookup
 TEST_GEN_PROGS += fd-002-posix-eq
 TEST_GEN_PROGS += fd-003-kthread
+TEST_GEN_PROGS += proc-2-is-kthread
 TEST_GEN_PROGS += proc-loadavg-001
 TEST_GEN_PROGS += proc-empty-vm
 TEST_GEN_PROGS += proc-pid-vm
 TEST_GEN_PROGS += proc-self-map-files-001
 TEST_GEN_PROGS += proc-self-map-files-002
+TEST_GEN_PROGS += proc-self-isnt-kthread
 TEST_GEN_PROGS += proc-self-syscall
 TEST_GEN_PROGS += proc-self-wchan
 TEST_GEN_PROGS += proc-subset-pid
--- /dev/null
+++ a/tools/testing/selftests/proc/proc-2-is-kthread.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2024 Alexey Dobriyan <adobriyan@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+/* Test that kernel thread is reported as such. */
+#undef NDEBUG
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+
+int main(void)
+{
+	/*
+	 * The following solutions don't really work:
+	 *
+	 * 1) jit kernel module which creates kernel thread:
+	 * test becomes arch-specific,
+	 * problems with mandatory module signing,
+	 * problems with lockdown mode,
+	 * doesn't work with CONFIG_MODULES=n at all,
+	 * kthread creation API is formally unstable internal kernel API,
+	 * need a mechanism to report test kernel thread's PID back,
+	 *
+	 * 2) ksoftirqd/0 and kswapd0 look like stable enough kernel threads,
+	 * but their PIDs are unstable.
+	 *
+	 * Check against kthreadd which always seem to exist under pid 2.
+	 */
+	int fd = open("/proc/2/status", O_RDONLY);
+	assert(fd >= 0);
+
+	char buf[4096];
+	ssize_t rv = read(fd, buf, sizeof(buf));
+	assert(0 <= rv && rv < sizeof(buf));
+	buf[rv] = '\0';
+
+	assert(strstr(buf, "Kthread:\t1\n"));
+
+	return 0;
+}
--- /dev/null
+++ a/tools/testing/selftests/proc/proc-self-isnt-kthread.c
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2024 Alexey Dobriyan <adobriyan@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+/* Test that userspace program is not kernel thread. */
+#undef NDEBUG
+#include <assert.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+
+int main(void)
+{
+	int fd = open("/proc/self/status", O_RDONLY);
+	assert(fd >= 0);
+
+	char buf[4096];
+	ssize_t rv = read(fd, buf, sizeof(buf));
+	assert(0 <= rv && rv < sizeof(buf));
+	buf[rv] = '\0';
+
+	/* This test is very much not kernel thread. */
+	assert(strstr(buf, "Kthread:\t0\n"));
+
+	return 0;
+}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

build-id-require-program-headers-to-be-right-after-elf-header.patch
compilerh-simplify-data_race-macro.patch

