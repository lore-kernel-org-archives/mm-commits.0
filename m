Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A0FDDDF
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 02:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554197; cv=none; b=fsz3wzh9cou1ElVE2eIO3RCxY95A25n/hhpqwaFlPNCWck8ivVeeTsHYQkkZRw4Oz6fKpWEt6qj3b+GjQeHVyBUyYQlBIIOejje2nJZNDe8+MH4IeXnMQbUjbYQWK0LXilJU71l8fhsDKi3hHd9O+42LSOcSEdHlja//35iPODg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554197; c=relaxed/simple;
	bh=TkvCVHjC3rIZR2MdvyKaNlbmJRTAvth0UpIaiN/mAHU=;
	h=Date:To:From:Subject:Message-Id; b=huvmYSvQ4tFD4Pc+QksEioeHgt9hIS+P6RczEgv93qnFsCpgtlSG9ywKuIY17lMU+VXOPsqrL3Z1SmSipIZu2srAzZwQRmFNlMwiVmgxt5scaXw69+lbH8zFFewouq9PTgMHNQtT0ax11Et/ASg4QIOAULriKmN4xSPuN2RrWJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kaxvkSxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kaxvkSxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676F9C4AF07;
	Wed,  5 Jun 2024 02:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717554197;
	bh=TkvCVHjC3rIZR2MdvyKaNlbmJRTAvth0UpIaiN/mAHU=;
	h=Date:To:From:Subject:From;
	b=kaxvkSxN4nCfTLia6LZ0IaZwqMW8C9VPpYnBkBq1Y2T/xHL6bDyEG0rNQRDV0un9e
	 t1g4jFhlIQiXQOqTyCjBi/GzBuCj3OAL8zGTTkQASQXlepZBdkNkLAYqj11tZzae1j
	 9ErEaGLtYXLAXPYJg5VtTce0+M1qgHMwd7m0SjCE=
Date: Tue, 04 Jun 2024 19:23:16 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,reinette.chatre@intel.com,peternewman@google.com,maciej.wieczor-retman@intel.com,james.morse@arm.com,gregkh@linuxfoundation.org,fenghua.yu@intel.com,dfustini@baylibre.com,Dave.Martin@arm.com,bp@alien8.de,babu.moger@amd.com,tony.luck@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] cacheinfo-add-function-to-get-cacheinfo-for-a-given-cpu-cachelevel.patch removed from -mm tree
Message-Id: <20240605022317.676F9C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cacheinfo: add function to get cacheinfo for a given (cpu, cachelevel)
has been removed from the -mm tree.  Its filename was
     cacheinfo-add-function-to-get-cacheinfo-for-a-given-cpu-cachelevel.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: cacheinfo: add function to get cacheinfo for a given (cpu, cachelevel)
Date: Fri, 31 May 2024 12:57:18 -0700

Patch series "Add and use get_cpu_cacheinfo_level()".

This helper function came up in discussion of the resctrl patches for
Sub-NUMA Cluster (SNC) support.  Reinette pointed out[1] that there are
already two places where it would clean things up by avoiding open coding.
The SNC patches will add two additional call sites.

So rather than have this jammed up as part of the SNC series, I'm posting
it as a simple standalone cleanup.

[1] https://lore.kernel.org/all/050c64b3-20b3-4db6-b782-f5124ebaab31@intel.com/


This patch (of 3):

Resctrl code open codes a search for information about a given cache level
in a couple of places (and more are on the way).

Provide a new inline function get_cpu_cacheinfo_level() in
<linux/cacheinfo.h> to do the search and return a pointer to the cacheinfo
structure.

Simplify the existing get_cpu_cacheinfo_id() by using this new function to
do the search.

Link: https://lkml.kernel.org/r/20240531195720.232561-1-tony.luck@intel.com
Link: https://lkml.kernel.org/r/20240531195720.232561-2-tony.luck@intel.com
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
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cacheinfo.h |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/include/linux/cacheinfo.h~cacheinfo-add-function-to-get-cacheinfo-for-a-given-cpu-cachelevel
+++ a/include/linux/cacheinfo.h
@@ -113,10 +113,10 @@ int acpi_get_cache_info(unsigned int cpu
 const struct attribute_group *cache_get_priv_group(struct cacheinfo *this_leaf);
 
 /*
- * Get the id of the cache associated with @cpu at level @level.
+ * Get the cacheinfo structure for cache associated with @cpu at level @level.
  * cpuhp lock must be held.
  */
-static inline int get_cpu_cacheinfo_id(int cpu, int level)
+static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
 {
 	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
 	int i;
@@ -124,12 +124,23 @@ static inline int get_cpu_cacheinfo_id(i
 	for (i = 0; i < ci->num_leaves; i++) {
 		if (ci->info_list[i].level == level) {
 			if (ci->info_list[i].attributes & CACHE_ID)
-				return ci->info_list[i].id;
-			return -1;
+				return &ci->info_list[i];
+			return NULL;
 		}
 	}
 
-	return -1;
+	return NULL;
+}
+
+/*
+ * Get the id of the cache associated with @cpu at level @level.
+ * cpuhp lock must be held.
+ */
+static inline int get_cpu_cacheinfo_id(int cpu, int level)
+{
+	struct cacheinfo *ci = get_cpu_cacheinfo_level(cpu, level);
+
+	return ci ? ci->id : -1;
 }
 
 #ifdef CONFIG_ARM64
_

Patches currently in -mm which might be from tony.luck@intel.com are

x86-resctrl-replace-open-code-cacheinfo-search-in-pseudo_lock_region_init.patch
x86-resctrl-replace-open-code-cacheinfo-search-in-rdtgroup_cbm_to_size.patch

