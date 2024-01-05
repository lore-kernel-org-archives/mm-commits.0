Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2F436084
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 19:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m4BKwmiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F49CC433C7;
	Fri,  5 Jan 2024 19:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704483205;
	bh=h8JZfTOvJXYFjB212d6Sl3dlIEwLqh/QPppKUUOi5E0=;
	h=Date:To:From:Subject:From;
	b=m4BKwmiUskcrwEZiwT52gOn9ai+PneZs9mB5ZctmCKtekjluxhBLYCnS1lUtnrvqV
	 XHSwEdMXqzJDxriE/SnxzPXrZQ30Lppk+t0ndmqs7yVJ6Y9g7r/hEmEAPRecSrVe3z
	 VW2KGMpkAx72XRzlEpA8kZtigdetEMuLlHTjXMJM=
Date: Fri, 05 Jan 2024 11:33:24 -0800
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,lkp@intel.com,bcain@quicinc.com,acme@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon.patch added to mm-nonmm-unstable branch
Message-Id: <20240105193325.7F49CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Kconfig.debug: disable CONFIG_DEBUG_INFO_BTF for Hexagon
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: lib/Kconfig.debug: disable CONFIG_DEBUG_INFO_BTF for Hexagon
Date: Fri, 05 Jan 2024 12:13:04 -0700

pahole, which generates BTF, relies on elfutils to process DWARF debug
info.  Because kernel modules are relocatable files, elfutils needs to
resolve relocations when processing the DWARF .debug sections.

Hexagon is not supported in binutils or elfutils, so elfutils is unable to
process relocations in kernel modules, causing pahole to crash during BTF
generation.

Do not allow CONFIG_DEBUG_INFO_BTF to be selected for Hexagon until it is
supported in elfutils, so that there are no more cryptic build failures
during BTF generation.

Link: https://lkml.kernel.org/r/20240105-hexagon-disable-btf-v1-1-ddab073e7f74@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312192107.wMIKiZWw-lkp@intel.com/
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Brian Cain <bcain@quicinc.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/Kconfig.debug~lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon
+++ a/lib/Kconfig.debug
@@ -378,6 +378,8 @@ config DEBUG_INFO_BTF
 	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	depends on BPF_SYSCALL
 	depends on !DEBUG_INFO_DWARF5 || PAHOLE_VERSION >= 121
+	# pahole uses elfutils, which does not have support for Hexagon relocations
+	depends on !HEXAGON
 	help
 	  Generate deduplicated BTF type information from DWARF debug info.
 	  Turning this on expects presence of pahole tool, which will convert
_

Patches currently in -mm which might be from nathan@kernel.org are

lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon.patch

