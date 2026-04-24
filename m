Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259E636E496
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059849; cv=none; b=num73V8H4gkxyAd162o8m96w4xd+z0viec6lNMbp1+UOLOH7Qgrmvg54gQBIRTywkHUjUQrm1XUHKDxhqR/R9w81xD93hVPL3o6kgSs1b6jFjqT7Il3wsvhDL7yF3/sderAWptLxYN6HwqtSI/2z3JXSF/coVYB2jfBDvAw4DTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059849; c=relaxed/simple;
	bh=y6UFE+KwRcSFAeG4M3UMphD6gwbTq08aeCWtSiqO8cs=;
	h=Date:To:From:Subject:Message-Id; b=hxRa5S5JEBmQGsSQXMz0i9UCffUyoxD84r2g7v1VefTUL8rE0gF8KrPumh4OsEvLEH6tpHSTUX6MGMy6ELT+4Ducox2Veux0Nr2Zlxmdhkqyw73+JOLibAStBRhof7EqXreqxsQzjzjmm7N+VAFZUrQD6TH0ObNOAsJUEB6Qncg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rGSUiMHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rGSUiMHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E10C19425;
	Fri, 24 Apr 2026 19:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777059848;
	bh=y6UFE+KwRcSFAeG4M3UMphD6gwbTq08aeCWtSiqO8cs=;
	h=Date:To:From:Subject:From;
	b=rGSUiMHQGzE5PNRplLZQhKclo4qrhRH/a5cXsVTPFE89Vc6VwRwgkmlNXOns6dMa2
	 ewzfq/O+opC/dd59kYggbh5d5dHpkK9/JueOu1h00c52luAKU5F/QP7KTib8u4XTgC
	 gHDn4RYgmu/xAXggwn3Jc3znyQUlCLi3vUU14Kr0=
Date: Fri, 24 Apr 2026 12:44:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,anshuman.khandual@arm.com,julianbraha@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-dead-code-cleanup-in-kconfig.patch added to mm-new branch
Message-Id: <20260424194408.81E10C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/thp: dead code cleanup in Kconfig
has been added to the -mm mm-new branch.  Its filename is
     mm-thp-dead-code-cleanup-in-kconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-dead-code-cleanup-in-kconfig.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Julian Braha <julianbraha@gmail.com>
Subject: mm/thp: dead code cleanup in Kconfig
Date: Tue, 31 Mar 2026 08:07:30 +0100

There is already an 'if TRANSPARENT_HUGEPAGE' condition wrapping several
config options e.g.  'READ_ONLY_THP_FOR_FS', making the 'depends on'
statement for each of these a duplicate dependency (dead code).

I propose leaving the outer 'if TRANSPARENT_HUGEPAGE...endif' and removing
the individual 'depends on TRANSPARENT_HUGEPAGE' statement from each
option.

This dead code was found by kconfirm, a static analysis tool for Kconfig.

Link: https://lore.kernel.org/20260331070730.33915-1-julianbraha@gmail.com
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/Kconfig~mm-thp-dead-code-cleanup-in-kconfig
+++ a/mm/Kconfig
@@ -809,7 +809,6 @@ if TRANSPARENT_HUGEPAGE
 
 choice
 	prompt "Transparent Hugepage Support sysfs defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_ALWAYS
 	help
 	  Selects the sysfs defaults for Transparent Hugepage Support.
@@ -839,7 +838,6 @@ endchoice
 
 choice
 	prompt "Shmem hugepage allocation defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
 	help
 	  Selects the hugepage allocation policy defaults for
@@ -885,7 +883,6 @@ endchoice
 
 choice
 	prompt "Tmpfs hugepage allocation defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
 	help
 	  Selects the hugepage allocation policy defaults for
@@ -930,7 +927,7 @@ endchoice
 
 config THP_SWAP
 	def_bool y
-	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
+	depends on ARCH_WANTS_THP_SWAP && SWAP && 64BIT
 	help
 	  Swap transparent huge pages in one piece, without splitting.
 	  XXX: For now, swap cluster backing transparent huge page
_

Patches currently in -mm which might be from julianbraha@gmail.com are

mm-thp-dead-code-cleanup-in-kconfig.patch

