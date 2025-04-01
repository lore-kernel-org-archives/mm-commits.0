Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B134F21D3C5
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545893; cv=none; b=mjVaQaiBXcvD2sb8+fZbVqyG5OvoLK2EkQZlU98qJl0+W3DfdWegKa65GEXrds77YD2FlB45iGozQnXj+G2rLFeTFYVUsvUkFtt7p2sTY1+AKa3Cf8CcxdL6gurXYIk/ZceA34lL9yRMDCAb9dYnhKBHD5dzQh14Fb9TAl9/ge8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545893; c=relaxed/simple;
	bh=E2za1bXmb5Gvf12qjkobKd6Rsjrc9zzp1bghszXG+uQ=;
	h=Date:To:From:Subject:Message-Id; b=DS8Ce4ox+A8Drf4DMZw7QTTTHB8dWVfItQ4CULYFGgcwknieO/l7hJTBo1aDzMomnonFkjT36hT2r79HE6+NFN2QVyzGc4cSEV3+cWaMQ8MnbQESUso6kXrsNPrc1x7fjeYUUl6DpaqL/+Ld6AigFO+sE/kNB36Orn+93R2HYQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BngKc3ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BngKc3ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D233C4CEE9;
	Tue,  1 Apr 2025 22:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545893;
	bh=E2za1bXmb5Gvf12qjkobKd6Rsjrc9zzp1bghszXG+uQ=;
	h=Date:To:From:Subject:From;
	b=BngKc3ciChSHn3TdJrwqWY866s4NE6jHw6/QWOOHsM6C44hlDjK8D7UlxP+UpoNlL
	 EyWKm9W3+6w4UvF1GxNppGwiSGpbasFGJFNRGDMgJtdSbb6Ht+6RctrBwR0NqAvfoG
	 CBVn19ttC8SX0w8YYiVgluHIoyJPLIbAE2CNap4M=
Date: Tue, 01 Apr 2025 15:18:12 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,monstr@monstr.eu,masahiroy@kernel.org,lkp@intel.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] microblaze-mm-put-mm_cmdline_setup-in-inittext-section.patch removed from -mm tree
Message-Id: <20250401221813.6D233C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: microblaze/mm: put mm_cmdline_setup() in .init.text section
has been removed from the -mm tree.  Its filename was
     microblaze-mm-put-mm_cmdline_setup-in-inittext-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: microblaze/mm: put mm_cmdline_setup() in .init.text section
Date: Fri, 28 Mar 2025 01:01:36 +0000

As reported by lkp, there is a section mismatch of mm_cmdline_setup() and
memblock.  The reason is we don't specify the section of
mm_cmdline_setup() and gcc put it into .text.unlikely.

As mm_cmdline_setup() is only used in mmu_init(), which is in .init.text
section, put mm_cmdline_setup() into it too.

Link: https://lkml.kernel.org/r/20250328010136.13139-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503241259.kJV3U7Xj-lkp@intel.com/
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/microblaze/mm/init.c~microblaze-mm-put-mm_cmdline_setup-in-inittext-section
+++ a/arch/microblaze/mm/init.c
@@ -118,7 +118,7 @@ int page_is_ram(unsigned long pfn)
 /*
  * Check for command-line options that affect what MMU_init will do.
  */
-static void mm_cmdline_setup(void)
+static void __init mm_cmdline_setup(void)
 {
 	unsigned long maxmem = 0;
 	char *p = cmd_line;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


