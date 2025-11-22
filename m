Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50122BE5E
	for <mm-commits@vger.kernel.org>; Sat, 22 Nov 2025 21:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763848001; cv=none; b=gV2MNVqNslIxr7YZUTbnPUuy0kyXqOtvhljhMgREWP5Yy1/8tSGrZGMFUsTeJAQSOf9c6YHbfOztpAyZNKJ/5ye9YQxnTm+THN/CvhD3ltCHxA4DCChhRBzGKfvA4Uc/QSGmcfJE/1MR/cFczaQCyxiQb83cvCKSGdiBTe8IEAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763848001; c=relaxed/simple;
	bh=xnUYY5lI6N2Q032LI8J8SQjK6K3rWDxFGRa0hCng0x8=;
	h=Date:To:From:Subject:Message-Id; b=Wd7G+8sSeGX1bPn9WUwwSNmMSjm8bQTcmOcr+yxpd5JR8hyw9aM6xvarosrSFxCAwDNumGCu07ECFEz5sk9H6MrfbMaEyGkRR/MOwSX9TZlAjn3qGqRluRED3YxbbWlaHQGGuAvKGCsh/CUkCv9SA04asv0ov+8X9bYkag80pFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CNBmWvIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CNBmWvIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D05C4CEF5;
	Sat, 22 Nov 2025 21:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763848000;
	bh=xnUYY5lI6N2Q032LI8J8SQjK6K3rWDxFGRa0hCng0x8=;
	h=Date:To:From:Subject:From;
	b=CNBmWvIbMe/tSKKiU2UM8neFlnTySK223m7OnTVgYCnzxsrb177K2u+Z8Pb/qzYaJ
	 Deh4vOCUTYzaGECfistYQnDvC6euT/9/Ofp/K1di1ugSfMNueqBqkPfQGicIbV4+/L
	 LwEw2QfO1r2WfkS88LiNchTAOSzFuD5huCMjNquY=
Date: Sat, 22 Nov 2025 13:46:40 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,brauner@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-replace-simple_strtoul-with-kstrtoul-to-improve-lpj_setup.patch added to mm-nonmm-unstable branch
Message-Id: <20251122214640.B1D05C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: replace simple_strtoul with kstrtoul to improve lpj_setup
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-replace-simple_strtoul-with-kstrtoul-to-improve-lpj_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-replace-simple_strtoul-with-kstrtoul-to-improve-lpj_setup.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: init: replace simple_strtoul with kstrtoul to improve lpj_setup
Date: Sat, 22 Nov 2025 12:45:37 +0100

Replace simple_strtoul() with the recommended kstrtoul() for parsing the
'lpj=' boot parameter.

Check the return value of kstrtoul() and reject invalid values.  This adds
error handling while preserving existing behavior for valid values, and
removes use of the deprecated simple_strtoul() helper.

Link: https://lkml.kernel.org/r/20251122114539.446937-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/calibrate.c~init-replace-simple_strtoul-with-kstrtoul-to-improve-lpj_setup
+++ a/init/calibrate.c
@@ -14,10 +14,10 @@
 
 unsigned long lpj_fine;
 unsigned long preset_lpj;
+
 static int __init lpj_setup(char *str)
 {
-	preset_lpj = simple_strtoul(str,NULL,0);
-	return 1;
+	return kstrtoul(str, 0, &preset_lpj) == 0;
 }
 
 __setup("lpj=", lpj_setup);
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

init-replace-simple_strtoul-with-kstrtoul-to-improve-lpj_setup.patch

