Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DDE311C2A
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 08:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020026; cv=none; b=D6nrNsZd71VlVsmw3llccwKTyfn6hYOA9bohHD6gafQ8yQ96aUyp8VXEpbQMq6nflUdJL9rmo4SHIYgNcAsHo4Sv4hG5oPTQ/L20omzVagjifopDguzRRFhJ6VBtlrUdGZAYvILID5g7mEmwPz+8UAxFVO+4yLkaEHVec4lRy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020026; c=relaxed/simple;
	bh=Qq5Z+qILRnnKbuRdPfJsfksV89xKBTAnNLLC7YpoEWc=;
	h=Date:To:From:Subject:Message-Id; b=GdziOVQAOndCkjOIU4bwnCpjmVDnqax4hV9jHzGIDH96DUOSizi1yuTVLuQlzN0MVwghw2dJUgHYvgykRL1hRKCE6K7mIp17p0KgAbYXog0HRBGocUMODWzsIP7b9KUoj5Da0TN2XqG4YE0kBIW/MKRLvBIbcv6my1USTpS+Mnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Usv4G8hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Usv4G8hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3803BC19425;
	Fri, 24 Apr 2026 08:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777020026;
	bh=Qq5Z+qILRnnKbuRdPfJsfksV89xKBTAnNLLC7YpoEWc=;
	h=Date:To:From:Subject:From;
	b=Usv4G8hpWxsqoVK6IJwztQIymMp+iuY6aD8I8Ms1oJ2X/Bd6mY7o20udCbdjAqnGl
	 Z0GnFTyEyGGsuwWaImyfh9Qco4JL0142GYkX66PAeIzvEBbxcr3/ESz1gujvpARyBW
	 wiSGFHqVYpVkJBOuAgbYUqrm3+IYa+aDgvLa+Dfc=
Date: Fri, 24 Apr 2026 01:40:25 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,dev.jain@arm.com,david@kernel.org,anshuman.khandual@arm.com,aishwarya.tcv@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch added to mm-hotfixes-unstable branch
Message-Id: <20260424084026.3803BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: specify requirement for PROC_MEM_ALWAYS_FORCE=y
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch

