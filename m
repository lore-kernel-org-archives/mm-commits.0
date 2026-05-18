Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7758D3955ED
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141580; cv=none; b=VW6oJMai8HTv90RvFK9QUFvZkEZogEVPDs98uTtpT5MhCWnMtmt15EDJloPSqvm2wcLMQ593Kj9OnGitb9nTnIL6SR9y+2lzojaV2b4fCsCiDY2D9r8sl+/grAt4DlSfo64ea/zF1P9ROjBrvLRTZZ5+uWy4YH3vERNmQ6pFdr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141580; c=relaxed/simple;
	bh=qFzm2ycoIxczm24/IDK62HnWC6+izLRMz8y3H1BCQIM=;
	h=Date:To:From:Subject:Message-Id; b=qItht+UyHap0dPcrE9Ih9m7qiUVpB0bWXEeZGb6KwbUSZJUP8v0iDNKeI6wZ//RuquhMNp+5Es+ybsSJMM4cCAm3Q6y3/0e5GZcnuOk0WztRjhuu3tWk+nr88X2rmizy/w/emeCdqCTx8YnDSuy1eIHT+Ep8AoVSpVVqgcjpDos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cguuyTsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cguuyTsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADE4C2BCB7;
	Mon, 18 May 2026 21:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141580;
	bh=qFzm2ycoIxczm24/IDK62HnWC6+izLRMz8y3H1BCQIM=;
	h=Date:To:From:Subject:From;
	b=cguuyTsvNIbpp3vkOKqMjz70QfvAydGiw272aj6TGkCRYuPXE/bms7ojs76NkDZS5
	 8ZLfiPehY8eTSHJ6Bf7k+FzBJipxviRSc1LDDnDk7h+JRY7d+0gTN2EZplRUmYCLX9
	 PGjrwKYJXj549zl7XvyM8mpRcTYvITResbb2hLFY=
Date: Mon, 18 May 2026 14:59:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch removed from -mm tree
Message-Id: <20260518215940.1ADE4C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: khugepaged perror fixup
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: khugepaged perror fixup
Date: Thu, 30 Apr 2026 11:22:30 -0400

disambiguate error message

Link: https://lore.kernel.org/3BFC4C26-1C97-40AA-B4B7-7472B9768565@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -446,7 +446,10 @@ static void file_fault_common(void *p, u
 		int madv_ops)
 {
 	if (madvise(((char *)p) + start, end - start, madv_ops)) {
-		perror("madvise(MADV_POPULATE_READ");
+		if (madv_ops == MADV_POPULATE_READ)
+			perror("madvise(MADV_POPULATE_READ");
+		else if (madv_ops == MADV_POPULATE_WRITE)
+			perror("madvise(MADV_POPULATE_WRITE");
 		exit(EXIT_FAILURE);
 	}
 }
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

