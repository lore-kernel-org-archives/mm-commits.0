Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D29C155A4F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 20:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482815; cv=none; b=HkvhmWpu9+A8s3yL1KfKFFcpkLVauB8ZwvXtpQIIK+2gOT0qRo+p+y6jwGk66n1X7ri8aoQ5rppwdtfJ9RPegcwgDruPMZkUJTDujsYkWh+BSo00A49eEBoDXoALdOg2y5SCiA9Tka1pZmR7rLJROIj95oY1fCFydbIiikiqioI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482815; c=relaxed/simple;
	bh=E0Lk4uTvN1wtwRlDlZHfcBxfXGq6JuWqkkQP/mjXzqY=;
	h=Date:To:From:Subject:Message-Id; b=SuqcxQNKQhxOqyF72sTi9ohJ9GXvDeS+NAXFxkPwUKLn08wrkJor6emVnvzAW93b8iaMuqD5wmkOEmAzXy1mPi+0xcD015q8H6Hk18DXMyvI6yU6U/t/a2FZ4A9DiwRc24PJYycVoHyHneLAm4IcmEeZH3ixrBRW8r/T7bNLu+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPP4MGjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPP4MGjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07664C4CEC2;
	Wed,  4 Sep 2024 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725482815;
	bh=E0Lk4uTvN1wtwRlDlZHfcBxfXGq6JuWqkkQP/mjXzqY=;
	h=Date:To:From:Subject:From;
	b=sPP4MGjNgrdjffIiEfhMilT4KysAvVvKOUpgXIlGZWkMxxapjx2g+zZO5JK9MOnWm
	 8kSBP7jnNFaA7Mcb2qtHu7B7+S14TU1zFC/Q3KSeQtyBs3gVpmx4NbaDOFkK8UFGd9
	 NbgaAGSSoGRH3PmWm9uyfBde5z0z682hKa3kQUAc=
Date: Wed, 04 Sep 2024 13:46:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-tidy-up-shmem-mthp-controls-and-stats-fix.patch added to mm-unstable branch
Message-Id: <20240904204655.07664C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-tidy-up-shmem-mthp-controls-and-stats-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-tidy-up-shmem-mthp-controls-and-stats-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-tidy-up-shmem-mthp-controls-and-stats-fix.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm-tidy-up-shmem-mthp-controls-and-stats-fix
Date: Wed, 4 Sep 2024 11:47:29 +0100

Link: https://lkml.kernel.org/r/f7ced14c-8bc5-405f-bee7-94f63980f525@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-tidy-up-shmem-mthp-controls-and-stats-fix
+++ a/mm/huge_memory.c
@@ -606,8 +606,6 @@ static struct attribute *anon_stats_attr
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
-	&split_attr.attr,
-	&split_failed_attr.attr,
 	&split_deferred_attr.attr,
 	NULL,
 };
@@ -636,6 +634,8 @@ static struct attribute *any_stats_attrs
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
+	&split_attr.attr,
+	&split_failed_attr.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-cleanup-count_mthp_stat-definition.patch
mm-tidy-up-shmem-mthp-controls-and-stats.patch
mm-tidy-up-shmem-mthp-controls-and-stats-fix.patch

