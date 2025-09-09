Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3DD1E89C
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 06:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757400342; cv=none; b=AcO8vb+1R+wwkDlvHCJEgxrjOYOTwuexGCaBqWjwC1WOdtxjaW3B2F+cP2w9u1P+RSoWNVQ8CvCNHbF5lmJVzucNDhjU8AeNZpdWabAT+gQjleVvNX3eE8YF6cAgd0G3ZcIutsN1OXFyGZhDNqbE1Cvr/+7i/OvU+B1ltbMSNqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757400342; c=relaxed/simple;
	bh=jiQaPie9ZtrL+UO1bjTBJT3ZT/M9H1Hb/M77Z7SnNwc=;
	h=Date:To:From:Subject:Message-Id; b=PTVbFFMTckLIH574PJu34zn2A9IUp5BXrZ5AsONVlofajdJAcbF6ZynewfdjGaqtWfiSk0/Y2WksrdAYUSPwOZW6+EQK/bAQtfW2bKS8ac9+shQf+boY1mUopX5Tt8uytjKB2l+GMAbKj2jYJ6VDoQbvn4ySeaoj06xaNqhztA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lp4KtzT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lp4KtzT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38697C4CEF4;
	Tue,  9 Sep 2025 06:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757400342;
	bh=jiQaPie9ZtrL+UO1bjTBJT3ZT/M9H1Hb/M77Z7SnNwc=;
	h=Date:To:From:Subject:From;
	b=Lp4KtzT+gGiXhFcvqwXCTzD9uao/NsP+CkWHWlWzokn3fqdXBn3qN8Gwxu+oAce+H
	 KoxdnS7OFXikUEiLLBXjI2Sl5ibk7BjMXcbYZ6n8KLnZbKBeBd8Rqlinc4TrQXPH57
	 SMGR691W1TPfasyyXkpzl5grRlbbfDSMMWs3kdvI=
Date: Mon, 08 Sep 2025 23:45:41 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-fix-regression-in-vrm-new_addr-check.patch removed from -mm tree
Message-Id: <20250909064542.38697C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: fix regression in vrm->new_addr check
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-regression-in-vrm-new_addr-check.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Llamas <cmllamas@google.com>
Subject: mm/mremap: fix regression in vrm->new_addr check
Date: Thu, 28 Aug 2025 14:26:56 +0000

Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
checks") moved the sanity check for vrm->new_addr from mremap_to() to
check_mremap_params().

However, this caused a regression as vrm->new_addr is now checked even
when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified.  In this
case, vrm->new_addr can be garbage and create unexpected failures.

Fix this by moving the new_addr check after the vrm_implies_new_addr()
guard.  This ensures that the new_addr is only checked when the user has
specified one explicitly.

Link: https://lkml.kernel.org/r/20250828142657.770502-1-cmllamas@google.com
Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-regression-in-vrm-new_addr-check
+++ a/mm/mremap.c
@@ -1774,15 +1774,18 @@ static unsigned long check_mremap_params
 	if (!vrm->new_len)
 		return -EINVAL;
 
-	/* Is the new length or address silly? */
-	if (vrm->new_len > TASK_SIZE ||
-	    vrm->new_addr > TASK_SIZE - vrm->new_len)
+	/* Is the new length silly? */
+	if (vrm->new_len > TASK_SIZE)
 		return -EINVAL;
 
 	/* Remainder of checks are for cases with specific new_addr. */
 	if (!vrm_implies_new_addr(vrm))
 		return 0;
 
+	/* Is the new address silly? */
+	if (vrm->new_addr > TASK_SIZE - vrm->new_len)
+		return -EINVAL;
+
 	/* The new address must be page-aligned. */
 	if (offset_in_page(vrm->new_addr))
 		return -EINVAL;
_

Patches currently in -mm which might be from cmllamas@google.com are


