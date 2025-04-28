Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49B78472
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 00:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745799223; cv=none; b=F0VJZUs2HfjMurfWJ1WIk1htbW5JPo8m+rtk16CPZD8V9Y2YqWek6siNV1VIuSQ2+zGZ+bzNEQljZJjDzTjgRCYrbfAKy4Liko6g0pbLrj+hm7zix/ZPNteSrCaEzvu+k0DP00W7rl4bM85TKKsTzkan5niWDwdCaICsp06k7fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745799223; c=relaxed/simple;
	bh=NfO4vJjYRwL/5Rhwyq3Wq8mD40Xanq/iL3IE4vaFxDs=;
	h=Date:To:From:Subject:Message-Id; b=SyBsgMb4BCp81emDUBLwaRYVoDqioZJDcL1fccXxiReGEk491lXX7PkUDq8JIdb9PxINJPtlt2o9J77aYGnXBPWeawGxQZPTgfybQQpV/KoTzzxnQBfRW5mDzrM8Z93kens9qcZYysRFbJxF23PBc+0sHL/GrjSdHdZPGoPgee4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wEjO9aZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wEjO9aZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8A1C4CEE3;
	Mon, 28 Apr 2025 00:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745799222;
	bh=NfO4vJjYRwL/5Rhwyq3Wq8mD40Xanq/iL3IE4vaFxDs=;
	h=Date:To:From:Subject:From;
	b=wEjO9aZDuQJK5MmFDtj8TZbXw29bB5dBDmKRwT2eyvmfyX11ov0feZ7ZcbnegB7Su
	 4JbzLJFJfzMZbDIHpJr2YGAeonjtzQO0aTBwzlBnnGrhxkyFnqv29fucfsNAoY3b5z
	 EQw1IWc0lzixXdZKw5vPFh+yA5vK2VB1qaoFDLx0=
Date: Sun, 27 Apr 2025 17:13:42 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,siddarthsgml@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-long-for-dwregionsize.patch added to mm-unstable branch
Message-Id: <20250428001342.AF8A1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use long for dwRegionSize
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-long-for-dwregionsize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-long-for-dwregionsize.patch

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
From: Siddarth G <siddarthsgml@gmail.com>
Subject: selftests/mm: use long for dwRegionSize
Date: Sun, 27 Apr 2025 15:56:39 +0530

Change the type of 'dwRegionSize' in wp_init() and wp_free() from int to
long to match callers that pass long or unsigned long long values.

wp_addr_range function is left unchanged because it passes 'dwRegionSize'
parameter directly to pagemap_ioctl, which expects an int.

Link: https://lkml.kernel.org/r/20250427102639.39978-1-siddarthsgml@gmail.com
Signed-off-by: Siddarth G <siddarthsgml@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-use-long-for-dwregionsize
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -112,7 +112,7 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *lpBaseAddress, int dwRegionSize)
+int wp_init(void *lpBaseAddress, long dwRegionSize)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
@@ -136,7 +136,7 @@ int wp_init(void *lpBaseAddress, int dwR
 	return 0;
 }
 
-int wp_free(void *lpBaseAddress, int dwRegionSize)
+int wp_free(void *lpBaseAddress, long dwRegionSize)
 {
 	struct uffdio_register uffdio_register;
 
_

Patches currently in -mm which might be from siddarthsgml@gmail.com are

selftests-mm-convert-page_size-to-unsigned-long.patch
selftests-mm-use-long-for-dwregionsize.patch

