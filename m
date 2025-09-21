Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD7028DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489827; cv=none; b=Qju+rI8X3CFMobc9TzSrxaPkdsUetS9zlCwyVHJNexWFFKLYSI1w9xCSjILTAA8/Xo+LlKv3znNhGWirqq52pVuLEY61qdYHN5RUA1b98O/QyggJrFpSHiBxPKUoTgXpRtV1Do9OLPOSsJqg70DwvVShQXNToKg4Kp7DPL9Hwwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489827; c=relaxed/simple;
	bh=mniBv6Oa0JJxqNnpHRqN4Jt3w8hlXbFAYG0d7muPJ6Y=;
	h=Date:To:From:Subject:Message-Id; b=vERErg8hGj/j+1i0junDS77xWcdwtSIOMuWGQjX4A8CaMLDCKI0QwfZrSL/sakcsGXfhNELGkZAnrDII4tnx2XS1tHHpbi7PupMd/qzoO3P1kPfB7pNheSLB8NKJ+PtGfSUvoMUjvgPl42ebEfLhZDwaKxEFIBTfuV9TFs059zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nHGW95QL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nHGW95QL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF76C4CEE7;
	Sun, 21 Sep 2025 21:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489827;
	bh=mniBv6Oa0JJxqNnpHRqN4Jt3w8hlXbFAYG0d7muPJ6Y=;
	h=Date:To:From:Subject:From;
	b=nHGW95QL8mDIys2Jhb7EIS2zp4RC1JeDiudTs+P05QdTQpWJJ0fSyRd1Ov+apZftX
	 sFQp0XRAYIbID7u3m2/agViLUX1/UzwjjrWGFxt72DAahmchnO3qAWNmJjBIFFWePr
	 QasXzURqTVFRP9hC7346fUotkqXKPtazloQFmFek=
Date: Sun, 21 Sep 2025 14:23:46 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-drop-nth_page-usage-within-folio-in-folio_walk_start.patch removed from -mm tree
Message-Id: <20250921212347.4FF76C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-drop-nth_page-usage-within-folio-in-folio_walk_start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
Date: Mon, 1 Sep 2025 17:03:38 +0200

It's no longer required to use nth_page() within a folio, so let's just
drop the nth_page() in folio_walk_start().

Link: https://lkml.kernel.org/r/20250901150359.867252-18-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-drop-nth_page-usage-within-folio-in-folio_walk_start
+++ a/mm/pagewalk.c
@@ -1004,7 +1004,7 @@ not_found:
 found:
 	if (expose_page)
 		/* Note: Offset from the mapped page, not the folio start. */
-		fw->page = nth_page(page, (addr & (entry_size - 1)) >> PAGE_SHIFT);
+		fw->page = page + ((addr & (entry_size - 1)) >> PAGE_SHIFT);
 	else
 		fw->page = NULL;
 	fw->ptl = ptl;
_

Patches currently in -mm which might be from david@redhat.com are


