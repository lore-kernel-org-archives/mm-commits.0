Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FE9380
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 22:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717194166; cv=none; b=h8VY47N3DSnDF0epTLyjZXFLd8B0/X7YujjcKzRRBD7AGGEcnulVxMqKlo+3eA7AvPySyMU+1ccltznEk4HeOJNM053GaVWEq2m3bIWgR3YKhcRBrUgGdpdPK9YbA4x/6bCjNqqtaK5QoVy9PERleiomsWukZah4QNAFz8SBUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717194166; c=relaxed/simple;
	bh=c5L1qjq1p39Xm1v5D7s8Gq/iCAeBXieohVEZlQLY98E=;
	h=Date:To:From:Subject:Message-Id; b=r+ihKDKd7a1a8dDPxGt2UFEhZUMSdZp+LgmmKo0nbcytRAqOfgz7SsYs6JjbDw0zHsYsLsM6Nt5/2vfnwSrd0Vd2tieP3UZQmIyBGps6XsKEEuJiKl1Aa9HTDr6jyaSYxcQRN42kc9005HVXLSRMDp7iCE5FXIK+lU9FLUAetZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bGflRafK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bGflRafK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48290C116B1;
	Fri, 31 May 2024 22:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717194166;
	bh=c5L1qjq1p39Xm1v5D7s8Gq/iCAeBXieohVEZlQLY98E=;
	h=Date:To:From:Subject:From;
	b=bGflRafK9SbXF2gqt0Qqt9X4H0CJ0TQm/4VvWryYSnkL1YJX6zUs0LbwATrxLgoUU
	 +EIhPJyuwpeXf6mUOfuk3UYIqrTNkR6DMPBD9+1FHypsZ3hWWFR5k/AYbcNIKx8cK7
	 YX1cCJB4yBkjRD9eyxIbBkefjzwwvNGVtgXZy0wc=
Date: Fri, 31 May 2024 15:22:45 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,reinette.chatre@intel.com,peternewman@google.com,maciej.wieczor-retman@intel.com,james.morse@arm.com,gregkh@linuxfoundation.org,fenghua.yu@intel.com,dfustini@baylibre.com,Dave.Martin@arm.com,bp@alien8.de,babu.moger@amd.com,tony.luck@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init.patch added to mm-nonmm-unstable branch
Message-Id: <20240531222246.48290C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/resctrl: replace open code cacheinfo search in pseudo_lock_region_init()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init.patch

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
From: Tony Luck <tony.luck@intel.com>
Subject: x86/resctrl: replace open code cacheinfo search in pseudo_lock_region_init()
Date: Fri, 31 May 2024 12:57:19 -0700

Use get_cpu_cacheinfo_level() instead of open coded search.

Link: https://lkml.kernel.org/r/20240531195720.232561-3-tony.luck@intel.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Babu Moger <babu.moger@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Drew Fustini <dfustini@baylibre.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Morse <james.morse@arm.com>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Peter Newman <peternewman@google.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c~x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init
+++ a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -292,9 +292,8 @@ static void pseudo_lock_region_clear(str
  */
 static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
 {
-	struct cpu_cacheinfo *ci;
+	struct cacheinfo *ci;
 	int ret;
-	int i;
 
 	/* Pick the first cpu we find that is associated with the cache. */
 	plr->cpu = cpumask_first(&plr->d->cpu_mask);
@@ -306,15 +305,11 @@ static int pseudo_lock_region_init(struc
 		goto out_region;
 	}
 
-	ci = get_cpu_cacheinfo(plr->cpu);
-
-	plr->size = rdtgroup_cbm_to_size(plr->s->res, plr->d, plr->cbm);
-
-	for (i = 0; i < ci->num_leaves; i++) {
-		if (ci->info_list[i].level == plr->s->res->cache_level) {
-			plr->line_size = ci->info_list[i].coherency_line_size;
-			return 0;
-		}
+	ci = get_cpu_cacheinfo_level(plr->cpu, plr->s->res->cache_level);
+	if (ci) {
+		plr->line_size = ci->coherency_line_size;
+		plr->size = rdtgroup_cbm_to_size(plr->s->res, plr->d, plr->cbm);
+		return 0;
 	}
 
 	ret = -1;
_

Patches currently in -mm which might be from tony.luck@intel.com are

cacheinfo-add-function-to-get-cacheinfo-for-a-given-cpu-cachelevel.patch
x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init.patch
x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch

