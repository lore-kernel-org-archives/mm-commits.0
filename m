Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CF92EEE7E
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 21:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786051251; cv=none; b=MT6KOvtvs8BTzCPKaviWa6+aAglyOwxdG9G+RZ0pEehmlqKeg2a506FQK/mPq+bU1EUpyY3D68FZ2c/nbhNqbKcmQkX8rTqL8LPvRDzhnpStbx0g/4wEhkd3zjzbAhl5JiUZacIW2Msx6cMX6rfoOe9pNeJF1JmMPqVMhv06lW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786051251; c=relaxed/simple;
	bh=lubhcJKnAz90e5hGpg3aNDMW4VIc3V1/Y5JxBtigzNA=;
	h=Date:To:From:Subject:Message-Id; b=ZRoKteL9UT5HV29eZsWEGVKZ6pXEKkxPJeSxA6GB8ongAfrCHzg7XfIkCU8Axw5C197zmA/8DLUl2moSpapupkL6UOUMlt4Btj8/VGT5fJq2zX/QCpLBSEUv9kkrNUHgSAoxPzCIU1uATaHCDO/aDNLPT0Y55RDxoRoof+gGO5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LWPLFmHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LWPLFmHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12351F000E9;
	Thu,  6 Aug 2026 21:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786051250;
	bh=gKcupTmVi/TVeph1/HFrM6utM+eK9IGs6U1gsnHJU6s=;
	h=Date:To:From:Subject;
	b=LWPLFmHQG3gbuwDLaaCP/TO342jkGqAA3+ft4mbtnXFaRT/PGZ0bjg/IhbrZ8s4M2
	 6fmHGK72UnrC8UAs8cIUh5iLbR1RDYtyfsHtlVQD0xPaJYk3jQxRMXz8dDusiDMFXD
	 sMCVSTVXm+GaqpTWNpNs00dCxDacL4Tdzb2Fza28=
Date: Thu, 06 Aug 2026 14:20:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shijianlin11@foxmail.com,mhocko@suse.com,joel.granados@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch added to mm-unstable branch
Message-Id: <20260806212049.F12351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
Date: Thu Aug  6 02:14:15 PM PDT 2026

add comment, per hannes

Link: https://lore.kernel.org/anSRGASe5FIrqwlg@cmpxchg.org
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jianlin Shi <shijianlin11@foxmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
+++ a/mm/page_alloc.c
@@ -6932,6 +6932,10 @@ static int lowmem_reserve_ratio_sysctl_h
 	if (!write)
 		return proc_dointvec_minmax(table, write, buffer, length, ppos);
 
+	/*
+	 * proc_dointvec_max() works incrementally. Use a buffer and only set
+	 * the values if all of them parse cleanly.
+	 */
 	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
 	tmp.data = ratio;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

