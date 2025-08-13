Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA992FB966
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755125824; cv=none; b=PeiBq+7n1/z4+9gXhUbnqYU0cK5xO3fAqzw7cASirVZyoc5NqRacE+SiYpEV00+JYgX2V+BpWMsq15xIs1xDVNQdOqv3VoOWG5J4t6J3X2ncGlGOcPRoOE2s0jrzjBxlZZ/Kcf4YvMFZPTHgADkcOUXMentDF7BvhnEHB6CFT1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755125824; c=relaxed/simple;
	bh=BSquDP0qpqhypWvatQ/Db+GOmt1N41IBTEoajB6yC5g=;
	h=Date:To:From:Subject:Message-Id; b=SaF5RWIAPpksbRwXbYvTzCsrWZhtiE9jKc17c3s/mwBJwIWnDlLw9NtXOH6DnId1/BklVLbnXL0Rk/Uu+v1oNZFyxryUcZTMrDHq/QWLyFsOB3YhII0L9KdUhrPu549Ikm+fGugmuCA2MF4Cgpt4Kl7+xv4GSr92NMe7X9dRgHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=poBzUEkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="poBzUEkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2D8C4CEEB;
	Wed, 13 Aug 2025 22:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755125824;
	bh=BSquDP0qpqhypWvatQ/Db+GOmt1N41IBTEoajB6yC5g=;
	h=Date:To:From:Subject:From;
	b=poBzUEkrcRcFIoxRH5QEtWTntSkx5ScATkOm3RMt5t/VhkYM1kgNoxvakj/SDlEYI
	 PgkA1MS4Ohqx2OIp3ntFelsjPYRggNjzWk//KbDRrR1VAmCSJ+YTDNYzlSfnwmHUQl
	 ldZ4TDsLycuwqcmwuysgdMoB8FHqd+eREoVfbK1Q=
Date: Wed, 13 Aug 2025 15:57:03 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-spelling-mistake-mrmeap-mremap.patch added to mm-unstable branch
Message-Id: <20250813225704.4D2D8C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix spelling mistake "mrmeap" -> "mremap"
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-spelling-mistake-mrmeap-mremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-spelling-mistake-mrmeap-mremap.patch

This patch will later appear in the mm-unstable branch at
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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftests/mm: fix spelling mistake "mrmeap" -> "mremap"
Date: Wed, 13 Aug 2025 09:13:33 +0100

There are spelling mistakes in perror messages.  Fix these.

Link: https://lkml.kernel.org/r/20250813081333.1978096-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-fix-spelling-mistake-mrmeap-mremap
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -846,7 +846,7 @@ static void mremap_move_multi_invalid_vm
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
@@ -899,7 +899,7 @@ static void mremap_move_multi_invalid_vm
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
@@ -948,7 +948,7 @@ static void mremap_move_multi_invalid_vm
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftests-mm-fix-spelling-mistake-mrmeap-mremap.patch

