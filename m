Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273383BA248
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294519; cv=none; b=JBEE8tkKKJEEhhHZmlXlLQLGYCHJr7lcImlmjo+D3qnZ05GslKHZ0gxjrRlTrtAYyF7N0X5FbmloUAUoRIAruSxEmRm0FdetAdv9hlL/ao+M8V9eVQc2/WAqMkSiqFoUJZVOon+Bpp47XAJ5f6uG1DlA67kTiuWgwOJRJKdbRnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294519; c=relaxed/simple;
	bh=SJMxXqxq4UaRO249DYEsdm4MFly8R8Bv4aEhKPenDfU=;
	h=Date:To:From:Subject:Message-Id; b=U4UeV8GDY5HI0rf6UiZEldr6BlY96Zba/krPGmPXIm/rl+xFBihSkaSkdGD01RKg57CLZhq15fXTZmzOv9KGsB7Gif0WeW6DvzfQO8KRkM48MnuaXTTSajzkEjyb1sJQYWAkrpCDnxVCQumCWOEhd2jgSDQNSbj2zNYQeOURcZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=luryQt2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="luryQt2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7D9C19425;
	Mon, 27 Apr 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294519;
	bh=SJMxXqxq4UaRO249DYEsdm4MFly8R8Bv4aEhKPenDfU=;
	h=Date:To:From:Subject:From;
	b=luryQt2yAcelpxDrHs5VW8nhgPB2Pgt6C47vXtWsNktVtHXgw+yXxA79BOijEs4gg
	 IMddYtfS5fbtrR5SooJs4GWFCEHtj/QVTPy2RcCI+IPLTe6W+T67vpMIG79gyIGO5L
	 ZYIhvl2ou42HlfxzIRR2+/690pnCr5Azez8c34cc=
Date: Mon, 27 Apr 2026 05:55:18 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,dev.jain@arm.com,david@kernel.org,anshuman.khandual@arm.com,aishwarya.tcv@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch removed from -mm tree
Message-Id: <20260427125518.EC7D9C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: specify requirement for PROC_MEM_ALWAYS_FORCE=y
has been removed from the -mm tree.  Its filename was
     selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: specify requirement for PROC_MEM_ALWAYS_FORCE=y
Date: Thu, 16 Apr 2026 19:40:56 +0100

Several of the mm selftests made use of /proc/pid/mem as part of their
operation but we do not specify this in the config fragment for them, at
least mkdirty and ksm_functional_tests have this requirement.

This has been working fine in practice since PROC_MEM_ALWAYS_FORCE was the
default setting but commit 599bbba5a36f ("proc: make PROC_MEM_FORCE_PTRACE
the Kconfig default") that is no longer the case, meaning that tests run
on kernels built based on defconfigs have started having the new more
restrictive default and failing.  Add PROC_MEM_ALWAYS_FORCE to the config
fragment for the mm selftests.

Thanks to Aishwarya TCV for spotting the issue and identifying the commit
that introduced it.

Link: https://lore.kernel.org/20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org
Fixes: 599bbba5a36f ("proc: make PROC_MEM_FORCE_PTRACE the Kconfig default") 
Signed-off-by: Mark Brown <broonie@kernel.org>
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/config~selftests-mm-specify-requirement-for-proc_mem_always_force=y
+++ a/tools/testing/selftests/mm/config
@@ -13,3 +13,4 @@ CONFIG_PROFILING=y
 CONFIG_UPROBES=y
 CONFIG_MEMORY_FAILURE=y
 CONFIG_HWPOISON_INJECT=m
+CONFIG_PROC_MEM_ALWAYS_FORCE=y
_

Patches currently in -mm which might be from broonie@kernel.org are

kselftest-filelock-use-ksft_perror.patch
kselftest-filelock-report-each-test-in-oftlocks-separately.patch
kselftest-filelock-add-a-gitignore-file.patch

