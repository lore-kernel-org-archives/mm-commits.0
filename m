Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBD8198E75
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 03:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741233331; cv=none; b=MuGFbK01+bVJ1DNGT0JKe0sFxy5mREYbKKnOwY8qwUvm1u1qjctm1qBlmDAJeoFcUTuecn17NpLy4kzFumHg64y3tq/pYMLmSpJyVY5luO0a8iKoPGo+3mWj5xxfGYVEA7jEsngFZ7nvBVdWQfAO/EzaWDZ4nE0PLz6YIeyEqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741233331; c=relaxed/simple;
	bh=jTO6EKruUPpdntQqnu//NqLxTjadF0K94utnSuOpy7A=;
	h=Date:To:From:Subject:Message-Id; b=QpM0/vGzvT2bAtDJ9bTSJc6zU+DJHhw3v+yf1/wFDOHIBmxap317rGPOYFuYCFrNdDovQhfaZDUoMuesfiVsaMbnnbDpPKf/1bv3BlMI9QCEoXs+/01Qx3UvDyeJYn5e8Ut80dcwlgiEBbuWeJkqWUK2bFaSheJcH2U72dQqvSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCrqgr9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCrqgr9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D5AC4CEE4;
	Thu,  6 Mar 2025 03:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741233331;
	bh=jTO6EKruUPpdntQqnu//NqLxTjadF0K94utnSuOpy7A=;
	h=Date:To:From:Subject:From;
	b=yCrqgr9nGQHYz1PYRp/dM2iNXnmfq9bP9y8ds9yQSkdwXLqh3REFc6yoprS5YWG4V
	 /KTVSzFLj2tmycBe3k+DuLpIO5MoN9W40cXxYjtgk4GwQU7UmAKiA9GwEYXm44OGaH
	 RZotVgB8O9q0RqAVbcyannKaUFMYiaPx+jLKEqqQ=
Date: Wed, 05 Mar 2025 19:55:30 -0800
To: mm-commits@vger.kernel.org,bgeffon@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-finish_fault-handling-for-large-folios-v3.patch removed from -mm tree
Message-Id: <20250306035531.20D5AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-finish_fault-handling-for-large-folios-v3
has been removed from the -mm tree.  Its filename was
     mm-fix-finish_fault-handling-for-large-folios-v3.patch

This patch was dropped because it was folded into mm-fix-finish_fault-handling-for-large-folios.patch

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: mm-fix-finish_fault-handling-for-large-folios-v3
Date: Thu, 27 Feb 2025 08:32:36 -0500

tweak whitespace

Link: https://lkml.kernel.org/r/20250227133236.1296853-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-finish_fault-handling-for-large-folios-v3
+++ a/mm/memory.c
@@ -5229,7 +5229,7 @@ fallback:
 	 * inflating the RSS of the process.
 	 */
 	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
-			unlikely(needs_fallback)) {
+	    unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-fix-finish_fault-handling-for-large-folios.patch

