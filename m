Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5218F61FD3
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 02:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554199; cv=none; b=YP3f0xAcBTsqlHm0cGMJWNzuBgGSK4UYL3SSOnKQdxquWb9GlIKCnmpOoK+j136u7hckVPvaTVZcBdoTXnmgwuLq9vD83zOSnAqG7SLTk4ZUI8JQWqFVRu+VD0fNOLEkHImLHTi52M8sUhvsLtrVwcC1bu8zrRLMy4SjF8c2TRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554199; c=relaxed/simple;
	bh=QwmyC7uvGP2RtLC+ncGuWf+YN0o/2tTgfYr4+2dl/ew=;
	h=Date:To:From:Subject:Message-Id; b=kirXJz2yGmG7xt8NhQk+2DqJ2aBiDY/ce05Eq616dHbw0s/TZARtvpZgFQyTCHLfEECml5wx2xY5apkN5gcOO0g4aLQstbsgB2v59myR3+SjkIcCViuWTHES+v1l98OjfsoNlVAje5AoMsgYbWBHIpdGPZSsfgwFRKYe7lJ6AC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UehC22A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UehC22A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAFEC2BBFC;
	Wed,  5 Jun 2024 02:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717554198;
	bh=QwmyC7uvGP2RtLC+ncGuWf+YN0o/2tTgfYr4+2dl/ew=;
	h=Date:To:From:Subject:From;
	b=UehC22A5DuunJpunHG/JF6XIaF/DcR8aZ3MDbzDUHYXk/OFa48gxkZbyIW1fc7UO/
	 bI8Evqf5dfSkxaVNaYMwf73lFIj8WYOGWrFdHG7tieK8Pv4O+Vvzr2i2WBarhm99M0
	 gTLYf7BdtjX54+XqYZE0XQoqmCEFA0K6JAZcfIUM=
Date: Tue, 04 Jun 2024 19:23:18 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,reinette.chatre@intel.com,peternewman@google.com,maciej.wieczor-retman@intel.com,james.morse@arm.com,gregkh@linuxfoundation.org,fenghua.yu@intel.com,dfustini@baylibre.com,Dave.Martin@arm.com,bp@alien8.de,babu.moger@amd.com,tony.luck@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init.patch removed from -mm tree
Message-Id: <20240605022318.DBAFEC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/resctrl: replace open code cacheinfo search in pseudo_lock_region_init()
has been removed from the -mm tree.  Its filename was
     x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init.patch

This patch was dropped because it is obsolete

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

x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch

