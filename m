Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EED261FD3
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 02:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554200; cv=none; b=L9+ZpsEgBbbiSg3udd6M16IKpFZ2o9dt5oWubo3Q0oEpwh2fY7keSTwyk3d71y2fJN0Fzl4hzItikKv58DWkI2OTsuoaRvMwHYwimD9y/eF5TO+3ozvLLv/5TgEiYYAnLI78BNvz2BkhBXxR4UQZk3Dh1flXOvruWE6lrD0bybA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554200; c=relaxed/simple;
	bh=DBBwCaH2dOLKhLo6Mb6AhPf/H+UkfgvRX8RHCbH8bzY=;
	h=Date:To:From:Subject:Message-Id; b=B/iZq084c86Zta9FLyPFX/Wdekc9VrxK+Z/t2fWZJR60AUGaMhFZltSl+X8RALwQcWaXxKtHa6limx/fad9sFtssVUCafYdIyH8lnMqYL/4unOUjTu+RA0DxvhOJsZ1oHCAK9SXNdJ4OayhzEUWXfxbHwcXOT3TEK5gbwxdpPAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oL6Yop+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oL6Yop+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C54FC2BBFC;
	Wed,  5 Jun 2024 02:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717554200;
	bh=DBBwCaH2dOLKhLo6Mb6AhPf/H+UkfgvRX8RHCbH8bzY=;
	h=Date:To:From:Subject:From;
	b=oL6Yop+YTIJTGhoMs7Fdpz8MMoKPqvf+++tjTo2bNYsnvoAVGIxSXdUQoFINJS2/N
	 8FkhcfF40CmY6rR20Xn+OWRHMMNN/z0Ag+XeKNOz9BxOhBV95lIiUkxBmf2CehCkp1
	 1VrBQgJupbHSYulWYlYXnG4T2ZmWdZq8ZZ/Yz7Wo=
Date: Tue, 04 Jun 2024 19:23:19 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,reinette.chatre@intel.com,peternewman@google.com,maciej.wieczor-retman@intel.com,james.morse@arm.com,gregkh@linuxfoundation.org,fenghua.yu@intel.com,dfustini@baylibre.com,Dave.Martin@arm.com,bp@alien8.de,babu.moger@amd.com,tony.luck@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch removed from -mm tree
Message-Id: <20240605022320.1C54FC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/resctrl: replace open code cacheinfo search in rdtgroup_cbm_to_size()
has been removed from the -mm tree.  Its filename was
     x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: x86/resctrl: replace open code cacheinfo search in rdtgroup_cbm_to_size()
Date: Fri, 31 May 2024 12:57:20 -0700

Use get_cpu_cacheinfo_level() instead of open coded search.

Link: https://lkml.kernel.org/r/20240531195720.232561-4-tony.luck@intel.com
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

 arch/x86/kernel/cpu/resctrl/rdtgroup.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c~x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size
+++ a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1450,18 +1450,14 @@ out:
 unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
 				  struct rdt_domain *d, unsigned long cbm)
 {
-	struct cpu_cacheinfo *ci;
+	struct cacheinfo *ci;
 	unsigned int size = 0;
-	int num_b, i;
+	int num_b;
 
 	num_b = bitmap_weight(&cbm, r->cache.cbm_len);
-	ci = get_cpu_cacheinfo(cpumask_any(&d->cpu_mask));
-	for (i = 0; i < ci->num_leaves; i++) {
-		if (ci->info_list[i].level == r->cache_level) {
-			size = ci->info_list[i].size / r->cache.cbm_len * num_b;
-			break;
-		}
-	}
+	ci = get_cpu_cacheinfo_level(cpumask_any(&d->cpu_mask), r->cache_level);
+	if (ci)
+		size = ci->size / r->cache.cbm_len * num_b;
 
 	return size;
 }
_

Patches currently in -mm which might be from tony.luck@intel.com are


