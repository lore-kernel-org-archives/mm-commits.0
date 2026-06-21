Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8555D370AD7;
	Sun, 21 Jun 2026 18:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067214; cv=none; b=qvfPxf5gfj75FQCzt7SdmJWbIOEOClc8l5XkPZsF54lwrHFJVUM/uf4uFKj83NEhxkt7qUM4BYzZPHqjO+BtNrA9MOR9vh/Ps31ItlTtc7fIXMvuf8+RvnqpZ4FFxaiLQq1XzyAxTviSZOyJJyM/hoYUP5DBSVeYhPTkxHZeoMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067214; c=relaxed/simple;
	bh=F8emBPxSPqFsqltapfV9nQxiIXIhT4G39TecSgfbXIA=;
	h=Date:To:From:Subject:Message-Id; b=LiWQnxqjazHxqyP5zspqwdVn4miWpRDV5s9RhT2CuFabQCJaA2ZTUGo5Smj7wbtYn4FtyX+HFQCWO9lqeVh0WextjVv3XUYEVELQ0isUqOtPmimcwc9lGXv1pI74Htc6V7frePM29kWmNNVC0bWaYAybdoArQv3HZQkc2qaMKWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=STF2AUuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="STF2AUuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC711F00A3A;
	Sun, 21 Jun 2026 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067213;
	bh=SqFP3ZfN3SDRg9ZHNymkM4zaZrR7zQ4Wr14JH0VQ22o=;
	h=Date:To:From:Subject;
	b=STF2AUuD9Yfb/8k3G+twxZ3z5H1VDbSvL95fJy5AvH3utrkbjdo7TQNWSnSZT63Hr
	 ndBtBgB756k94zosnGGht1RcZ4xHbXwF+lc4/DRrIQhu2MAhhIAULL0cOU4ie2jOEa
	 b6yZi2Va88Qc9BLo2Lt7z930aRSsh8RUHqo8mTw0=
Date: Sun, 21 Jun 2026 11:40:12 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,Jason@zx2c4.com,dev.jain@arm.com,broonie@kernel.org,anthony.yznaga@oracle.com,Aishwarya.TCV@arm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-and-speedup-droppable-test.patch removed from -mm tree
Message-Id: <20260621184013.5CC711F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: fix and speedup "droppable" test
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-and-speedup-droppable-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
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


