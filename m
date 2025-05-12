Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D87B19CD1B
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011106; cv=none; b=nA4oficpoexomCBVMfzeOg1rrnOuAx/mOommf2F3bcw2B6u/qc6hHeskvz/Ltme+We0Nuy55wRefigCi5IjC3FxkGLOwdOD776EAnG9OZ74VQLkAQ0ErV8udcOi25VvAgEs/EVNdNX9NMQawlvaA8Cdy2U6UYJ1iDGoZhVN4+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011106; c=relaxed/simple;
	bh=huoPtNJl3NXR7VfLtqPOvzUi+JeNwEjcKtT2zUrLU8Y=;
	h=Date:To:From:Subject:Message-Id; b=f9wGtw15M/1ce1LLvZ+luxM61orL6dP28EWduemwgSXAESSrL2wiDnyAAumVDGezFEEcofqdvf2kVQUqeDqJvxRqfHyQEbbE1KD/F2xszaXQJS/WZzocoiaSv4YvYfg99pfhKVgblKtXZHs2Og3YZl5VDONu+cKlmrtUqRNfiwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ycRzs5q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ycRzs5q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61A3C4CEE4;
	Mon, 12 May 2025 00:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011106;
	bh=huoPtNJl3NXR7VfLtqPOvzUi+JeNwEjcKtT2zUrLU8Y=;
	h=Date:To:From:Subject:From;
	b=ycRzs5q3EXBkpa7v/+JeUW6paqnvVy1iSV4/FCM59PmIwcq4St39rUaJhtuY9wjNw
	 cwX/a+3JP/fI6BJoiMxyxK0SD+pAQH79kQSWrPeiFHW9bkb9J9E0BiInb+4KnRthFA
	 RfWLogpVgF5JvFir87+p6q0Tn15taClzDINht7DU=
Date: Sun, 11 May 2025 17:51:45 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,riel@surriel.com,richard.weiyang@gmail.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch removed from -mm tree
Message-Id: <20250512005145.E61A3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing: add PROCMAP_QUERY helper functions in mm self tests
has been removed from the -mm tree.  Its filename was
     tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing: add PROCMAP_QUERY helper functions in mm self tests
Date: Tue, 8 Apr 2025 10:29:32 +0100

The PROCMAP_QUERY ioctl() is very useful - it allows for binary access to
/proc/$pid/[s]maps data and thus convenient lookup of data contained
there.

This patch exposes this for convenient use by mm self tests so the state
of VMAs can easily be queried.

Link: https://lkml.kernel.org/r/ce83d877093d1fc594762cf4b82f0c27963030ee.1744104124.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   62 +++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |   21 ++++++++
 2 files changed, 83 insertions(+)

--- a/tools/testing/selftests/mm/vm_util.c~tools-testing-add-procmap_query-helper-functions-in-mm-self-tests
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <string.h>
+#include <errno.h>
 #include <fcntl.h>
 #include <dirent.h>
 #include <inttypes.h>
@@ -424,3 +425,64 @@ bool check_vmflag_io(void *addr)
 		flags += flaglen;
 	}
 }
+
+/*
+ * Open an fd at /proc/$pid/maps and configure procmap_out ready for
+ * PROCMAP_QUERY query. Returns 0 on success, or an error code otherwise.
+ */
+int open_procmap(pid_t pid, struct procmap_fd *procmap_out)
+{
+	char path[256];
+	int ret = 0;
+
+	memset(procmap_out, '\0', sizeof(*procmap_out));
+	sprintf(path, "/proc/%d/maps", pid);
+	procmap_out->query.size = sizeof(procmap_out->query);
+	procmap_out->fd = open(path, O_RDONLY);
+	if (procmap_out < 0)
+		ret = -errno;
+
+	return ret;
+}
+
+/* Perform PROCMAP_QUERY. Returns 0 on success, or an error code otherwise. */
+int query_procmap(struct procmap_fd *procmap)
+{
+	int ret = 0;
+
+	if (ioctl(procmap->fd, PROCMAP_QUERY, &procmap->query) == -1)
+		ret = -errno;
+
+	return ret;
+}
+
+/*
+ * Try to find the VMA at specified address, returns true if found, false if not
+ * found, and the test is failed if any other error occurs.
+ *
+ * On success, procmap->query is populated with the results.
+ */
+bool find_vma_procmap(struct procmap_fd *procmap, void *address)
+{
+	int err;
+
+	procmap->query.query_flags = 0;
+	procmap->query.query_addr = (unsigned long)address;
+	err = query_procmap(procmap);
+	if (!err)
+		return true;
+
+	if (err != -ENOENT)
+		ksft_exit_fail_msg("%s: Error %d on ioctl(PROCMAP_QUERY)\n",
+				   __func__, err);
+	return false;
+}
+
+/*
+ * Close fd used by PROCMAP_QUERY mechanism. Returns 0 on success, or an error
+ * code otherwise.
+ */
+int close_procmap(struct procmap_fd *procmap)
+{
+	return close(procmap->fd);
+}
--- a/tools/testing/selftests/mm/vm_util.h~tools-testing-add-procmap_query-helper-functions-in-mm-self-tests
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -6,6 +6,7 @@
 #include <strings.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
 #include "../kselftest.h"
+#include <linux/fs.h>
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
@@ -19,6 +20,15 @@
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
 
+/*
+ * Represents an open fd and PROCMAP_QUERY state for binary (via ioctl)
+ * /proc/$pid/[s]maps lookup.
+ */
+struct procmap_fd {
+	int fd;
+	struct procmap_query query;
+};
+
 static inline unsigned int psize(void)
 {
 	if (!__page_size)
@@ -73,6 +83,17 @@ int uffd_register_with_ioctls(int uffd,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
 unsigned long get_free_hugepages(void);
 bool check_vmflag_io(void *addr);
+int open_procmap(pid_t pid, struct procmap_fd *procmap_out);
+int query_procmap(struct procmap_fd *procmap);
+bool find_vma_procmap(struct procmap_fd *procmap, void *address);
+int close_procmap(struct procmap_fd *procmap);
+
+static inline int open_self_procmap(struct procmap_fd *procmap_out)
+{
+	pid_t pid = getpid();
+
+	return open_procmap(pid, procmap_out);
+}
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch

