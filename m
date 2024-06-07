Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8050E14EC4F
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792473; cv=none; b=jnFdCPvcCMOudqG/jEddmPk2YhBeQiCsME4L1oaA1lj15IX3TwVRwFSTJP5QWJDasIqokzpnsIKi2VLgtZhvrl7g95hdCFT0FxLsMXb0gYYLquepR6MnKG0mrVucydP3EF/wf6DC+R4YlWcR1BUhyeYcwDzUyDch1+fCGGf9Pw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792473; c=relaxed/simple;
	bh=82Ka3mw0LZyEY/rjkCcwkFMWyk5oph1RIDaa+0b9T+4=;
	h=Date:To:From:Subject:Message-Id; b=I5b3RaCs5DHztcdGNGI+o7Um359wqb/YIRyj9S27NVzgGcsNTLYH+nFMZ+z0O/eQryOeDRIxwZ/C+hQYQEcUdtn2HQhBTFyGhSXqJbodw/wMsGz2x26uNZfWku3pTu9gdGCSqEpgNUgHN4u/PgvOq8VTXPeriYi/BLZemyZP8Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oqgcx0Wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oqgcx0Wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE312C2BBFC;
	Fri,  7 Jun 2024 20:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717792472;
	bh=82Ka3mw0LZyEY/rjkCcwkFMWyk5oph1RIDaa+0b9T+4=;
	h=Date:To:From:Subject:From;
	b=Oqgcx0WamFv4shft2xDz2MLyImpENWfNlCfqBqywmpJ7Drua9p/ajq+gA1qIrwNOx
	 FdlUAhDjVrSERcfUvHSqrOteCopz2zrlxybBb2B2c+1pKl3gxKE709vkLQpvYBiq/G
	 ucNL5oThfvfLithshAM0pqf0btSP8eXJ6l/LX8+M=
Date: Fri, 07 Jun 2024 13:34:31 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,fullspring2018@gmail.com,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-test-kthread-field.patch added to mm-nonmm-unstable branch
Message-Id: <20240607203431.EE312C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: test "Kthread:" field
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-test-kthread-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-test-kthread-field.patch

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

proc-test-kthread-field.patch

