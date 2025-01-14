Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4340B1C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836937; cv=none; b=rLFGI8FFAx4dc1g3LmpajWlyMl8uEbe/wuPK+Rb/QzXvq2+Kc08Eer9eu0z3lWQRqOn7wRmQTF5US1hMV/1MFhC7qLGGGKmtRqUynpT44K0yybcoxbM3q0CLVxKfUjwsNqr+Aec6tbnf7XjcfcTKk5M1TabZKrn08/6JFCOGxIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836937; c=relaxed/simple;
	bh=h7vhV+R7j2D3lyCJ/lFbsJBVQrP1pffKUPuQFhYjNEQ=;
	h=Date:To:From:Subject:Message-Id; b=Jth3W57210YjgW/KMoAJDoedsRcU00dR1XLaNlUdIS5VURSLDByXGB3OdkxRBd8GZr/RK/NXWxAS6oZXKZXiErfDMWvCMQvTXNY09qUDrFM0P3Tt328NF87okCFafwBNm+H+fxcoJz7QKjoNjApfQO34AnuzHvb5YUYHn34Q06w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uDqnRTp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uDqnRTp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B09C4CEDD;
	Tue, 14 Jan 2025 06:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836937;
	bh=h7vhV+R7j2D3lyCJ/lFbsJBVQrP1pffKUPuQFhYjNEQ=;
	h=Date:To:From:Subject:From;
	b=uDqnRTp6YzoUrLzj49nd/izLgiiQoeYgoZoGOSza9eyb8d1sCsMKO19TK83YFKRCx
	 zleI5mpFn+A/hcsZuExyZ1qeiePrrdbJbcs+VY4fU2qevKpENSBBjPNcH5ReXcWLQV
	 3hrUB2/5rpXPMS2fHXE5OZPXCBiYdfTYnZkknQ/4=
Date: Mon, 13 Jan 2025 22:42:16 -0800
To: mm-commits@vger.kernel.org,295107659@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-type-of-cma_area_count-to-unsigned-int.patch removed from -mm tree
Message-Id: <20250114064217.18B09C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change type of cma_area_count to unsigned int
has been removed from the -mm tree.  Its filename was
     mm-change-type-of-cma_area_count-to-unsigned-int.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiale Yang <295107659@qq.com>
Subject: mm: change type of cma_area_count to unsigned int
Date: Wed, 20 Nov 2024 11:01:35 +0000

Prefer 'unsigned int' over plain 'unsigned'. Also make it
consistent with mm/cma.c

Link: https://lkml.kernel.org/r/tencent_1E5E3AA25C261196D8C1F7097F130E382008@qq.com
Signed-off-by: Jiale Yang <295107659@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.h~mm-change-type-of-cma_area_count-to-unsigned-int
+++ a/mm/cma.h
@@ -36,7 +36,7 @@ struct cma {
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
-extern unsigned cma_area_count;
+extern unsigned int cma_area_count;
 
 static inline unsigned long cma_bitmap_maxno(struct cma *cma)
 {
_

Patches currently in -mm which might be from 295107659@qq.com are


