Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05ED913E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313731; cv=none; b=s01L0M2JvlC+f8TuWpFCdGdKyBHN+2lAkqnY6BfThGuLzIFoNwJT0aj/UTkE8/zTv7Jr3ZpzxFCzwcwn7xU0LXzyvDSJeFACPzcUSAfoaQcSdkx/S8v283x6RS+LwM/2o/JTQPuAJ2t4KuQ0+sOoCfNa8lx0shzAZTKpEYoxMiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313731; c=relaxed/simple;
	bh=QnaYDem/sfZ26hciBrTWQ899lV7ayicuALosxtfmeNc=;
	h=Date:To:From:Subject:Message-Id; b=TPoIXiR5NaQw7oVQERnnoZRrlm7+4YElcht7W5wInFbAW5ro/vSvi41SaTwN0MOuekw0taEpTROeYWH0AByGgShrwlLOBQDhMxoRf/meiBhlzb8a1O72rpU5fqSVkkUP5gdpIPJAEk018dMbe9EPJFIVjWVVshSpP1BZAOmhDEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e9OHZZAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e9OHZZAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF089C4CED0;
	Mon, 11 Nov 2024 08:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313730;
	bh=QnaYDem/sfZ26hciBrTWQ899lV7ayicuALosxtfmeNc=;
	h=Date:To:From:Subject:From;
	b=e9OHZZAD+BfpAM80zS/540WpG3BmZrYBpw6O2ngd/mZt7mAZIoF6s/oZ5LH5KgDTP
	 yT36r/YByXEzprZUg6/fLOiA4sgMsfor/aDMT+IL+pTanf946h5K+kXrTyNzUKKrce
	 mZk2KDwU1rUXV+kJ+ixhl4AXr/9hFuhINXBzK8SQ=
Date: Mon, 11 Nov 2024 00:28:50 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-strscpy-instead-of-strcpy.patch removed from -mm tree
Message-Id: <20241111082850.CF089C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: use strscpy() instead of strcpy()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-strscpy-instead-of-strcpy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maíra Canal <mcanal@igalia.com>
Subject: mm: huge_memory: use strscpy() instead of strcpy()
Date: Fri, 1 Nov 2024 13:54:09 -0300

Replace strcpy() with strscpy() in mm/huge_memory.c

strcpy() has been deprecated because it is generally unsafe, so help to
eliminate it from the kernel source.

Link: https://github.com/KSPP/linux/issues/88
Link: https://lkml.kernel.org/r/20241101165719.1074234-7-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-strscpy-instead-of-strcpy
+++ a/mm/huge_memory.c
@@ -969,7 +969,7 @@ static int __init setup_thp_anon(char *s
 
 	if (!str || strlen(str) + 1 > PAGE_SIZE)
 		goto err;
-	strcpy(str_dup, str);
+	strscpy(str_dup, str);
 
 	always = huge_anon_orders_always;
 	madvise = huge_anon_orders_madvise;
@@ -4167,7 +4167,7 @@ static ssize_t split_huge_pages_write(st
 
 		tok = strsep(&buf, ",");
 		if (tok) {
-			strcpy(file_path, tok);
+			strscpy(file_path, tok);
 		} else {
 			ret = -EINVAL;
 			goto out;
_

Patches currently in -mm which might be from mcanal@igalia.com are


