Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B891D7E4F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274644; cv=none; b=BQSA+a14Fmgl0ouApa+8SHTMgOdU926pX4sz9vmUHKBKuQdjOjcJtkqL4zKGi2ndkYTvq4ffmpXpfVQ2ch/NVAnBKRYYUbkwk2ld/hf0lK+oINLyfPvGlzhn+TIaARkl4y5y41BcemJZ4Jx0t2K2/RXPZuCR5NQSTdtVIAMTS9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274644; c=relaxed/simple;
	bh=1V8M/xo2c4qn8iDPXlMcD67lMU4gaxNpJ9/+zGsbk54=;
	h=Date:To:From:Subject:Message-Id; b=RUz5KkAXIGkG/rJdb59TQ8LIwcP93zma+symH3Y6Xx7Dq7K87tS3TjX3gLn07X3q/yzLPiV2+CeFHmt1lbg0QbuypLRA6AD3ydXcGbxzL50oX6KxQzC72gWpRcGvXPghIhW/gdLeRvxH3QPerhWDAZmCWfz7XrvKAYRv6mfdahQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CCrFPBfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CCrFPBfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF983C4CEDD;
	Tue, 18 Mar 2025 05:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274644;
	bh=1V8M/xo2c4qn8iDPXlMcD67lMU4gaxNpJ9/+zGsbk54=;
	h=Date:To:From:Subject:From;
	b=CCrFPBfz4jRwinhTLZa2HjBjRX+Tix8299EWk7Tl30RV1TKzj+ggwPfSFdl6KsriK
	 /owrj0op8sHTMQ8VuJ6vvzkopBFc3kBDlqvJFzzyBlx49Ie3UY4gjU55fmqoOWKqaS
	 lL3wbSpq0+ouf23L7DSi63qOtBYPSFRyUPguXXSM=
Date: Mon, 17 Mar 2025 22:10:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch removed from -mm tree
Message-Id: <20250318051043.EF983C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: use is_memory_failure() from madvise_do_behavior()
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: use is_memory_failure() from madvise_do_behavior()
Date: Wed, 12 Mar 2025 09:47:47 -0700

Patch series "mm/madvise: cleanup requests validations and classifications".

Cleanup madvise entry level code for cleaner request validations and
classifications.


This patch (of 4):

To reduce redundant open-coded checks of CONFIG_MEMORY_FAILURE and
MADV_{HWPOISON,SOFT_OFFLINE} in madvise_[un]lock(), is_memory_failure() is
introduced.  madvise_do_behavior() is still doing the same open-coded
check, though.  Use is_memory_failure() instead.

To avoid build failure on !CONFIG_MEMORY_FAILURE case, implement an empty
madvise_inject_error() under the config.  Also move the definition of
is_memory_failure() inside #ifdef CONFIG_MEMORY_FAILURE clause for
madvise_inject_error() definition, to reduce duplicated ifdef clauses.

Link: https://lkml.kernel.org/r/20250312164750.59215-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250312164750.59215-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   49 +++++++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-is_memory_failure-from-madvise_do_behavior
+++ a/mm/madvise.c
@@ -1392,7 +1392,32 @@ static int madvise_inject_error(int beha
 
 	return 0;
 }
-#endif
+
+static bool is_memory_failure(int behavior)
+{
+	switch (behavior) {
+	case MADV_HWPOISON:
+	case MADV_SOFT_OFFLINE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+#else
+
+static int madvise_inject_error(int behavior,
+		unsigned long start, unsigned long end)
+{
+	return 0;
+}
+
+static bool is_memory_failure(int behavior)
+{
+	return false;
+}
+
+#endif	/* CONFIG_MEMORY_FAILURE */
 
 static bool
 madvise_behavior_valid(int behavior)
@@ -1569,24 +1594,6 @@ int madvise_set_anon_name(struct mm_stru
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 
-#ifdef CONFIG_MEMORY_FAILURE
-static bool is_memory_failure(int behavior)
-{
-	switch (behavior) {
-	case MADV_HWPOISON:
-	case MADV_SOFT_OFFLINE:
-		return true;
-	default:
-		return false;
-	}
-}
-#else
-static bool is_memory_failure(int behavior)
-{
-	return false;
-}
-#endif
-
 static int madvise_lock(struct mm_struct *mm, int behavior)
 {
 	if (is_memory_failure(behavior))
@@ -1640,10 +1647,8 @@ static int madvise_do_behavior(struct mm
 	unsigned long end;
 	int error;
 
-#ifdef CONFIG_MEMORY_FAILURE
-	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
+	if (is_memory_failure(behavior))
 		return madvise_inject_error(behavior, start, start + len_in);
-#endif
 	start = untagged_addr_remote(mm, start);
 	end = start + len;
 
_

Patches currently in -mm which might be from sj@kernel.org are


