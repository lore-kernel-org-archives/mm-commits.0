Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F641214A89
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188439; cv=none; b=VS1xuKlcO5dMcPCrebGf6rygLqE0E/aKcKcqpRQ6mMcGkKFBcqVK1TXE1LBn46D04e0aqLtE4zYlf+l3/O8AOd95BukwTFJxYoepUXgsSQjt3IyRbUWyD1rLzkkceblq7JZHCTaj4tJSofeRNCC/5+edOjjI/gQMDW5XdoEWAhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188439; c=relaxed/simple;
	bh=vz3OHwq+Ih+qSYTWISPbOM3Zao2jo62vBA+bFc6pRYM=;
	h=Date:To:From:Subject:Message-Id; b=rdf/JKBihRy5LFVTD88D1v7wD1do4LCU17HPVbH+etvyYGPsRd8ga4/vmZ62BBrf9tnzpQnFS4e00gSnsDfzthYXcbaenYHmGR+pFmhq2fFt7vpRHAKozMcHf2p5H7kc9VnO6l5/1N6GIjL8rqsLljpoYes8CkHHcXBCwQnCTSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S3Ym/xmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S3Ym/xmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04289C4CEEC;
	Mon, 17 Mar 2025 05:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188439;
	bh=vz3OHwq+Ih+qSYTWISPbOM3Zao2jo62vBA+bFc6pRYM=;
	h=Date:To:From:Subject:From;
	b=S3Ym/xmH34jF1QFXSQubmKSdawViFXlIfPB/8Y/nblDm3HaU+BQesBa6SViZZkjYQ
	 LXbpbeR+0/qMrPlMZC28jM0HLRn2qaavDAyHXc+H/N88MjdEpVbS405stofFMISymL
	 3adcNEHEqhBa4DLaIPIM5zJ61TN9aBaJ+oCHbgTk=
Date: Sun, 16 Mar 2025 22:13:58 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch removed from -mm tree
Message-Id: <20250317051359.04289C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip uffd-wp-mremap if userfaultfd not available
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: skip uffd-wp-mremap if userfaultfd not available
Date: Tue, 11 Mar 2025 13:18:14 +0000

It's obvious that this should fail in that case, but still, save the
reader the effort of figuring out that they've run into this by just
SKIPping

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-3-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-wp-mremap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -182,7 +182,10 @@ static void test_one_folio(size_t size,
 
 	/* Register range for uffd-wp. */
 	if (userfaultfd_open(&features)) {
-		ksft_test_result_fail("userfaultfd_open() failed\n");
+		if (errno == ENOENT)
+			ksft_test_result_skip("userfaultfd not available\n");
+		else
+			ksft_test_result_fail("userfaultfd_open() failed\n");
 		goto out;
 	}
 	if (uffd_register(uffd, mem, size, false, true, false)) {
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

