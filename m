Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12CC28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489837; cv=none; b=KmWFev+OGp3MceA+2PJj1uqZ84NqJZVoK8occUEJPEMosEhiJ4DbQGs8C0Y5ZtJm0dNHqGXjPveiCFQisArzyb+wKkg85LQ7ARvB3m+ugjO1dY67fGx8HK11tDYYu78iPCgxe5ncb3KXztY+wI1U4Iqs6scgvWvy39IqUc8AqRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489837; c=relaxed/simple;
	bh=dSS/EceHZt27DWnk/UskBS176nXBcq0nIHnk7BfRItc=;
	h=Date:To:From:Subject:Message-Id; b=s6mii+dAqKjjINvWTBQy7FW2q0OAorjpIPkfRucMnUM8hxMH7ERfvhrSdQVDgS8waBQ9QCnPHE89x1eS5e7oKWZF1FhUUj+L0Cx9bLwVFGHrCEq1Pm5UZIPipclRrdLssuQkUvp/KqSoX/3QwASyXWo2epEJif2vDxnLWHfRCY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1FjY2/I9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1FjY2/I9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D57C4CEE7;
	Sun, 21 Sep 2025 21:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489836;
	bh=dSS/EceHZt27DWnk/UskBS176nXBcq0nIHnk7BfRItc=;
	h=Date:To:From:Subject:From;
	b=1FjY2/I9IFyq2qbhVXtZUh8DsiOXovgyfRaYXRHueJbUuxLeIKCKvt/C9GQqru5WG
	 BBm9fhJDkZs5cpX49fXZKMjCNMa3wQcOAKFJdufWC382J2SfCd4LAHaWqdwNsFc/e6
	 MT507UTc3Z2lzKyWhcel9Z05zVzeC9v5f9t7C5Ms=
Date: Sun, 21 Sep 2025 14:23:56 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,dlemoal@kernel.org,cassel@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ata-libata-sff-drop-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212356.B7D57C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ata: libata-sff: drop nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     ata-libata-sff-drop-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: ata: libata-sff: drop nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:46 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-26-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/ata/libata-sff.c~ata-libata-sff-drop-nth_page-usage-within-sg-entry
+++ a/drivers/ata/libata-sff.c
@@ -614,7 +614,7 @@ static void ata_pio_sector(struct ata_qu
 	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset >> PAGE_SHIFT;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
@@ -631,7 +631,7 @@ static void ata_pio_sector(struct ata_qu
 		unsigned int split_len = PAGE_SIZE - offset;
 
 		ata_pio_xfer(qc, page, offset, split_len);
-		ata_pio_xfer(qc, nth_page(page, 1), 0, count - split_len);
+		ata_pio_xfer(qc, page + 1, 0, count - split_len);
 	} else {
 		ata_pio_xfer(qc, page, offset, count);
 	}
@@ -751,7 +751,7 @@ next_sg:
 	offset = sg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset >> PAGE_SHIFT;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
_

Patches currently in -mm which might be from david@redhat.com are


