Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B97162A02
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518403; cv=none; b=qXTILXz001AU4nOOG+ENJaiiqcNp9PixtPmk6m1o0dlglvCUe9iQoi/B53YFjLjpsV9LWCflVfFVa/WQlyB7VjBXY08yfN3Pf+toED8WlLUJliXh5VTzHEWmRNxmXJOVFOOVOPXq3xXfvqmxyUZurdQKtHtW8OToJYz57lEqrJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518403; c=relaxed/simple;
	bh=VNAryDIT45d04LTcbiMHaKowzctMhdBVcbcM+iSIp9k=;
	h=Date:To:From:Subject:Message-Id; b=p5xAAfio+7i8YLCapWCAzbIhfOfqm1VIArspI64X8EIQ/5YC9lC21uWlivck1enzSVCb9iq1uRYffwTfhyKP5ifIqoLYBmLEA50Nir81S07y0d55LMBU9wHDGpa0avv+mFqUJ/Sv3bMmmjWxvDj/QHpy/h5ABOFgYGsj5lFK1co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LgK3xomb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LgK3xomb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CA9C2BBFC;
	Thu, 27 Jun 2024 20:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719518403;
	bh=VNAryDIT45d04LTcbiMHaKowzctMhdBVcbcM+iSIp9k=;
	h=Date:To:From:Subject:From;
	b=LgK3xombe+BlQu5tBDkTcxi4/supUXsgE5bBShFCv7J9LRKukiuUzqwR62VjhtRFo
	 p998tQDYVOIY8MMunzl75vrKcZnq23yt0Zj+vuHIhUiwrwACYLpi5pAOEq+0VWwbi6
	 /dIdttlw8/Kty7EMyglRocDTPtEzG0OvS/s80hYs=
Date: Thu, 27 Jun 2024 13:00:02 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,rppt@kernel.org,Liam.Howlett@oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-add-procmap_query-ioctl-tests.patch added to mm-unstable branch
Message-Id: <20240627200002.E2CA9C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: add PROCMAP_QUERY ioctl tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-proc-add-procmap_query-ioctl-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-add-procmap_query-ioctl-tests.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: selftests/proc: add PROCMAP_QUERY ioctl tests
Date: Thu, 27 Jun 2024 10:08:58 -0700

Extend existing proc-pid-vm.c tests with PROCMAP_QUERY ioctl() API.  Test
a few successful and negative cases, validating querying filtering and
exact vs next VMA logic works as expected.

Link: https://lkml.kernel.org/r/20240627170900.1672542-7-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
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

fs-procfs-extract-logic-for-getting-vma-name-constituents.patch
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api.patch
docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch
tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch
selftests-proc-add-procmap_query-ioctl-tests.patch

