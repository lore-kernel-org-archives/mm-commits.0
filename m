Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F8821D3CC
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343284; cv=none; b=aP0e6ONtPRbVFdIxf0umCoISyBgiRCsUm7SojlWRw5YmpuEKX9iEdKe0tA/CcwuL8J38ZF9eY2MmxHmMhGhQLTozJip0Flf82i4/EODcCJfzZz+kPGK1uXUCWBWw9TgdMWRxfhhWl+FmkScVSagCU5GfD5/y1oDGhdK0nG8si3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343284; c=relaxed/simple;
	bh=5SVHlYn9c9JPHpUIiDptk4qqsjF9PhZSwe/HnUw23PA=;
	h=Date:To:From:Subject:Message-Id; b=JSdkiK4WiPe55J4f5Z9QSuduuiqu8kwXZwqhz1StXpvf1yF1bh3GuentFysdwIDSrUJjScmtlCnW4dDBEAc2MSXugPZYZZb96q4NXjUXWUDKbcZr7MKl7lwmPKEWlWH2M6AWfmCuTX9G5xXshsYHfk+8ouTD1EJ9LZ+DZhYoGt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FIgQjQnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FIgQjQnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2659C116D0;
	Mon, 17 Nov 2025 01:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343283;
	bh=5SVHlYn9c9JPHpUIiDptk4qqsjF9PhZSwe/HnUw23PA=;
	h=Date:To:From:Subject:From;
	b=FIgQjQnG1hCdefN6jDKNFzFfQpu384bQ74LFBP0bRDojS7hNqytwZgh+tzNKP0XV+
	 N85PGXoJRGAgKokdrbdOIrFXMW/YhiCe6MTjynHoWH2WCb4nqgVUHQvSKEr1RP/pj/
	 MtxGQtMuhDSXFNsHznLNemtQyRaSMkD0vq01pzug=
Date: Sun, 16 Nov 2025 17:34:43 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,vbabka@suse.cz,dev.jain@arm.com,david@redhat.com,zhangchujun@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-fix-missing-space-in-case-statement.patch removed from -mm tree
Message-Id: <20251117013443.C2659C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug: fix missing space in case statement
has been removed from the -mm tree.  Its filename was
     mm-debug-fix-missing-space-in-case-statement.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Subject: mm/debug: fix missing space in case statement
Date: Mon, 3 Nov 2025 14:59:09 +0800

In setup_vm_debug() , the case statement for 'p' option is written as
'case'p':' without a space between 'case' and the character constant. 
While this is syntactically valid C, it violates the Linux kernel coding
style, which requires a space after 'case'.  This patch adds the missing
space to comply with coding standards.

Link: https://lkml.kernel.org/r/20251103065910.2196-1-zhangchujun@cmss.chinamobile.com
Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-debug-fix-missing-space-in-case-statement
+++ a/mm/debug.c
@@ -327,7 +327,7 @@ static int __init setup_vm_debug(char *s
 
 	while (*str) {
 		switch (tolower(*str)) {
-		case'p':
+		case 'p':
 			__page_init_poisoning = true;
 			break;
 		default:
_

Patches currently in -mm which might be from zhangchujun@cmss.chinamobile.com are


