Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC448E0ED
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897038; cv=none; b=bTaN2/O+TYQ15KbMfAHjE855gYS2+sV/9SNqfemIcwCCqBiuLT71vb6/xXD06QyGJqo9MpCQXBKhHdYB1PPrLx2Iopwm8Q08cPRDmAqglrkbjOdcXQAE5nbdBp2BJusL4Vo3wnuZBs6TKhCy+HVP9UtGTfk7NOscZAjCgYI9S7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897038; c=relaxed/simple;
	bh=xqjVqpDaNTc0sfdg/n6ePRss4yF40sfCOX5xDAx+IBg=;
	h=Date:To:From:Subject:Message-Id; b=Z8AvX77vIjc0KGwXWYH68PkmSC+XxNB0aGFqG/Z9zfc70atucf21M8x2hNoqR9LwZuoJOEGYcRqK/mdLOYF9+HuIAtaZErSaeI8ypYQd6bQo2T8P4eevOSfDjFmZ5HGhy0vJCA/q6QfDubxDlIg3wZ8PcC5nvSmhtLtJxg8huh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UyTrqH72; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UyTrqH72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34F31F00A3A;
	Tue,  8 Sep 2026 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897034;
	bh=LHskbwg9FxtexeTW3lTVUxJ4PQ9ixAfmrvV3zE+XM6A=;
	h=Date:To:From:Subject;
	b=UyTrqH72A2NLcBWXOHUZ8RC+Wucz8L3XuueOtKZpn6O1/o62wqJ7HlPAF4AD54c1L
	 aPNAE4SY57TWOaXQxcL+WNdywWBd3ErJyzZiaYctw+CbpS67MrfCeQ9biFYgwF/VNG
	 uZapTzuyAdeVmy/eo1VUdVHBuzLSD8LEZ7wgnbEs=
Date: Tue, 08 Sep 2026 12:50:34 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cover-a-shared-source-collapse-write-race.patch added to mm-new branch
Message-Id: <20260908195034.D34F31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: cover a shared-source collapse write race
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-cover-a-shared-source-collapse-write-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cover-a-shared-source-collapse-write-race.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: cover a shared-source collapse write race
Date: Tue, 8 Sep 2026 13:50:59 +0100

collapse_fork() checks that a fork-shared range collapses in the child
while the parent keeps its own pages, but the parent sits still while that
happens.  Nothing checks that CoW isolation survives a collapse racing
with writes to the shared source.

Add a case where the parent writes to the shared range throughout the
child's collapse.  CoW has to keep the two apart: the child must see the
content from before the fork, and the parent only its own writes.

The parent unshares one page every 10ms, starting only once the child says
it is about to collapse.  Writing the range in a burst would break CoW on
all of it before the collapse begins, leaving the child to collapse pages
that are already exclusive to it.

Preparation for changing how collapse handles fork-shared sources.

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-14-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |  100 ++++++++++++++++++++++
 1 file changed, 100 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-cover-a-shared-source-collapse-write-race
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1169,6 +1169,103 @@ static void collapse_max_ptes_shared(str
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * The parent writes to the fork-shared range throughout the child's
+ * collapse.  CoW must keep the two apart: the child sees the pre-fork
+ * content, the parent only its own writes.
+ */
+static void collapse_fork_cow_race(struct collapse_context *c, struct mem_ops *ops)
+{
+	const int stride = page_size / sizeof(int);
+	int wstatus, child_status, i, n;
+	unsigned long shared;
+	volatile int *ip;
+	pid_t child;
+	int sync[2];
+	char go = 1;
+	void *p;
+
+	/* At a page per 10 ms, 64 pages spread the writes across the collapse */
+	n = 64;
+	shared = n * page_size;
+
+	p = ops->setup_area(1);
+	/* Shared prefix, with the pre-fork pattern */
+	ops->fault(p, 0, shared);
+	if (pipe(sync))
+		ksft_exit_fail_perror("pipe()");
+
+	/* A volatile pointer so the stores are not merged or dropped */
+	ip = p;
+
+	ksft_print_msg("Fork, collapse in the child while the parent rewrites...");
+	child = fork();
+	if (!child) {
+		int collapse_status;
+
+		close(sync[0]);
+		/* Private remainder */
+		ops->fault(p, shared, hpage_pmd_size);
+		/* Start the parent unsharing, and give it a head start */
+		if (write(sync[1], &go, 1) != 1)
+			_exit(KSFT_FAIL);
+		usleep(5000);
+		c->collapse("Collapse a range the parent is writing to",
+			    p, 1, ops, true);
+		collapse_status = exit_status;
+		for (i = 0; i < n; i++)
+			if (ip[i * stride] != i + 0xdead0000)
+				break;
+		if (i == n)
+			success("OK");
+		else
+			fail("Fail: child content");
+		/* The content check must not bury a failed collapse */
+		if (exit_status != KSFT_FAIL)
+			exit_status = collapse_status;
+		ops->cleanup_area(p, hpage_pmd_size);
+		_exit(exit_status);
+	}
+
+	close(sync[1]);
+	if (read(sync[0], &go, 1) != 1)
+		ksft_exit_fail_msg("child never reached the collapse\n");
+
+	/*
+	 * Unshare one page at a time: a burst would break CoW on the whole
+	 * range before the collapse starts, leaving nothing shared to collapse.
+	 */
+	i = 0;
+	for (;;) {
+		if (i < n)
+			ip[i * stride] = i + 0xbeef0000;
+		i++;
+		usleep(10 * 1000);
+		if (waitpid(child, &wstatus, WNOHANG))
+			break;
+	}
+
+	/* Finish whatever the paced sweep did not reach */
+	for (; i < n; i++)
+		ip[i * stride] = i + 0xbeef0000;
+	/* A child that died reading the racing pages is a failure, not a zero */
+	child_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
+
+	ksft_print_msg("Check the parent sees only its own writes...");
+	for (i = 0; i < n; i++)
+		if (ip[i * stride] != i + 0xbeef0000)
+			break;
+	if (i == n)
+		success("OK");
+	else
+		fail("Fail: parent content");
+	ops->cleanup_area(p, hpage_pmd_size);
+	/* The parent's check must not bury the child's verdict */
+	if (exit_status != KSFT_FAIL)
+		exit_status = child_status;
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void madvise_collapse_existing_thps(struct collapse_context *c,
 					   struct mem_ops *ops)
 {
@@ -1700,6 +1797,9 @@ int main(int argc, char **argv)
 	TEST(collapse_max_ptes_shared, khugepaged_context, anon_ops);
 	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
 
+	TEST(collapse_fork_cow_race, khugepaged_context, anon_ops);
+	TEST(collapse_fork_cow_race, madvise_context, anon_ops);
+
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_write_file_read_ops);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

