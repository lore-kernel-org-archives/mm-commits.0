Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F40370AD8
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067224; cv=none; b=aBdKW9/4GyQCRTCsAoOQFCxzpovLQ2NOOr2EFnfbVyuqlFSUspfOBWwdTEJ4MrRr5pnFsSY7vLt6c8O/yAp6MBeL7884N/je+UCo24Lzz1hlsdPkkOrETryr5hOlYR6ZIv5AgPUkiys1u+sAQE/HXRBToyNSwVL/zJXKQ+ZVd7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067224; c=relaxed/simple;
	bh=wKUxDDOIS0l6uxsvaIj051rN+AIRoiSzF/P/Wyps+Mc=;
	h=Date:To:From:Subject:Message-Id; b=hAeV/dkcLg+nK8Fb3mO1e4viiGhwSMTOzRrgVIN1cDdOE4D1G/hAmNNDccSPOT72OFR2klX/4x+FKBZI1sewXOUdIap4DV/1IyI9SOmnVIOwSahctxOeV1PlUW24MWzZAfBFk5vcHQ0bi1kz8dHd6Y4uU1dp0YZXssSReJrqPUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P9T5lvS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P9T5lvS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BF41F000E9;
	Sun, 21 Jun 2026 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067223;
	bh=x+iiHrkR8swu76u0XFW2lbys9NJb2A3gdDqoJ2QeULg=;
	h=Date:To:From:Subject;
	b=P9T5lvS0XQP/ZWTz98PN/irRWj6A9dMaFikkB7Q7xwY+ubhi/nGTLjseKDXil/lft
	 G2rvrIez8KjS9LfbcV/MvjpadULkg5pkDm1/ZeLhlRsix4NakB9m7hDLH42g8oiaHR
	 FAx7a1+YCZrsjW6Hsmp2PapnjZdgkG71W3eopLjk=
Date: Sun, 21 Jun 2026 11:40:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sayalip@linux.ibm.com,rppt@kernel.org,rcampbell@nvidia.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,alex.sierra@amd.com,aboorvad@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-exclusive_cow-test-fork-handling.patch removed from -mm tree
Message-Id: <20260621184023.13BF41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix exclusive_cow test fork() handling
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-exclusive_cow-test-fork-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: selftests/mm: fix exclusive_cow test fork() handling
Date: Thu, 11 Jun 2026 09:11:02 +0530

The test ignores the return value of fork(), so both the parent and the
(newly created) child run the COW verification loops and then call
hmm_buffer_free() before returning into the kselftest harness, which
_exit()s each side.  This duplicated teardown sequence has been observed
to manifest as a SIGSEGV in the test child, e.g.:

  hmm-tests[360141]: segfault (11) at 0 nip 10006964 lr 1000ac3c code 1
  in hmm-tests[6964,10000000+30000]

Fix this by adopting the same fork()-then-wait pattern already used by the
nearby anon_write_child / anon_write_child_shared tests in this file: the
child performs the COW verification and then _exit(0)s so it does not run
the test teardown, while the parent independently verifies COW, waits for
the child, and only then frees the buffer.

Link: https://lore.kernel.org/20260611034102.1030738-4-aboorvad@linux.ibm.com
Fixes: b659baea75469 ("mm: selftests for exclusive device memory")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |   31 ++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-fix-exclusive_cow-test-fork-handling
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -1884,6 +1884,8 @@ TEST_F(hmm, exclusive_cow)
 	unsigned long i;
 	int *ptr;
 	int ret;
+	pid_t pid;
+	int status;
 
 	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
 	ASSERT_NE(npages, 0);
@@ -1912,14 +1914,37 @@ TEST_F(hmm, exclusive_cow)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	fork();
+	pid = fork();
+	if (pid == -1)
+		ASSERT_EQ(pid, 0);
+
+	if (pid == 0) {
+		/*
+		 * Child verifies COW independently, then _exit(0)s so it does
+		 * not run the test teardown.  A failed ASSERT_* here makes the
+		 * harness abort() the child, so the parent sees
+		 * !WIFEXITED(status) below and fails in turn.
+		 */
+		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+			ASSERT_EQ(ptr[i]++, i);
 
-	/* Fault pages back to system memory and check them. */
+		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+			ASSERT_EQ(ptr[i], i + 1);
+
+		_exit(0);
+	}
+
+	/* Parent: also increment to verify COW works for both processes. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i]++, i);
 
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], i+1);
+		ASSERT_EQ(ptr[i], i + 1);
+
+	/* Parent: wait for child and then free the buffer. */
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
 
 	hmm_buffer_free(buffer);
 }
_

Patches currently in -mm which might be from aboorvad@linux.ibm.com are


