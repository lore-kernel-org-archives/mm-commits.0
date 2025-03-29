Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB293595B
	for <mm-commits@vger.kernel.org>; Sat, 29 Mar 2025 01:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743211148; cv=none; b=BPdPt0JW4OD8Ytav4XA0j2TDbXzsEaRoIeiElKiKwxoLQiJv2av8JCIAKzPieonZijLYibM2g8VmKRcnwSYf71Ef+O60Vfzn4FW3w1j40wFdb1LCog8YoQyiM7vHmOBbPz4MkgN2MhcvYWp9zXaJqetkuuO1hgFuLXwlMrClLdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743211148; c=relaxed/simple;
	bh=U7P3vY01Gekh2ZJLkAwTcVTjL3RHMOJUhPSwpuhJ4OY=;
	h=Date:To:From:Subject:Message-Id; b=gvS1m8Vg6YpKtiwIU74Un3Ms9wgzwVHDHad7QcXfXVfL6N6sXxllRIMdQMAFLLnkw9oPDEqOCjrYsxddh004CY4fmhSJTtW/v8BP6oEGD5f+YPiBAWi4gWN4mt9UKF5iBY2im6SU63Pb9l0XdUfBBCxZkIWJjRi9PD3kC/meu9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1kdrbxB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1kdrbxB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95016C4CEE4;
	Sat, 29 Mar 2025 01:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743211147;
	bh=U7P3vY01Gekh2ZJLkAwTcVTjL3RHMOJUhPSwpuhJ4OY=;
	h=Date:To:From:Subject:From;
	b=1kdrbxB6YeVjixiXWIzuiwpaPafP8wkgN2LamZVLdp3YqjfiffMGGf7Mxd6S8Ejot
	 3Z2w4CRI8hu2KNoo5wRV0+TOEltQpDXdBj/7VS7+zLoalply8kWdRO0j4u4YuhHgqD
	 XljVlO3i2H4+ps3CIQblSnvYJGDnJ52v9MC4E2es=
Date: Fri, 28 Mar 2025 18:19:06 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,monstr@monstr.eu,masahiroy@kernel.org,lkp@intel.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + microblaze-mm-put-mm_cmdline_setup-in-inittext-section.patch added to mm-unstable branch
Message-Id: <20250329011907.95016C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: microblaze/mm: put mm_cmdline_setup() in .init.text section
has been added to the -mm mm-unstable branch.  Its filename is
     microblaze-mm-put-mm_cmdline_setup-in-inittext-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/microblaze-mm-put-mm_cmdline_setup-in-inittext-section.patch

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

microblaze-mm-put-mm_cmdline_setup-in-inittext-section.patch

