Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6881F33987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810122; cv=none; b=NHAsN8tFoY5ADcIceVs7jlgfWfYsV3gKhiYfTB3XnnxB9LC0VXo6zItn4jovdN1TpD/8wkZqMkZrtlkLrwk+O4FlNbiHZ1PWptGAexvBwMmrObg3f5IBvF76jxkPPAdqzO1w2bTV2YoxV6s8VWyQe1F3grrsiMjOkY1lf+N7pn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810122; c=relaxed/simple;
	bh=QiKbURbFkQHLR95AM+GkJReGDt6t3XzvLSgk30GyJGs=;
	h=Date:To:From:Subject:Message-Id; b=Xy3W8mkte3+ZqicQo9nS9tJ08+zpp9RJLHIUNVxgWnyGzwQw657qDxHhUpib8MzQ5IbqoW8ydS/kUr0/Z1hNRJy4rHGagCQG83EDfpYNtgz7c/GFHmuJQ1x+v4fx+X779DKC962vvGAF9LhEuLV4v5+lLMMySazcuCWH5pAX/Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NkDI6p1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NkDI6p1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD28C4CEEB;
	Sun, 14 Sep 2025 00:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810122;
	bh=QiKbURbFkQHLR95AM+GkJReGDt6t3XzvLSgk30GyJGs=;
	h=Date:To:From:Subject:From;
	b=NkDI6p1YPc5rgti+W72xkreOnN6B+scbSjoy1wW8KNPU7sOVwI7l6i/J9UCKhTjbO
	 IATRlMuHjgtxAsaF3J4V7RdIuqS/zxfwaP9Uwiixlsg7c4mJ8idK/CijWgWVnA8rel
	 yDPU74l9xoDo0B7VqyCA6w7Y8Tj4p1w0Y1kCo52g=
Date: Sat, 13 Sep 2025 17:35:21 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-test-lseek-on-proc-net-dev.patch removed from -mm tree
Message-Id: <20250914003522.3DD28C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: test lseek on /proc/net/dev
has been removed from the -mm tree.  Its filename was
     proc-test-lseek-on-proc-net-dev.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


