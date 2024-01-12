Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7920318EA9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ajqdK2Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA077C433C7;
	Fri, 12 Jan 2024 23:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101691;
	bh=96yHo5MkFESNZhxw6f1wh4HN07eqLQOjFqfOY6SVw8Q=;
	h=Date:To:From:Subject:From;
	b=ajqdK2BlYamZEW3sZ1reBKrJB2oNao9J0EPRctJ+IUZ7P6ZYMetzfi61suLWuRXFx
	 K2HJxbVxj56BaWqZ6iOi8TcUAO84kiTQVWYy0CIF67Jp6qfNAzo6ZqtP4M2gLdTnZa
	 /Xt34zflxu9fKGNxPjKoEorzwWTz9v7I+sQybiyM=
Date: Fri, 12 Jan 2024 15:21:31 -0800
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,lkp@intel.com,bcain@quicinc.com,acme@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon.patch removed from -mm tree
Message-Id: <20240112232131.DA077C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Kconfig.debug: disable CONFIG_DEBUG_INFO_BTF for Hexagon
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-bpf-update-llvm-phabricator-links.patch
arch-and-include-update-llvm-phabricator-links.patch
treewide-update-llvm-bugzilla-links.patch

