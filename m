Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDE119B
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845968; cv=none; b=Jk7JPBLEXqb7pbPIy+szczYfAEKalA5TjlNS7U8wMh2NUtpMr3nF/WAtfIecRmP3ZdZKA16LX51TBmzfLuF9zxgExBYLOPY9SHwi5sJ4HAwbmNJrE+5Bg1G+VEMCWz5mR49qZVw1fd53F3a0Tv42TS61VeFPYmKFmw8MJasSSfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845968; c=relaxed/simple;
	bh=1Ns77VCNHHPSyfdPCGoazETlARhz6yHD/+aNt+MF8Mk=;
	h=Date:To:From:Subject:Message-Id; b=t1tt+HsXUgf+hCQXbNVQ0enj6U7nnoFG97UhPO8o1CShU6N5rPFAYDBsw8uKZr9BtBBHVavikUenKl7UL/xSW8w0LrsZZQIkSNRp4fHzWdtKP+RSAPwc9Q4BY4nArjEIRm81wCaz49cwc7G2ZCZaTqBUEnwjRnTxNvDnBZ9uzSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MR9yua5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MR9yua5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66C3C4AF07;
	Thu, 20 Jun 2024 01:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845968;
	bh=1Ns77VCNHHPSyfdPCGoazETlARhz6yHD/+aNt+MF8Mk=;
	h=Date:To:From:Subject:From;
	b=MR9yua5oozg8L+cwTywXMGFRqZGfUPpipwwAphS8/M0ZGqq8uUnRVPtiq5e8GFTuW
	 QEfxfK/9FXcipCWWx7bTOE9QWkRIAsill3gNlPAu9XzS/2gZp2TTiVSrE5AhOqd+A0
	 pB3K07BPrcTqJgDvvALpG0BXSfWGqCeacg4RGhLI=
Date: Wed, 19 Jun 2024 18:12:47 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-rework-module-va-range.patch added to mm-nonmm-unstable branch
Message-Id: <20240620011247.E66C3C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: rework module VA range
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-rework-module-va-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-rework-module-va-range.patch

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
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: rework module VA range
Date: Wed, 19 Jun 2024 15:49:07 +0800

After we enlarge the module VA range, we also change the module VA
range in gdb scripts.

Link: https://lkml.kernel.org/r/20240619074911.100434-3-kuan-ying.lee@canonical.com
Fixes: 3e35d303ab7d ("arm64: module: rework module VA range selection")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-rework-module-va-range
+++ a/scripts/gdb/linux/mm.py
@@ -33,7 +33,7 @@ class aarch64_page_ops():
     def __init__(self):
         self.SUBSECTION_SHIFT = 21
         self.SEBSECTION_SIZE = 1 << self.SUBSECTION_SHIFT
-        self.MODULES_VSIZE = 128 * 1024 * 1024
+        self.MODULES_VSIZE = 2 * 1024 * 1024 * 1024
 
         if constants.LX_CONFIG_ARM64_64K_PAGES:
             self.SECTION_SIZE_BITS = 29
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are

scripts-gdb-redefine-max_order-sanely.patch
scripts-gdb-rework-module-va-range.patch
scripts-gdb-change-the-layout-of-vmemmap.patch
scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch
scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch
scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch

