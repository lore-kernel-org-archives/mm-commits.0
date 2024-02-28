Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A3E5E09B
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 19:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149902; cv=none; b=mGh376PU3cQSxwzvLsuqy8AzRprarqLhdZ+H3EeoNPPjDFzf2c9iktb3pTUgQSAYifpube+Ee5GZN2tZ+xzqn95erHpZCCI+CYqVKLi9X/b2hr3z4eh/kWer4epG6zDpmXvQiLKEJqq4GVFGcsVbk4ykLTfqLTq1WKpRXbUMfbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149902; c=relaxed/simple;
	bh=4WzfJn6owZvSthBUbsmc3wgpXMzI4ZEXlCKp/SWlH2A=;
	h=Date:To:From:Subject:Message-Id; b=if4+wjwGBLjJKn7xOP1TQCwFCPMPX6ogeMKhE0hYoK1VYcT2ulikX6BMh5pPveibcnXZXS5s+FYNFLP/8B77jbX4qxT7ITs4bAVL3hSRku1CIp12KNFBWVj1jkhKBpNlB+Ve11jI1MJSrgFJInOgiJtd5szEqPp54lf/wgwPqGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kRzPpxrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kRzPpxrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFF7C433F1;
	Wed, 28 Feb 2024 19:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709149902;
	bh=4WzfJn6owZvSthBUbsmc3wgpXMzI4ZEXlCKp/SWlH2A=;
	h=Date:To:From:Subject:From;
	b=kRzPpxrmIl5cyhH6tGmj7F44LVki1lJ634pd5GDA4a5AxPZMhfK9WWyVQrCfpZVfc
	 jqBA4FiKVNCRPCjQ3XKFX5X2Ter35/Gx8KYUDJ7NtFxYmFkJHOdgxb9UiN8uRW3lR4
	 yonvXVs4bHNhFZ+sVSndoLSvZ5eV/96Kuu3UzUw0=
Date: Wed, 28 Feb 2024 11:51:41 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,richardycc@google.com,minchan@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-alloc_contig_migrate_range-allocation-statistics-fix.patch added to mm-unstable branch
Message-Id: <20240228195142.0AFF7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-alloc_contig_migrate_range-allocation-statistics-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-alloc_contig_migrate_range-allocation-statistics-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-alloc_contig_migrate_range-allocation-statistics-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-alloc_contig_migrate_range-allocation-statistics-fix
Date: Wed Feb 28 11:42:35 AM PST 2024

fix typo/braino: trace_mm_alloc_config_migrate_range_info_enabled
should be trace_mm_alloc_contig_migrate_range_info_enabled.

Cc: Martin Liu <liumartin@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-add-alloc_contig_migrate_range-allocation-statistics-fix
+++ a/mm/page_alloc.c
@@ -6280,7 +6280,7 @@ int __alloc_contig_migrate_range(struct
 		ret = migrate_pages(&cc->migratepages, alloc_migration_target,
 			NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE, NULL);
 
-		if (trace_mm_alloc_config_migrate_range_info_enabled() && !ret)
+		if (trace_mm_alloc_contig_migrate_range_info_enabled() && !ret)
 			total_migrated += cc->nr_migratepages;
 
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch
mm-add-alloc_contig_migrate_range-allocation-statistics-fix.patch

