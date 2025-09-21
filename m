Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2144E28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489844; cv=none; b=nVKkV0HsSBaeUTyo1lH7Pm0Kee7qCnJ1Y4X+TTDrsOPIiHxa0+6FVIiLbtfZNVD/GwBDpocdgQ7sVaCcSl9MRYNVTApwwCjXm9GBZaToDAfbp0xqjilNFN6U1+L949PCylYjA859FEWsjvnjY/faABN/qyVGafZX7C6IVROnXEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489844; c=relaxed/simple;
	bh=iKN6Tfu1BKYGulVy4fT0wfoGRalcgV2bLO/zECxU1Gc=;
	h=Date:To:From:Subject:Message-Id; b=nboxFPw8loQ3FQFHDRCsoixHjR+BdOCXlfgPVkJHb1QTVVDDsJJpH3EshunK4TxqgoDH5vcUv/Hd8L3ZE0Ev/TJe2Gny0H8doKbmo76gxgp/XrMKDelR+BYseuxJhIpEBkOLmplBwmfuP7aSrT46LcmJGRXLJXT0sWAkkXs0ZXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cxSuLvbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cxSuLvbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA115C4CEE7;
	Sun, 21 Sep 2025 21:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489844;
	bh=iKN6Tfu1BKYGulVy4fT0wfoGRalcgV2bLO/zECxU1Gc=;
	h=Date:To:From:Subject:From;
	b=cxSuLvbXAYNZ8NjZ4pFVLPsEDcUd8lRmoTBtMZJNXVduA6BCtCEDmzYX6sCBokV7k
	 WGD5BkmV6NVmkylfbmAI9TJjVJUZIem6cZKpH9JSrBDzyE8mde65EQenofJTmeM16e
	 FGJrnRqJXjSJOMJLABD6y2kaaOzqgj73hRZuOStA=
Date: Sun, 21 Sep 2025 14:24:03 -0700
To: mm-commits@vger.kernel.org,martin.petersen@oracle.com,lorenzo.stoakes@oracle.com,James.Bottomley@HansenPartnership.com,dgilbert@interlog.com,bvanassche@acm.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scsi-sg-drop-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212403.EA115C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scsi: sg: drop nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     scsi-sg-drop-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: scsi: sg: drop nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:52 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-32-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/sg.c~scsi-sg-drop-nth_page-usage-within-sg-entry
+++ a/drivers/scsi/sg.c
@@ -1235,8 +1235,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
 		if (offset < len) {
-			struct page *page = nth_page(rsv_schp->pages[k],
-						     offset >> PAGE_SHIFT);
+			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
 			get_page(page);	/* increment page count */
 			vmf->page = page;
 			return 0; /* success */
_

Patches currently in -mm which might be from david@redhat.com are


