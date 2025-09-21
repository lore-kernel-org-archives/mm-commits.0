Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B7628DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489843; cv=none; b=htkSFB90q/aSuho7b8dCEPDz6eLvLp/MIXhQniYJ5+zGFQ/dmY9yud1Gm2Kj1xgTVHANK/ObL4dxAAs19zWaxb4ux4h5ojpJo358uP6JJWqLtaPQGcKYWl/ByBLXIst+saIy/o/8ONUczFiHLTY7jxsgvQAl2T7YgFeOWXxqYcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489843; c=relaxed/simple;
	bh=5pV5qXZFY56Xr+yJuHziJ3Aet2QXmn/TCHaPx2YZmEg=;
	h=Date:To:From:Subject:Message-Id; b=K2QGbaxTCuxerg0GFz+eUjkEnuTbA+Vm9QGvhkhgduACVBWyEdp+diMjJhpUhWXNm8kSFjFaHoVoRwTKK/Magy0voYswecpSOHho00qZm4iYfFpXD7fOSY7QQorujZeT/ubTMhxABfVKkXYy3Q3EFhGhT1IPYfrBwmiXtO3fBP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JoU3ykU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JoU3ykU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71D2C4CEE7;
	Sun, 21 Sep 2025 21:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489842;
	bh=5pV5qXZFY56Xr+yJuHziJ3Aet2QXmn/TCHaPx2YZmEg=;
	h=Date:To:From:Subject:From;
	b=JoU3ykU1xfhz4ZXxR2BZzYY+zqAwXrJGp2hCTdRuRCvkLn5C0f9dMNTleLJxbKi4h
	 MzZUquulBxwh7YoG5dmJMl95doeK8CHU/wLnLz2MvoowqRQNMW1IDPeryCKbI+zVA9
	 jMSR2Y3lcoOCJrwJf2zzYYgXAIjUKacZp5SPDmL4=
Date: Sun, 21 Sep 2025 14:24:02 -0700
To: mm-commits@vger.kernel.org,martin.petersen@oracle.com,lorenzo.stoakes@oracle.com,James.Bottomley@HansenPartnership.com,bvanassche@acm.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scsi-scsi_lib-drop-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212402.B71D2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scsi: scsi_lib: drop nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     scsi-scsi_lib-drop-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: scsi: scsi_lib: drop nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:51 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-31-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/scsi_lib.c~scsi-scsi_lib-drop-nth_page-usage-within-sg-entry
+++ a/drivers/scsi/scsi_lib.c
@@ -3148,8 +3148,7 @@ void *scsi_kmap_atomic_sg(struct scatter
 	/* Offset starting from the beginning of first page in this sg-entry */
 	*offset = *offset - len_complete + sg->offset;
 
-	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg_page(sg), (*offset >> PAGE_SHIFT));
+	page = sg_page(sg) + (*offset >> PAGE_SHIFT);
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
_

Patches currently in -mm which might be from david@redhat.com are


