Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9AC7765B
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eaYQRrwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30D9C433C7;
	Tue, 12 Dec 2023 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702398122;
	bh=qwbBw6a8S5NTRUmtE3OUB5ZYmvaQzQIV/3VVopfb+zU=;
	h=Date:To:From:Subject:From;
	b=eaYQRrwxtdUC4Td+N646WazELQiKxNnm5D9lgwQBHAwcp2SGn579uIno04pJXffY2
	 1NPoq6k6/MLriaBkTH572mvmAJMh52j8UuoCj7pzCXJUAzp/Ago8OpQi8hyCFDfID/
	 OdVBC+t+chVUY66QLaqWHDnTC7Wm+Nr9zAoFCjtw=
Date: Tue, 12 Dec 2023 08:22:01 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-use-align-macro-instead-of-open-coding-it.patch added to mm-nonmm-unstable branch
Message-Id: <20231212162201.E30D9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: use ALIGN macro instead of open-coding it
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-use-align-macro-instead-of-open-coding-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-use-align-macro-instead-of-open-coding-it.patch

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
From: Yuntao Wang <ytcoode@gmail.com>
Subject: kexec: use ALIGN macro instead of open-coding it
Date: Tue, 12 Dec 2023 22:27:06 +0800

Use ALIGN macro instead of open-coding it to improve code readability.

Link: https://lkml.kernel.org/r/20231212142706.25149-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_core.c~kexec-use-align-macro-instead-of-open-coding-it
+++ a/kernel/kexec_core.c
@@ -432,7 +432,7 @@ static struct page *kimage_alloc_crash_c
 
 	pages = NULL;
 	size = (1 << order) << PAGE_SHIFT;
-	hole_start = (image->control_page + (size - 1)) & ~(size - 1);
+	hole_start = ALIGN(image->control_page, size);
 	hole_end   = hole_start + size - 1;
 	while (hole_end <= crashk_res.end) {
 		unsigned long i;
@@ -449,7 +449,7 @@ static struct page *kimage_alloc_crash_c
 			mend   = mstart + image->segment[i].memsz - 1;
 			if ((hole_end >= mstart) && (hole_start <= mend)) {
 				/* Advance the hole to the end of the segment */
-				hole_start = (mend + (size - 1)) & ~(size - 1);
+				hole_start = ALIGN(mend, size);
 				hole_end   = hole_start + size - 1;
 				break;
 			}
_

Patches currently in -mm which might be from ytcoode@gmail.com are

crash_core-fix-the-check-for-whether-crashkernel-is-from-high-memory.patch
kexec-use-align-macro-instead-of-open-coding-it.patch

