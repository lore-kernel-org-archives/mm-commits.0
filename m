Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFC03FE4
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 02:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748919149; cv=none; b=n3LW89ld9QSQ0jBOW4UfVtIpvZ01zKGvw7sJxceKAJaqUvIV9k7YlSZxb/HekBL/+ncKGfDkkURvx57blJCnals+ONccDpgqVTj/6n4W8gbu3ob3bOTCakKLg/kc6+Pk2Fb2xpkDsCLOEWQQ8otHgFTm4OZbxZ260LohM++oI50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748919149; c=relaxed/simple;
	bh=nTmgBBcyoPc28VXIuFvD4yljaYkT4NWLKJa0cDsaDCY=;
	h=Date:To:From:Subject:Message-Id; b=WwBOCemjKT0uQMYmQKwuTuJx0iGoL4DiWd50xKweOx6KnpQelAVfLMVkJKZkTSXquP8YMWZTWQqCsH1TN4JNPRRrfAPeZdCXidpPNVCtwRvmpjZ99IKqITUBxhce9rZizuV5sedoTwH/vroeUh0wVFsdBOVH2MuY4YApTK33opY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AaeE/iUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AaeE/iUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A14FC4CEEB;
	Tue,  3 Jun 2025 02:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748919149;
	bh=nTmgBBcyoPc28VXIuFvD4yljaYkT4NWLKJa0cDsaDCY=;
	h=Date:To:From:Subject:From;
	b=AaeE/iUAnDJ2EfsUq3RkbmsHrXIlrz21iRcBLsTsIU1cYAMengvmPHQcUpfbap1JV
	 hhYYvG4aLAONPyV7OSo2n18WVM0IrfF7xy9sHeRU2OELPN6WkpjM0MkHSLen8CCAJL
	 RlmFq+6+9Zz935o96RKsG7CHuDiJZEfi5NDnATdI=
Date: Mon, 02 Jun 2025 19:52:28 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch added to mm-new branch
Message-Id: <20250603025229.3A14FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add VMA merge tests for KSM merge
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: tools/testing/selftests: add VMA merge tests for KSM merge
Date: Thu, 29 May 2025 18:15:48 +0100

Add test to assert that we have now allowed merging of VMAs when KSM
merging-by-default has been set by prctl(PR_SET_MEMORY_MERGE, ...).

We simply perform a trivial mapping of adjacent VMAs expecting a merge,
however prior to recent changes implementing this mode earlier than
before, these merges would not have succeeded.

Assert that we have fixed this!

Link: https://lkml.kernel.org/r/6dec7aabf062c6b121cfac992c9c716cefdda00c.1748537921.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Tested-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   78 +++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-vma-merge-tests-for-ksm-merge
+++ a/tools/testing/selftests/mm/merge.c
@@ -2,11 +2,13 @@
 
 #define _GNU_SOURCE
 #include "../kselftest_harness.h"
+#include <linux/prctl.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <sys/prctl.h>
 #include <sys/syscall.h>
 #include <sys/wait.h>
 #include <linux/perf_event.h>
@@ -34,6 +36,11 @@ FIXTURE_TEARDOWN(merge)
 {
 	ASSERT_EQ(munmap(self->carveout, 12 * self->page_size), 0);
 	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	/*
+	 * Clear unconditionally, as some tests set this. It is no issue if this
+	 * fails (KSM may be disabled for instance).
+	 */
+	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
 }
 
 TEST_F(merge, mprotect_unfaulted_left)
@@ -495,4 +502,75 @@ TEST_F(merge, handle_uprobe_upon_merged_
 	remove(probe_file);
 }
 
+TEST_F(merge, ksm_merge)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2;
+	int err;
+
+	/*
+	 * Map two R/W immediately adjacent to one another, they should
+	 * trivially merge:
+	 *
+	 * |-----------|-----------|
+	 * |    R/W    |    R/W    |
+	 * |-----------|-----------|
+	 *      ptr         ptr2
+	 */
+
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
+		    PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
+
+	/* Unmap the second half of this merged VMA. */
+	ASSERT_EQ(munmap(ptr2, page_size), 0);
+
+	/* OK, now enable global KSM merge. We clear this on test teardown. */
+	err = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
+	if (err == -1) {
+		int errnum = errno;
+
+		/* Only non-failure case... */
+		ASSERT_EQ(errnum, EINVAL);
+		/* ...but indicates we should skip. */
+		SKIP(return, "KSM memory merging not supported, skipping.");
+	}
+
+	/*
+	 * Now map a VMA adjacent to the existing that was just made
+	 * VM_MERGEABLE, this should merge as well.
+	 */
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
+		    PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
+
+	/* Now this VMA altogether. */
+	ASSERT_EQ(munmap(ptr, 2 * page_size), 0);
+
+	/* Try the same operation as before, asserting this also merges fine. */
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
+		    PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

kvm-s390-rename-prot_none-to-prot_type_dummy.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch

