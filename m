Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D821336DA1A
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027620; cv=none; b=I0tiAJdlX519WEcz1+l4B7nzXqGICEe9smIXXYBW/wY0o01YphfcO70K19Rt/uT4AXOH44VofBi3f3V57q3r689BrJAlZjEKOo6ZheRKpD/8hhs7rUQ2C9r9fmU7j9A7W5aRIdJ59tjKpNrp5JaZeazf6xQzU6a7vJOm7GQYtIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027620; c=relaxed/simple;
	bh=0vp/T6KMXr7af6Q2U4OnerkASii2FJaYZr84FAvXQxA=;
	h=Date:To:From:Subject:Message-Id; b=rZcunmwCNE6FlqVbpPTBgxbacjtrKt6JoEWHm1B69/hEVbY4ocWh1NfIcIrX9nhUFRZ/0vXiyZvDNheeY5vzWOs6tq0Rpc3NiHyxTz7DPaP0p6u9EcbBkaM2/fRn4T5IRrEC56rvOwyhuoLy1qsCKPVSuX8mceUfLgxsc7SQPtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=APYbe9zM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="APYbe9zM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC78B1F00898;
	Fri, 29 May 2026 04:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027618;
	bh=CtcjGUlKtVzjrpSTZSNSZbd0mj1P1al5vgZySrvQJkA=;
	h=Date:To:From:Subject;
	b=APYbe9zMiLeB/5zgQ5W5btpn9oEG0uzrxN6HbgcqIQ4t3x0/OyTESJHemYU0lEYi1
	 uGKxOqjWQhwtPjGB7mraMfm6ll87rTwkiKyMqDyUhn0cSwsV87BrNWXkpoknS7FXkX
	 Z2Y7Nq3VPIKAItEBI+NQ0+q+mQfPeTVpehdZkWzs=
Date: Thu, 28 May 2026 21:06:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,anshuman.khandual@arm.com,julianbraha@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-dead-code-cleanup-in-kconfig.patch removed from -mm tree
Message-Id: <20260529040658.AC78B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/thp: dead code cleanup in Kconfig
has been removed from the -mm tree.  Its filename was
     mm-thp-dead-code-cleanup-in-kconfig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -810,7 +810,6 @@ if TRANSPARENT_HUGEPAGE
 
 choice
 	prompt "Transparent Hugepage Support sysfs defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_ALWAYS
 	help
 	  Selects the sysfs defaults for Transparent Hugepage Support.
@@ -840,7 +839,6 @@ endchoice
 
 choice
 	prompt "Shmem hugepage allocation defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
 	help
 	  Selects the hugepage allocation policy defaults for
@@ -886,7 +884,6 @@ endchoice
 
 choice
 	prompt "Tmpfs hugepage allocation defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
 	help
 	  Selects the hugepage allocation policy defaults for
@@ -931,7 +928,7 @@ endchoice
 
 config THP_SWAP
 	def_bool y
-	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
+	depends on ARCH_WANTS_THP_SWAP && SWAP && 64BIT
 	help
 	  Swap transparent huge pages in one piece, without splitting.
 	  XXX: For now, swap cluster backing transparent huge page
_

Patches currently in -mm which might be from julianbraha@gmail.com are


