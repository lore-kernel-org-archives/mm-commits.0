Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B311C701E
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274647; cv=none; b=sNuspwFaNp1Jlh2UUkjKVxwarr0anI7oBUG4bxIuRcHwR5qrTrpddSY5v97RCyiDUk31eGiwV9SDqEREWG6FOkUJeTPPHq/2c9W5Tg69/YB1LNxHPRWpImfhKcofLzqMW9d6C1Dj3lSp/RzBRlFwuo5yVF+FhD6TIzGdr0sHjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274647; c=relaxed/simple;
	bh=Cgj4McN13r2VoR3qt6738wRVnMstiDxrZmrAzK6Eng0=;
	h=Date:To:From:Subject:Message-Id; b=pTjR51Tzd2fIFwW3cGNAE4pUlzV/EHGa0y/NP471BWWQ2yALvwbrWKCrzUTOzzzZWKU06vOoT9nqM+xmzij5//0TEZXxSq+o2nZ+d7sky17jhPVNnvzWqWo2RiNWmGjQ55ze6kyPwAHCzFamc21xg143VWVxo0FHTUR2WSRwmoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ptkHZRp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ptkHZRp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F6EC4CEDD;
	Tue, 18 Mar 2025 05:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274647;
	bh=Cgj4McN13r2VoR3qt6738wRVnMstiDxrZmrAzK6Eng0=;
	h=Date:To:From:Subject:From;
	b=ptkHZRp3iBmLamrflhpNbgImm/EUm4DJYNrUp0Zj9YpBP7iR0TuZ87bnm8NP0nqMZ
	 Dq6HXnhXy5kZrovo1NVO/9Ma7icZkwR5c67va0EKkaRVS1SFTWbxxWZI62cpDaKQd4
	 kfsJ+P/SvD60KB36HWLlLmpJeOm9g01Pj9vEcR00=
Date: Mon, 17 Mar 2025 22:10:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch removed from -mm tree
Message-Id: <20250318051047.98F6EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: remove len parameter of madvise_do_behavior()
has been removed from the -mm tree.  Its filename was
     mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: remove len parameter of madvise_do_behavior()
Date: Wed, 12 Mar 2025 09:47:50 -0700

Because madise_should_skip() logic is factored out, making
madvise_do_behavior() calculates 'len' on its own rather then receiving it
as a parameter makes code simpler.  Remove the parameter.

Link: https://lkml.kernel.org/r/20250312164750.59215-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/madvise.c~mm-madvise-remove-len-parameter-of-madvise_do_behavior
+++ a/mm/madvise.c
@@ -1677,7 +1677,7 @@ static bool is_madvise_populate(int beha
 }
 
 static int madvise_do_behavior(struct mm_struct *mm,
-		unsigned long start, size_t len_in, size_t len, int behavior)
+		unsigned long start, size_t len_in, int behavior)
 {
 	struct blk_plug plug;
 	unsigned long end;
@@ -1686,7 +1686,7 @@ static int madvise_do_behavior(struct mm
 	if (is_memory_failure(behavior))
 		return madvise_inject_error(behavior, start, start + len_in);
 	start = untagged_addr_remote(mm, start);
-	end = start + len;
+	end = start + PAGE_ALIGN(len_in);
 
 	blk_start_plug(&plug);
 	if (is_madvise_populate(behavior))
@@ -1779,8 +1779,7 @@ int do_madvise(struct mm_struct *mm, uns
 	error = madvise_lock(mm, behavior);
 	if (error)
 		return error;
-	error = madvise_do_behavior(mm, start, len_in, PAGE_ALIGN(len_in),
-			behavior);
+	error = madvise_do_behavior(mm, start, len_in, behavior);
 	madvise_unlock(mm, behavior);
 
 	return error;
@@ -1812,8 +1811,7 @@ static ssize_t vector_madvise(struct mm_
 		if (madvise_should_skip(start, len_in, behavior, &error))
 			ret = error;
 		else
-			ret = madvise_do_behavior(mm, start, len_in,
-					PAGE_ALIGN(len_in), behavior);
+			ret = madvise_do_behavior(mm, start, len_in, behavior);
 		/*
 		 * An madvise operation is attempting to restart the syscall,
 		 * but we cannot proceed as it would not be correct to repeat
_

Patches currently in -mm which might be from sj@kernel.org are


