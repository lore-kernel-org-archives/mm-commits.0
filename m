Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6963101AA
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 21:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755637822; cv=none; b=elwppoMbU4Mkn43R3SaYLTYd/EBlL/B28WT2AQTh7w+DO0pFQ5CtVC8lIJrAhdToux6vagDViAK6VN38QZg8t4F5rQ9MiuoWlc0FkjvkBZhiLCtI4ZB1PD5M8q+Fh7aeoeKkUzEaLAq7djC6ywpoqSXQRFOMKTqW8k9+vvpQLxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755637822; c=relaxed/simple;
	bh=mFG2p3A3wdCIdxI1GRFt/d8XMnDvE1Ry8UAJKO/+OXE=;
	h=Date:To:From:Subject:Message-Id; b=Wyxa5axTNj4FUKYH1ZINPPLHLvSQRab2FGaj1QPFklVtt6KDJtbTe34p7GdjgUEes+PCtTydvK4srcCbxwduyN9dRjRArUrz56XeKhosA1AEg93iS5tZ5ZY5UOXMrMyPmcYAR1IW5iSoW8jBYhyCqQ9aFQBZ8G0gEOQur2k1r/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fvMV5rfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fvMV5rfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D2EC4CEF1;
	Tue, 19 Aug 2025 21:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755637821;
	bh=mFG2p3A3wdCIdxI1GRFt/d8XMnDvE1Ry8UAJKO/+OXE=;
	h=Date:To:From:Subject:From;
	b=fvMV5rfj7Jhh5r+elXxc4aNvzeARkxwxvia5JDbxAG0ToNCfON2bHnEpQTv6wRiR+
	 Myk1a+BeTfjw6Z0Hnfs7jlvl0S5M0li2wE1AEevKjTCFOysmX9A7MnKBwqO3+hfxzY
	 JBSXuTOJpFBJA5dudhUt2GHrOKVfnRUerojO8mP8=
Date: Tue, 19 Aug 2025 14:10:20 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-test-lseek-on-proc-net-dev.patch added to mm-nonmm-unstable branch
Message-Id: <20250819211021.66D2EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: test lseek on /proc/net/dev
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-test-lseek-on-proc-net-dev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-test-lseek-on-proc-net-dev.patch

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
Subject: proc: test lseek on /proc/net/dev
Date: Tue, 19 Aug 2025 21:19:17 +0300

This line in tools/testing/selftests/proc/read.c was added to catch
oopses, not to verify lseek correctness:

        (void)lseek(fd, 0, SEEK_SET);

Oh, well. Prevent more embarassement with simple test.

Link: https://lkml.kernel.org/r/aKTCfMuRXOpjBXxI@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/.gitignore           |    1 
 tools/testing/selftests/proc/Makefile             |    1 
 tools/testing/selftests/proc/proc-net-dev-lseek.c |   68 ++++++++++++
 3 files changed, 70 insertions(+)

--- a/tools/testing/selftests/proc/.gitignore~proc-test-lseek-on-proc-net-dev
+++ a/tools/testing/selftests/proc/.gitignore
@@ -7,6 +7,7 @@
 /proc-loadavg-001
 /proc-maps-race
 /proc-multiple-procfs
+/proc-net-dev-lseek
 /proc-empty-vm
 /proc-pid-vm
 /proc-self-map-files-001
--- a/tools/testing/selftests/proc/Makefile~proc-test-lseek-on-proc-net-dev
+++ a/tools/testing/selftests/proc/Makefile
@@ -10,6 +10,7 @@ TEST_GEN_PROGS += fd-003-kthread
 TEST_GEN_PROGS += proc-2-is-kthread
 TEST_GEN_PROGS += proc-loadavg-001
 TEST_GEN_PROGS += proc-maps-race
+TEST_GEN_PROGS += proc-net-dev-lseek
 TEST_GEN_PROGS += proc-empty-vm
 TEST_GEN_PROGS += proc-pid-vm
 TEST_GEN_PROGS += proc-self-map-files-001
diff --git a/tools/testing/selftests/proc/proc-net-dev-lseek.c a/tools/testing/selftests/proc/proc-net-dev-lseek.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/proc/proc-net-dev-lseek.c
@@ -0,0 +1,68 @@
+/*
+ * Copyright (c) 2025 Alexey Dobriyan <adobriyan@gmail.com>
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
+#undef _GNU_SOURCE
+#define _GNU_SOURCE
+#undef NDEBUG
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+#include <sched.h>
+/*
+ * Test that lseek("/proc/net/dev/", 0, SEEK_SET)
+ * a) works,
+ * b) does what you think it does.
+ */
+int main(void)
+{
+	/* /proc/net/dev output is deterministic in fresh netns only. */
+	if (unshare(CLONE_NEWNET) == -1) {
+		if (errno == ENOSYS || errno == EPERM) {
+			return 4;
+		}
+		return 1;
+	}
+
+	const int fd = open("/proc/net/dev", O_RDONLY);
+	assert(fd >= 0);
+
+	char buf1[4096];
+	const ssize_t rv1 = read(fd, buf1, sizeof(buf1));
+	/*
+	 * Not "<=", this file can't be empty:
+	 * there is header, "lo" interface with some zeroes.
+	 */
+	assert(0 < rv1);
+	assert(rv1 <= sizeof(buf1));
+
+	/* Believe it or not, this line broke one day. */
+	assert(lseek(fd, 0, SEEK_SET) == 0);
+
+	char buf2[4096];
+	const ssize_t rv2 = read(fd, buf2, sizeof(buf2));
+	/* Not "<=", see above. */
+	assert(0 < rv2);
+	assert(rv2 <= sizeof(buf2));
+
+	/* Test that lseek rewinds to the beginning of the file. */
+	assert(rv1 == rv2);
+	assert(memcmp(buf1, buf2, rv1) == 0);
+
+	/* Contents of the file is not validated: this test is about lseek(). */
+
+	return 0;
+}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-test-lseek-on-proc-net-dev.patch

