Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF36685654;
	Wed,  7 Aug 2024 18:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723057194; cv=none; b=igQ83p5V3kAS7HPFcllK5c+NU2OVjmPXuZzDBU9/iRE14c5mt8WvNaJx+eKQudtIG0bLV0D3OwRqYWcPRb02bs7a6IVw3ZV89Xh4ZeJe4ndOpQR6dFrAemi65kfEMvTMBXKVpDTzEQQjFDP283Ds2A4DyRBRn07Y1AiXaEnKOxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723057194; c=relaxed/simple;
	bh=fAxNTGnqn0QbNJUBVQ083vMBsP4H/tDRb9V6Pogxw6A=;
	h=Date:To:From:Subject:Message-Id; b=VI9gayM2T7DZSzZYe5StHPFUruSei/zxuh5sZ8W35HgIjSDar8Mwq0Ryaw6OLl/071h0/FLx0vstgZMWYWAuGu1A6qQ/G+pDJLXN4Tuby6as30obvUgxeqmP52hi7xUjaKmp+fS75+oB5Q5uYEjOIi0qE9bC09eNXeV/hZFMEeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I+ftJSnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I+ftJSnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5F0C32781;
	Wed,  7 Aug 2024 18:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723057194;
	bh=fAxNTGnqn0QbNJUBVQ083vMBsP4H/tDRb9V6Pogxw6A=;
	h=Date:To:From:Subject:From;
	b=I+ftJSnAAD+SYKbBLCBK17J9EKetYqcHRcirp3yo4JU7D8gvZ86efgnHCtMcXDLPk
	 fVjwarFnp2CRWofWC5HcGg147Bsl9vF/SOXy3HtOg6th8f1RgmunkT0FpTF1fQ9PMf
	 oWHTTxQfvW6MHjOBrPzkPva5QkeprZcVk0AIDyXk=
Date: Wed, 07 Aug 2024 11:59:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-fix-is_madv_discard.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807185954.1F5F0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal: fix is_madv_discard()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mseal-fix-is_madv_discard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-fix-is_madv_discard.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mseal: fix is_madv_discard()
Date: Wed, 7 Aug 2024 18:33:35 +0100

is_madv_discard did its check wrong. MADV_ flags are not bitwise,
they're normal sequential numbers. So, for instance:
	behavior & (/* ... */ | MADV_REMOVE)

tagged both MADV_REMOVE and MADV_RANDOM (bit 0 set) as
discard operations. This is obviously incorrect, so use
a switch statement instead.

Link: https://lkml.kernel.org/r/20240807173336.2523757-1-pedro.falcato@gmail.com
Link: https://lkml.kernel.org/r/20240807173336.2523757-2-pedro.falcato@gmail.com
Fixes: 8be7258aad44 ("mseal: add mseal syscall")
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>
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

mseal-fix-is_madv_discard.patch
selftests-mm-add-mseal-test-for-no-discard-madvise.patch

