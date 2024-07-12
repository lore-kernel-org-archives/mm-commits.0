Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD26D7E0F2
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824853; cv=none; b=P5MDkwm90pG3QPT4yo9jz1YEp8D1ydytvVcju6Z6DzKdVlH0oa+YoTC6ld1JxPmVOBAogjtQ5u+hXtuP8QtiAbxzesovNADLD8GzRnOXiYM+I1A6YDrLo3wPfkJWL4DQ7VzTinanm8aq8KztbiG1tkU/9YjX3WlmvnjHqxzp6j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824853; c=relaxed/simple;
	bh=EwUS//CTZS6QR3e2TBronUqLI17Gs4mi5SPrzzWL5+Y=;
	h=Date:To:From:Subject:Message-Id; b=ewOfy++XEbB04r3phU6+6NLJNvOCC37xfQRpld+vBAib8xOiJXNFkA5eDRzMjC+NL5uVntM6A8BtebKV4FM1nnJXzaRdcfYHYJbIxVgCSXUD08TFxhvheQ2NV6WqT4AJOFdQ+jhSBY7O7RyxJb3XLiUlDhudwBWh1hxVT4XUkQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rAXZHmIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rAXZHmIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE5BC4AF07;
	Fri, 12 Jul 2024 22:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824853;
	bh=EwUS//CTZS6QR3e2TBronUqLI17Gs4mi5SPrzzWL5+Y=;
	h=Date:To:From:Subject:From;
	b=rAXZHmIw4IW7fZxADsRM5JY4iadw01wioRcr/8QPTw7LLkJiN+R28rDgE8AT+Aa9u
	 G3LAHaRatJ8sUPauGAhRTZjjwoC7YYiFAtEb9CEC30LQplJ4NyavEPXLR5KGxJ1dZl
	 tskLJGOerC/ciosbYI7hnkdbSNktE5+DCgQnUGHw=
Date: Fri, 12 Jul 2024 15:54:13 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,sfr@canb.auug.org.au,rppt@kernel.org,Liam.Howlett@Oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,arnd@arndb.de,ak@linux.intel.com,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-proc-add-procmap_query-ioctl-tests.patch removed from -mm tree
Message-Id: <20240712225413.8AE5BC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/proc: add PROCMAP_QUERY ioctl tests
has been removed from the -mm tree.  Its filename was
     selftests-proc-add-procmap_query-ioctl-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: selftests/proc: add PROCMAP_QUERY ioctl tests
Date: Thu, 27 Jun 2024 10:08:58 -0700

Extend existing proc-pid-vm.c tests with PROCMAP_QUERY ioctl() API.  Test
a few successful and negative cases, validating querying filtering and
exact vs next VMA logic works as expected.

Link: https://lkml.kernel.org/r/20240627170900.1672542-7-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/Makefile      |    1 
 tools/testing/selftests/proc/proc-pid-vm.c |   86 +++++++++++++++++++
 2 files changed, 87 insertions(+)

--- a/tools/testing/selftests/proc/Makefile~selftests-proc-add-procmap_query-ioctl-tests
+++ a/tools/testing/selftests/proc/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -Wall -O2 -Wno-unused-function
+CFLAGS += $(TOOLS_INCLUDES)
 LDFLAGS += -pthread
 
 TEST_GEN_PROGS :=
--- a/tools/testing/selftests/proc/proc-pid-vm.c~selftests-proc-add-procmap_query-ioctl-tests
+++ a/tools/testing/selftests/proc/proc-pid-vm.c
@@ -45,6 +45,7 @@
 #include <linux/kdev_t.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <linux/fs.h>
 
 #include "../kselftest.h"
 
@@ -492,6 +493,91 @@ int main(void)
 		assert(buf[13] == '\n');
 	}
 
+	/* Test PROCMAP_QUERY ioctl() for /proc/$PID/maps */
+	{
+		char path_buf[256], exp_path_buf[256];
+		struct procmap_query q;
+		int fd, err;
+
+		snprintf(path_buf, sizeof(path_buf), "/proc/%u/maps", pid);
+		fd = open(path_buf, O_RDONLY);
+		if (fd == -1)
+			return 1;
+
+		/* CASE 1: exact MATCH at VADDR */
+		memset(&q, 0, sizeof(q));
+		q.size = sizeof(q);
+		q.query_addr = VADDR;
+		q.query_flags = 0;
+		q.vma_name_addr = (__u64)(unsigned long)path_buf;
+		q.vma_name_size = sizeof(path_buf);
+
+		err = ioctl(fd, PROCMAP_QUERY, &q);
+		assert(err == 0);
+
+		assert(q.query_addr == VADDR);
+		assert(q.query_flags == 0);
+
+		assert(q.vma_flags == (PROCMAP_QUERY_VMA_READABLE | PROCMAP_QUERY_VMA_EXECUTABLE));
+		assert(q.vma_start == VADDR);
+		assert(q.vma_end == VADDR + PAGE_SIZE);
+		assert(q.vma_page_size == PAGE_SIZE);
+
+		assert(q.vma_offset == 0);
+		assert(q.inode == st.st_ino);
+		assert(q.dev_major == MAJOR(st.st_dev));
+		assert(q.dev_minor == MINOR(st.st_dev));
+
+		snprintf(exp_path_buf, sizeof(exp_path_buf),
+			"/tmp/#%llu (deleted)", (unsigned long long)st.st_ino);
+		assert(q.vma_name_size == strlen(exp_path_buf) + 1);
+		assert(strcmp(path_buf, exp_path_buf) == 0);
+
+		/* CASE 2: NO MATCH at VADDR-1 */
+		memset(&q, 0, sizeof(q));
+		q.size = sizeof(q);
+		q.query_addr = VADDR - 1;
+		q.query_flags = 0; /* exact match */
+
+		err = ioctl(fd, PROCMAP_QUERY, &q);
+		err = err < 0 ? -errno : 0;
+		assert(err == -ENOENT);
+
+		/* CASE 3: MATCH COVERING_OR_NEXT_VMA at VADDR - 1 */
+		memset(&q, 0, sizeof(q));
+		q.size = sizeof(q);
+		q.query_addr = VADDR - 1;
+		q.query_flags = PROCMAP_QUERY_COVERING_OR_NEXT_VMA;
+
+		err = ioctl(fd, PROCMAP_QUERY, &q);
+		assert(err == 0);
+
+		assert(q.query_addr == VADDR - 1);
+		assert(q.query_flags == PROCMAP_QUERY_COVERING_OR_NEXT_VMA);
+		assert(q.vma_start == VADDR);
+		assert(q.vma_end == VADDR + PAGE_SIZE);
+
+		/* CASE 4: NO MATCH at VADDR + PAGE_SIZE */
+		memset(&q, 0, sizeof(q));
+		q.size = sizeof(q);
+		q.query_addr = VADDR + PAGE_SIZE; /* point right after the VMA */
+		q.query_flags = PROCMAP_QUERY_COVERING_OR_NEXT_VMA;
+
+		err = ioctl(fd, PROCMAP_QUERY, &q);
+		err = err < 0 ? -errno : 0;
+		assert(err == -ENOENT);
+
+		/* CASE 5: NO MATCH WRITABLE at VADDR */
+		memset(&q, 0, sizeof(q));
+		q.size = sizeof(q);
+		q.query_addr = VADDR;
+		q.query_flags = PROCMAP_QUERY_VMA_WRITABLE;
+
+		err = ioctl(fd, PROCMAP_QUERY, &q);
+		err = err < 0 ? -errno : 0;
+		assert(err == -ENOENT);
+	}
+
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from andrii@kernel.org are


