Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCDE380
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 22:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717194168; cv=none; b=uWnAGlXA9x6TVXlmvIpPIaB5QEcfQHXPEv8Po8YD+Z7if/+0ogvuf/yO9swpVh9q6nzamTBXfKTMJZVbqH5FNLo1+2SdKcvmg7RVTEYZwZiX7x5BQU0B4OsI1/JNOfetZLYkjgc9nLuuvMv4VMVlZqz4X3XeBY0f+Xw9CmjEemg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717194168; c=relaxed/simple;
	bh=WShHn79tg4/p9NSqw+fuykmq7ydY6WRx9jSBqYE1qzU=;
	h=Date:To:From:Subject:Message-Id; b=SRa6TsBal1wBE5j+J2zRZM+HZzwYn55K4tby0LZjbUyLFbveCeK7wl8XObDLPxDWNI3cG8Mf70aExE5qCII9j6fxIJqwYA7DxjaDg+cZMBkT+vMHvdtH9fRWq1PkNbeC00NjRMrPHGTL5VKoqHA1B6MoAo7Cb7UoLLRgReZ1XXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VRBewOd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VRBewOd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECCBC116B1;
	Fri, 31 May 2024 22:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717194168;
	bh=WShHn79tg4/p9NSqw+fuykmq7ydY6WRx9jSBqYE1qzU=;
	h=Date:To:From:Subject:From;
	b=VRBewOd85TNW4frxZ4PnvoJShE7It85LTxWY7LpLYAR0cS6FcF9mVQWRS9zr1Z/AL
	 XpJqhYVi2BUGGZhRwj4k9ZGhRO0KmzOAswm9YZuPwP/UE5xeLmtVs+VY8r3HZDTc1k
	 WD9F3kGX3f0vtI8ZG0eCdcbyQ/Sqm96fKdmLmJ6E=
Date: Fri, 31 May 2024 15:22:47 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,reinette.chatre@intel.com,peternewman@google.com,maciej.wieczor-retman@intel.com,james.morse@arm.com,gregkh@linuxfoundation.org,fenghua.yu@intel.com,dfustini@baylibre.com,Dave.Martin@arm.com,bp@alien8.de,babu.moger@amd.com,tony.luck@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch added to mm-nonmm-unstable branch
Message-Id: <20240531222248.0ECCBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/resctrl: replace open code cacheinfo search in rdtgroup_cbm_to_size()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch

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

cacheinfo-add-function-to-get-cacheinfo-for-a-given-cpu-cachelevel.patch
x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init.patch
x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch

