Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640877465
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 00:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600339; cv=none; b=Dp6n/2Nj/wXqr8JgLUNHI/qhBd9k03Rvm4onXd21kZdqdgA8RvR1jF4luPNmkSCmFKQZcrrWIWxLVoQIjZA3YzeTwCAd6TwgmkdqJ0NEz8TnKojw7hdgNQBHR3gAEPOZQluizylFvA0L//R9ZcU/hIFCMLT4suEU85Dy5krd1pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600339; c=relaxed/simple;
	bh=xVFTZ6ZvirPITHQuC+0fp5T4Fh+WMn0t4Zz6tSPQruA=;
	h=Date:To:From:Subject:Message-Id; b=KL9IoFs8scD+4yqJn9PRubq79nljBbdHvXJFUya7rbH2ryW7IOgZxKacbh+QtPVzOrbxdqcNOuPe46mnrCmnog/6NYqifRAXZKcYPdw9m6y4/UFFY6pMmpkeHpTChTLx7Q8OpX0w8uXtIsRFZDKHm1ykh1gyvUucDS8H5yHEHOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SHa6bSoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SHa6bSoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8888C433C7;
	Tue,  5 Mar 2024 00:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600338;
	bh=xVFTZ6ZvirPITHQuC+0fp5T4Fh+WMn0t4Zz6tSPQruA=;
	h=Date:To:From:Subject:From;
	b=SHa6bSoKBd9aKTVreY1/sjzPal2Co8xcNUXh58kEoC3OlBbcCluwGWoTbMxrjmo5I
	 ONHbO1UU5xI/869GmJk0FFVjbiCUEnBtLgsK/uYCMysKsIy3mtWwS0srHUNO7NHtwC
	 jdEvI/PbnC6fbNebTSlLXt2U3VKtalCP3RZAYiQI=
Date: Mon, 04 Mar 2024 16:58:58 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,richardycc@google.com,minchan@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-alloc_contig_migrate_range-allocation-statistics-fix.patch removed from -mm tree
Message-Id: <20240305005858.D8888C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-alloc_contig_migrate_range-allocation-statistics-fix
has been removed from the -mm tree.  Its filename was
     mm-add-alloc_contig_migrate_range-allocation-statistics-fix.patch

This patch was dropped because it was folded into mm-add-alloc_contig_migrate_range-allocation-statistics.patch

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

mm-add-alloc_contig_migrate_range-allocation-statistics.patch
hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-add-__dump_folio-fix-3-fix.patch

