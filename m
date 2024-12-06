Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E5F1758B
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733447231; cv=none; b=mmOjdJNDPQYS4XcsTz8Ad6xjpgxySpzLzhxgwPD5HgBTYnelAE+FZxrgY/RxUSe5g72lztWnLPhnsG3rYqj8a2DWt6mKgfv+8qWIg5FR2y/i9Oy74kj5WAtjloXqS8lfccTdvLHUPEXkrFF2DOVmWCOAW74maIS6C+5TzRacO8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733447231; c=relaxed/simple;
	bh=GAGbK3pwDu6aX56JBLaJedLvmTIabIhP2AoaARRuXTI=;
	h=Date:To:From:Subject:Message-Id; b=MQ9t6VZItX8Xye4PxtBEE4R2bjrU+6HE4OCKQMI/iuTrOxt+hti+fc6WbWB208ZogQtIAHP+mzJQ3GBhl926g0QFX2iwNUUK+9E3GwAUs5oglnCyHLQHVtKV9gKAyC/kTx1PQ/NfhtGTedDl3nUlOy/uzAo9nJ13RbZFB0KNZAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EviCcy4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EviCcy4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A99C4CED1;
	Fri,  6 Dec 2024 01:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733447231;
	bh=GAGbK3pwDu6aX56JBLaJedLvmTIabIhP2AoaARRuXTI=;
	h=Date:To:From:Subject:From;
	b=EviCcy4i3WLMWOZQjYGRS9cvdMjZFHzSP2rL/3cIHJHcnfvKR9VNFkwf+TsuP4S++
	 2G0XxBcFk1l/d/4pOwT5FmRzyGQMew6OqRnGEaEztjIGkGeOJ3Cai+L0j9FdZl9R8P
	 12FSFQaLRIGli5mmAueAhAprEJTPpP3J10Qbc3so=
Date: Thu, 05 Dec 2024 17:07:10 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-fork-cow-guard-page-test.patch added to mm-unstable branch
Message-Id: <20241206010710.E1A99C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add fork CoW guard page test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-fork-cow-guard-page-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-fork-cow-guard-page-test.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: selftests/mm: add fork CoW guard page test
Date: Thu, 5 Dec 2024 19:07:48 +0000

When we fork anonymous pages, apply a guard page then remove it, the
previous CoW mapping is cleared.

This might not be obvious to an outside observer without taking some time
to think about how the overall process functions, so document that this is
the case through a test, which also usefully asserts that the behaviour is
as we expect.

This is grouped with other, more important, fork tests that ensure that
guard pages are correctly propagated on fork.

Fix a typo in a nearby comment at the same time.

Link: https://lkml.kernel.org/r/20241205190748.115656-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-pages.c |   73 ++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/guard-pages.c~selftests-mm-add-fork-cow-guard-page-test
+++ a/tools/testing/selftests/mm/guard-pages.c
@@ -990,7 +990,7 @@ TEST_F(guard_pages, fork)
 		   MAP_ANON | MAP_PRIVATE, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	/* Establish guard apges in the first 5 pages. */
+	/* Establish guard pages in the first 5 pages. */
 	ASSERT_EQ(madvise(ptr, 5 * page_size, MADV_GUARD_INSTALL), 0);
 
 	pid = fork();
@@ -1026,6 +1026,77 @@ TEST_F(guard_pages, fork)
 	}
 
 	/* Cleanup. */
+	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+}
+
+/*
+ * Assert expected behaviour after we fork populated ranges of anonymous memory
+ * and then guard and unguard the range.
+ */
+TEST_F(guard_pages, fork_cow)
+{
+	const unsigned long page_size = self->page_size;
+	char *ptr;
+	pid_t pid;
+	int i;
+
+	/* Map 10 pages. */
+	ptr = mmap(NULL, 10 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/* Populate range. */
+	for (i = 0; i < 10 * page_size; i++) {
+		char chr = 'a' + (i % 26);
+
+		ptr[i] = chr;
+	}
+
+	pid = fork();
+	ASSERT_NE(pid, -1);
+	if (!pid) {
+		/* This is the child process now. */
+
+		/* Ensure the range is as expected. */
+		for (i = 0; i < 10 * page_size; i++) {
+			char expected = 'a' + (i % 26);
+			char actual = ptr[i];
+
+			ASSERT_EQ(actual, expected);
+		}
+
+		/* Establish guard pages across the whole range. */
+		ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_INSTALL), 0);
+		/* Remove it. */
+		ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_REMOVE), 0);
+
+		/*
+		 * By removing the guard pages, the page tables will be
+		 * cleared. Assert that we are looking at the zero page now.
+		 */
+		for (i = 0; i < 10 * page_size; i++) {
+			char actual = ptr[i];
+
+			ASSERT_EQ(actual, '\0');
+		}
+
+		exit(0);
+	}
+
+	/* Parent process. */
+
+	/* Parent simply waits on child. */
+	waitpid(pid, NULL, 0);
+
+	/* Ensure the range is unchanged in parent anon range. */
+	for (i = 0; i < 10 * page_size; i++) {
+		char expected = 'a' + (i % 26);
+		char actual = ptr[i];
+
+		ASSERT_EQ(actual, expected);
+	}
+
+	/* Cleanup. */
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correct-typo-in-mmap_state-macro.patch
docs-mm-add-vma-locks-documentation.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch

