Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8E5372EF0;
	Sat, 18 Apr 2026 07:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499145; cv=none; b=WN6f7OqylHgsaPmmNGxQLh05ZXUEOC915XLTCP4e6b1ygvnjbGLuCluydhyTBaap7r6Ud3KaciFvALDV5JQisiPSFZb9M3jzsWh5x39lDqzpp1wgTOgovexoVjafkRHjsngHEiDa86gFxCnU328HKknSdNQB2A/HAj1kHtDS6fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499145; c=relaxed/simple;
	bh=5Ulg4ZRJR7KeEkFCnKYLGQqMRIE9tybhqc0WFbsZFlM=;
	h=Date:To:From:Subject:Message-Id; b=ejdHa4iBlfaPOezZEe+8RqNrXvpL3guGisCnQvEFiwclpwc8uP6TCnYeUei+wmfnwclcFOHjQHHLKJOVLCBrRWt0a1GJ0GToPeS3JX66Gnxb+abeJL9Yg9Vzm0torAccwKx4bzntSupfLlqe1dVX+CnXSPP4KkVr4Esi/aznH+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yDYdvI5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yDYdvI5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26F7C19424;
	Sat, 18 Apr 2026 07:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499145;
	bh=5Ulg4ZRJR7KeEkFCnKYLGQqMRIE9tybhqc0WFbsZFlM=;
	h=Date:To:From:Subject:From;
	b=yDYdvI5StVG+CMaJE/flVtJ3ga6uALftBF+3825aCVqVa31JzgOC54V5GGtea7GZ0
	 vLEIDU4Vu3Xh52cMOccOLF9LqLD15YEVoiQgjJLz6+R58fVSb+TO7OAZNA/deF+FT0
	 qKtHDUoW7s838+LSZQRmn/Dc5rYCCqnBwMrY91vw=
Date: Sat, 18 Apr 2026 00:59:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,fvdl@google.com,david@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-early-boot-crash-on-parameters-without-=-separator.patch removed from -mm tree
Message-Id: <20260418075904.C26F7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix early boot crash on parameters without '=' separator
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-early-boot-crash-on-parameters-without-=-separator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/hugetlb: fix early boot crash on parameters without '=' separator
Date: Thu, 9 Apr 2026 12:54:40 +0200

If hugepages, hugepagesz, or default_hugepagesz are specified on the
kernel command line without the '=' separator, early parameter parsing
passes NULL to hugetlb_add_param(), which dereferences it in strlen() and
can crash the system during early boot.

Reject NULL values in hugetlb_add_param() and return -EINVAL instead.

Link: https://lore.kernel.org/20260409105437.108686-4-thorsten.blum@linux.dev
Fixes: 5b47c02967ab ("mm/hugetlb: convert cmdline parameters from setup to early")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-early-boot-crash-on-parameters-without-=-separator
+++ a/mm/hugetlb.c
@@ -4226,6 +4226,9 @@ static __init int hugetlb_add_param(char
 	size_t len;
 	char *p;
 
+	if (!s)
+		return -EINVAL;
+
 	if (hugetlb_param_index >= HUGE_MAX_CMDLINE_ARGS)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


