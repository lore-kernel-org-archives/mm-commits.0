Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D044378C7F;
	Fri, 16 Aug 2024 05:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785407; cv=none; b=tMEjOF4eMRIq6YlUp8j1zMDh0Bbp2vZVQFAfZjCB0tKRNoais5sHSkxX0LkLqKNuG2ISWohSip9tXp1byhSyzCJbZB7kpzX7qEshWWcr2zM4cF2NgBXmbbaWL8bPN6/mb7Z56dCTZHuWYRwm5MrXV3wchxlPKbXmrSvxOPeBoBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785407; c=relaxed/simple;
	bh=HkOg7kiuT7pW5xodImkvziK4KHY+CtXrZ48FXsfFVPY=;
	h=Date:To:From:Subject:Message-Id; b=p8jZAQKnmTgEbnA8VSIhKtC+K120l7t02zJwB5XXyLpvqowR6AW5Ytj8PJbgZ3Zu56FJlZdcaRX9MHqvvb1W+qh/IOQuTjscNcuJR9AvqnnBn4Dgosj3FtgyjELgDzZsYeOBBRz7bDeZhQI1DIWNC/igBg/XR0YbMbs9un+NEOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jm+mIXki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jm+mIXki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29153C32782;
	Fri, 16 Aug 2024 05:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785407;
	bh=HkOg7kiuT7pW5xodImkvziK4KHY+CtXrZ48FXsfFVPY=;
	h=Date:To:From:Subject:From;
	b=jm+mIXkiKEGbIO7A7lCe6Vaa5Ww0S+r0KHClIZjk3gffhd/iXGSV4SzUsr3bwW2sJ
	 TuCWJWaFYvgJ02uiy5yc/wJ0ye+L5C1AotXT1BHqbFJ5FYNShfF1S12tbufnQ/Ww+Q
	 GMURLQmDeaWqVOmA0mXNCzbamGcQ3T/Ai5bb7qjk=
Date: Thu, 15 Aug 2024 22:16:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mseal-fix-is_madv_discard.patch removed from -mm tree
Message-Id: <20240816051647.29153C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal: fix is_madv_discard()
has been removed from the -mm tree.  Its filename was
     mseal-fix-is_madv_discard.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mseal: fix is_madv_discard()
Date: Wed, 7 Aug 2024 18:33:35 +0100

is_madv_discard did its check wrong. MADV_ flags are not bitwise,
they're normal sequential numbers. So, for instance:
	behavior & (/* ... */ | MADV_REMOVE)

tagged both MADV_REMOVE and MADV_RANDOM (bit 0 set) as discard
operations.

As a result the kernel could erroneously block certain madvises (e.g
MADV_RANDOM or MADV_HUGEPAGE) on sealed VMAs due to them sharing bits
with blocked MADV operations (e.g REMOVE or WIPEONFORK).

This is obviously incorrect, so use a switch statement instead.

Link: https://lkml.kernel.org/r/20240807173336.2523757-1-pedro.falcato@gmail.com
Link: https://lkml.kernel.org/r/20240807173336.2523757-2-pedro.falcato@gmail.com
Fixes: 8be7258aad44 ("mseal: add mseal syscall")
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Tested-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/mseal.c~mseal-fix-is_madv_discard
+++ a/mm/mseal.c
@@ -40,9 +40,17 @@ static bool can_modify_vma(struct vm_are
 
 static bool is_madv_discard(int behavior)
 {
-	return	behavior &
-		(MADV_FREE | MADV_DONTNEED | MADV_DONTNEED_LOCKED |
-		 MADV_REMOVE | MADV_DONTFORK | MADV_WIPEONFORK);
+	switch (behavior) {
+	case MADV_FREE:
+	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
+	case MADV_REMOVE:
+	case MADV_DONTFORK:
+	case MADV_WIPEONFORK:
+		return true;
+	}
+
+	return false;
 }
 
 static bool is_ro_anon(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch

