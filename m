Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EA1130A54
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854790; cv=none; b=LzUMafBpgWPalu8v7rjL5T/5geywpz3zUHpfLQ7yeVi7RhSbIJhA8quXWCIk6eByksKfLYHoEcMBd9G5LXV6PcMmfpX4UfIsXJ6SzBITkkA6aDSX9l/s5F7E8z/HVIix11VmUvmr1jrsaKcPYRPJPRPUdWTRTMjDIVrPDvP5/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854790; c=relaxed/simple;
	bh=bf6qtGNBAEDYi98U+J0K89p49I/e6ZJ/CVJ2v5vozQg=;
	h=Date:To:From:Subject:Message-Id; b=PP7xVhWNTlkeozBiutQ1MWDyS73tesfbVeIYCutoPF9icy+p0DK1NAgCKAX2BvPc5NW8Bi67vJEJpSubUzT9SDM9q4vYkO3MwbwJpotgMBaD8knQV27OA1KtcMk74kZaBjzb01l4GCyzlik7x2dpvFQEyg75mSKxPgPmHb3IE0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oH5T5aAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oH5T5aAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D41C4CECF;
	Wed,  6 Nov 2024 00:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854790;
	bh=bf6qtGNBAEDYi98U+J0K89p49I/e6ZJ/CVJ2v5vozQg=;
	h=Date:To:From:Subject:From;
	b=oH5T5aAoSbftm2IUqGYPmWpPm+dH0gTWU87dOrJDoWW8X+kSQgLvkBYA6XpM4SiFx
	 FDNmbr6afp8uQcdblm7kRhDG1THEPG4wWpDv/fU6lFiR0/gRnULhYl+WgGZmnYzdvt
	 0FivL5Gj9oW8C23EEe0vQTajUU+ou6kbGeZwsbFE=
Date: Tue, 05 Nov 2024 16:59:49 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-fix-typo-in-object_no_scan-comment.patch removed from -mm tree
Message-Id: <20241106005950.66D41C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: fix typo in object_no_scan() comment
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-fix-typo-in-object_no_scan-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/kmemleak: fix typo in object_no_scan() comment
Date: Thu, 10 Oct 2024 18:54:39 +0300

Replace "corresponding to the give pointer" with "corresponding to the
given pointer"

Link: https://lkml.kernel.org/r/20241010155439.554416-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-typo-in-object_no_scan-comment
+++ a/mm/kmemleak.c
@@ -1011,7 +1011,7 @@ static void object_set_excess_ref(unsign
 }
 
 /*
- * Set the OBJECT_NO_SCAN flag for the object corresponding to the give
+ * Set the OBJECT_NO_SCAN flag for the object corresponding to the given
  * pointer. Such object will not be scanned by kmemleak but references to it
  * are searched.
  */
_

Patches currently in -mm which might be from rppt@kernel.org are


