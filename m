Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3413D2C9A
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744161474; cv=none; b=iDv7jyFi44NihzIQpaLvAm1VwKPqo6bK7UsyFlm2UwA9WhrZpn0viQ8uGP2Ne83ejMpdUJe4qgU7BAkwXA4arXSowckd3mqVTxuLTpMpHt4KrNrHdZ+Ze/8w35db/Rn4pKyGF4TvVmuTXsW1anlTsgCzFNN5W3CGSHSBUbjOSWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744161474; c=relaxed/simple;
	bh=kx79DHuzk731wLEgBgYrzoAFItaWq9WXxlByKOBRJ5g=;
	h=Date:To:From:Subject:Message-Id; b=EksdVSGwJQAe4XXk8FgNrkdhyLf+bZ4W+zBYOylO7aEQC0kiNX30Ea6cvUXk3PTC5HuunWJxVo8NqVrkd+hT38JAb/NoOrHlOGE4Ejv0mUH/DhlKMqs3twoE9btPWqb49Ck/US5VC9g524MqZOhQm+8Wz1aa0eQ936rIlWCtu/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b57MtnRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b57MtnRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B01EC4CEE5;
	Wed,  9 Apr 2025 01:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744161472;
	bh=kx79DHuzk731wLEgBgYrzoAFItaWq9WXxlByKOBRJ5g=;
	h=Date:To:From:Subject:From;
	b=b57MtnRzbSexAU35nnwZ08/Me11W36f/diq21feFaNDIgSr8yMsSUggIyGPXSb3DO
	 LynKFuLM3apwJriCqHMZiV9TEVFMRP8L1ZPycx4DX+3gay5AOFvzWMOuPfcsdFHCyg
	 eP1iNQZjhQduQ//VyBiSui+qSthSnzcwJJZqV2JQ=
Date: Tue, 08 Apr 2025 18:17:52 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,riel@surriel.com,richard.weiyang@gmail.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch added to mm-new branch
Message-Id: <20250409011752.9B01EC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing: add PROCMAP_QUERY helper functions in mm self tests
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch

This patch will later appear in the mm-new branch at
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
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
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

mm-vma-add-give_up_on_oom-option-on-modify-merge-use-in-uffd-release.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch

