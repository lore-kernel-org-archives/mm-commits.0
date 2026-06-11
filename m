Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0312E428822
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 16:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781195152; cv=none; b=MlZEhDhgfbOB75qjkB9qXHtX+fEPMXLUyY3qD07rkRC7WtYOlA82Jcbl74juEFkJWQzLgeOdllhSiCuAyzef+QGdd5iR/Z+KnoeoFPFtARPS4FSuUUaLG01rMRvdQCbl0NVof8UeT1jXJWybwzl6qLFl8ADzcLjK3n7kim/WyrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781195152; c=relaxed/simple;
	bh=NwVtoViQHNt0aKdDuU029Vt9qskTpVa0KehjoK6TB6E=;
	h=Date:To:From:Subject:Message-Id; b=HRx5sJKVRrAmVOJ1xPLKoK67MtlP/HDi0kE9wVkk2hsoX/G4FyuD756UVh4gBfDvppRBYHws6nJVu6XDlvFiAoZ24WfAPaCLJfLT9BVzFnMNRU+/XfLa5MQLx2kT5jORQkeNgBC+xCOp7I0pSaGFs806SOQZCfc1bB+6WsbbAVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WPOsX3/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WPOsX3/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880681F00893;
	Thu, 11 Jun 2026 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781195150;
	bh=nCsKnAh4GnPt+DDTZSaclMyGLa/BywCoIzm2NJ0ieYc=;
	h=Date:To:From:Subject;
	b=WPOsX3/j99/MGOomiRwpcVyOrDSq/A10K0KsMixjxTW1EZWpndTlMHxGisZH1vTRx
	 8j09oiIy6vEpubDeiL0IpH9GFqEW2PdAVenHNUB4pXH6vm4/UP8CgGGVIoSL6kx9vF
	 GzvwkZUUapZzVaPeg2nufDwmA1D5U21PxiGQHQzw=
Date: Thu, 11 Jun 2026 09:25:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jason@zx2c4.com,dev.jain@arm.com,broonie@kernel.org,anthony.yznaga@oracle.com,Aishwarya.TCV@arm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-and-speedup-droppable-test.patch added to mm-unstable branch
Message-Id: <20260611162550.880681F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: fix and speedup "droppable" test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-and-speedup-droppable-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-and-speedup-droppable-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: selftests: mm: fix and speedup "droppable" test
Date: Thu, 11 Jun 2026 12:01:55 +0200

The droppable test currently relies on creating memory pressure in a child
process to trigger dropping the droppable pages.

That not only takes a long time on some machines (allocating and filling
all that memory), on large machines this will not work as we hardcode the
area size to 134217728 bytes.

...  further, we rely on timeouts to detect that memory was not dropped,
which is really suboptimal.

Instead, let's just use MADV_PAGEOUT on a 2 MiB region.  MADV_PAGEOUT
works with droppable memory even without swap.

There is the low chance of MADV_PAGEOUT failing to drop a page because of
speculative references.  We'll wait 1s and retry 10 times to rule that
unlikely case out as best as we can.

On a machine without swap:

	$ ./droppable
	TAP version 13
	1..1
	ok 1 madvise(MADV_PAGEOUT) behavior
	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lore.kernel.org/20260611-droppable_test-v1-1-b6a73d99f658@kernel.org
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/droppable.c |   46 +++++++++++++----------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/mm/droppable.c~selftests-mm-fix-and-speedup-droppable-test
+++ a/tools/testing/selftests/mm/droppable.c
@@ -17,10 +17,10 @@
 
 int main(int argc, char *argv[])
 {
-	size_t alloc_size = 134217728;
-	size_t page_size = getpagesize();
+	const size_t alloc_size = 2 * 1024 * 1024;
+	int retry_count = 10;
+	bool dropped;
 	void *alloc;
-	pid_t child;
 
 	ksft_print_header();
 	ksft_set_plan(1);
@@ -35,26 +35,32 @@ int main(int argc, char *argv[])
 		exit(KSFT_FAIL);
 	}
 	memset(alloc, 'A', alloc_size);
-	for (size_t i = 0; i < alloc_size; i += page_size)
-		assert(*(uint8_t *)(alloc + i));
 
-	child = fork();
-	assert(child >= 0);
-	if (!child) {
-		for (;;)
-			*(char *)malloc(page_size) = 'B';
-	}
-
-	for (bool done = false; !done;) {
-		for (size_t i = 0; i < alloc_size; i += page_size) {
-			if (!*(uint8_t *)(alloc + i)) {
-				done = true;
-				break;
+	while (retry_count--) {
+		if (madvise(alloc, alloc_size, MADV_PAGEOUT)) {
+			if (errno == EINVAL) {
+				ksft_test_result_skip("madvise(MADV_PAGEOUT) not supported\n");
+				exit(KSFT_SKIP);
 			}
+			ksft_test_result_fail("madvise(MADV_PAGEOUT) error: %s\n", strerror(errno));
+			exit(KSFT_FAIL);
 		}
+
+		dropped = memchr(alloc, 'A', alloc_size) == NULL;
+
+		/*
+		 * Speculative reference can temporarily prevent some
+		 * pages from getting dropped. So sleep and retry.
+		 *
+		 * If a page is not droppable for 10s, something
+		 * is seriously messed up and we want to fail.
+		 */
+		if (dropped)
+			break;
+		sleep(1);
 	}
-	kill(child, SIGTERM);
 
-	ksft_test_result_pass("MAP_DROPPABLE: PASS\n");
-	exit(KSFT_PASS);
+	ksft_test_result(dropped, "madvise(MADV_PAGEOUT) behavior\n");
+
+	ksft_finished();
 }
_

Patches currently in -mm which might be from david@kernel.org are

selftests-mm-fix-and-speedup-droppable-test.patch

