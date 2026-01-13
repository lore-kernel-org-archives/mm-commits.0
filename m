Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BEA30AD0A;
	Tue, 13 Jan 2026 05:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280996; cv=none; b=blhdmShGwgeyqFLDgA3YlHneasC3ijUTkzBSwFaniO5xRPbhGQLTPsMRAkE1c/lasNz/KirS+0KKpLxr/YcXHAxt80YrZFg0WcOYunOBCsFipyfNEkXGoBF1qjvefXXfpSs8aB7DWcUxNrSVHHT2mSkUugzyDy7+ukVaO4UCt9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280996; c=relaxed/simple;
	bh=K7c1+ZuLcM1wU5Vlzk2CrNF2Qzgfa8dbHn4Cq+BIWF8=;
	h=Date:To:From:Subject:Message-Id; b=sq9RRH39IY0hDNM/4B1ek9/udB+FqiVluIVV97nBfFq7lrWFZDWN/p1FW6KD6tTpKWMVimzkEH7BPeMoRU9AqmGQ4sqScC4+Dih/xZZZiWh0ri4kqOe7eT2ROsGKn0w05xzIgTS/kqEX3ncpvWYpyWuFhuqjRpqAfvnlXSsn8OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sjDmuMIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sjDmuMIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82699C116C6;
	Tue, 13 Jan 2026 05:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280996;
	bh=K7c1+ZuLcM1wU5Vlzk2CrNF2Qzgfa8dbHn4Cq+BIWF8=;
	h=Date:To:From:Subject:From;
	b=sjDmuMIYp/yRUg+fIa3CuvrOFD4gsNbVpBhJncmPP+tHEuld/RyOnlUSg/NLrarTn
	 7zENC934kGMlMqrDoJUIxEMybeXXFO2fZSnQExIFJlKttHfnwSllJR7nH24Ehfyn10
	 VbgmbJB7+RTI0dwN4fUtxlIopEMSKdEDuXyXw0r0=
Date: Mon, 12 Jan 2026 21:09:55 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,Liam.Howlett@oracle.com,liam.howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,broonie@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch removed from -mm tree
Message-Id: <20260113050956.82699C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests: fix gup_longterm for unknown fs
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: fix gup_longterm for unknown fs
Date: Tue, 6 Jan 2026 15:45:47 +0000

Commit 66bce7afbaca ("selftests/mm: fix test result reporting in
gup_longterm") introduced a small bug causing unknown filesystems to
always result in a test failure.

This is because do_test() was updated to use a common reporting path, but
this case appears to have been missed.

This is problematic for e.g.  virtme-ng which uses an overlayfs file
system, causing gup_longterm to appear to fail each time due to a test
count mismatch:

	# Planned tests != run tests (50 != 46)
	# Totals: pass:24 fail:0 xfail:0 xpass:0 skip:22 error:0

The fix is to simply change the return into a break.

Link: https://lkml.kernel.org/r/20260106154547.214907-1-lorenzo.stoakes@oracle.com
Fixes: 66bce7afbaca ("selftests/mm: fix test result reporting in gup_longterm")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~tools-testing-selftests-fix-gup_longterm-for-unknown-fs
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -179,7 +179,7 @@ static void do_test(int fd, size_t size,
 		if (rw && shared && fs_is_unknown(fs_type)) {
 			ksft_print_msg("Unknown filesystem\n");
 			result = KSFT_SKIP;
-			return;
+			break;
 		}
 		/*
 		 * R/O pinning or pinning in a private mapping is always
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

