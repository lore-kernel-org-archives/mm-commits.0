Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDFF189F39
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743648738; cv=none; b=VMGe7O3pZC8ZGnoBpjmeckwN2ZXSO53CwcSh+RG9fzVrg6OwHvyW+8gZ+A3iMTKxR+0BGzw+hIoPMCSCgKfvDeOsKdyQjNPAi3NU+o9bSoUvKE9wqxbljgwbX+RBjxoshopxai5OhITal08Er8ivJjwrDxAhgooHkZqkNul6/HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743648738; c=relaxed/simple;
	bh=gUZuuN2NXZhg33xI/Cdn1W9NHs/fqWrLZUDPZPyNrEo=;
	h=Date:To:From:Subject:Message-Id; b=BswOBtqfgH25pjcaNfHwfacqVYgokMtUVd/JL3BLKzKkW/2Vm3XhjCfgckcE9yb/z46Et5fVoOBQcrGPfwWhlk+lAQgoVBLkFVNorsP+CBcBFMDOZJmxQTWeu41oWJmjvYGkevshoqfsH0XQ+tqYaBvxfod26cR2LDwA0AEGrOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZ1qNRdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZ1qNRdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B85C4CEDD;
	Thu,  3 Apr 2025 02:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743648738;
	bh=gUZuuN2NXZhg33xI/Cdn1W9NHs/fqWrLZUDPZPyNrEo=;
	h=Date:To:From:Subject:From;
	b=FZ1qNRdV8FWESScyWgdQlj+vJlTiyyC984ldS2JVzPps+h1ThxfaI4w6mSbMaen33
	 FgmtQzpxU2XXJ+ackvjNSbOHpiILP78EwPVKmS6W5wbDNo5dQoRVk/dx8HoFTU3Zhs
	 abn/X/YZIim5eHO33sN89fiHir1XHTdgR8hEPlao=
Date: Wed, 02 Apr 2025 19:52:17 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rrichter@amd.com,rppt@kernel.org,rafael.j.wysocki@intel.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,Jonathan.Cameron@huawei.com,ira.weiny@intel.com,hpa@zytor.com,haibo1.xu@intel.com,gregkh@linuxfoundation.org,fan.ni@samsung.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,bp@alien8.de,bfaccini@nvidia.com,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch added to mm-new branch
Message-Id: <20250403025218.24B85C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: acpi,srat: give memory block size advice based on CFMWS alignment
has been added to the -mm mm-new branch.  Its filename is
     acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch

This patch will later appear in the mm-new branch at
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
From: Gregory Price <gourry@gourry.net>
Subject: acpi,srat: give memory block size advice based on CFMWS alignment
Date: Mon, 27 Jan 2025 10:34:05 -0500

Capacity is stranded when CFMWS regions are not aligned to block size.  On
x86, block size increases with capacity (2G blocks @ 64G capacity).

Use CFMWS base/size to report memory block size alignment advice.

Link: https://lkml.kernel.org/r/20250127153405.3379117-4-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Fan Ni <fan.ni@samsung.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Bruno Faccini <bfaccini@nvidia.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haibo Xu <haibo1.xu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rrichter@amd.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/srat.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/acpi/numa/srat.c~acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment
+++ a/drivers/acpi/numa/srat.c
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/acpi.h>
 #include <linux/memblock.h>
+#include <linux/memory.h>
 #include <linux/numa.h>
 #include <linux/nodemask.h>
 #include <linux/topology.h>
@@ -435,13 +436,23 @@ static int __init acpi_parse_cfmws(union
 {
 	struct acpi_cedt_cfmws *cfmws;
 	int *fake_pxm = arg;
-	u64 start, end;
+	u64 start, end, align;
 	int node;
+	int err;
 
 	cfmws = (struct acpi_cedt_cfmws *)header;
 	start = cfmws->base_hpa;
 	end = cfmws->base_hpa + cfmws->window_size;
 
+	/* Align memblock size to CFMW regions if possible */
+	align = 1UL << __ffs(start | end);
+	if (align >= SZ_256M) {
+		err = memory_block_advise_max_size(align);
+		if (err)
+			pr_warn("CFMWS: memblock size advise failed (%d)\n", err);
+	} else
+		pr_err("CFMWS: [BIOS BUG] base/size alignment violates spec\n");
+
 	/*
 	 * The SRAT may have already described NUMA details for all,
 	 * or a portion of, this CFMWS HPA range. Extend the memblks
_

Patches currently in -mm which might be from gourry@gourry.net are

memory-implement-memory_block_advise-probe_max_size.patch
x86-probe-memory-block-size-advisement-value-during-mm-init.patch
acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch

