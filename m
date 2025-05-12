Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA9114830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011007; cv=none; b=eGLQxY4eW4qGtvbOcC3R2xwU0zwZfAG0hoJYe005azrxorR34Qse8VRxG9xf6eVNQB4ZIcsY8Jf1AAxPWAjA+WiPjslI9SsIqT8Rtc3t6LXfpcrduwn5CshN+KNcM0P17GT8DwFdrbB04LIkxBD3gJWdXir2cLAScA3aAI681RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011007; c=relaxed/simple;
	bh=dTh7niCJriLgT63dzZTqQ7Xw0+TRoUWqqYvrLtoZp5A=;
	h=Date:To:From:Subject:Message-Id; b=iGIdYCdgwp5+qYSdYF1fB3wMfvquqPtXaMRprCDs9aCyZnvtP84Q0BZu+I526NLO4CdSfWakHvJibgAIBwouVr+VWgc8PHbghxkLR07X2wD5/ic9tvh8c5Hot4I6tjMD0SGSIU2G8Ji2dL52Glqpj/uZyDil9jSA62AgHFxhpdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lBrSbyc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lBrSbyc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6061C4CEE4;
	Mon, 12 May 2025 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011006;
	bh=dTh7niCJriLgT63dzZTqQ7Xw0+TRoUWqqYvrLtoZp5A=;
	h=Date:To:From:Subject:From;
	b=lBrSbyc7gCPakJXJ7fLv/1NUiqfu4NJZ3mx4Czx7qBj95uB9dcAq90uBTTLeeDMXS
	 +wobjzEPm3VD3JFgrjYcsbN0p5PO/d0FEZU3QTf6jIY6iPyM7Af3xHBvjv/8puy2cf
	 Ha+TUflzWQNnwADk7X7KMSjj3AAj4u/B18BXxr7Y=
Date: Sun, 11 May 2025 17:50:06 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rrichter@amd.com,rppt@kernel.org,rafael.j.wysocki@intel.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,Jonathan.Cameron@huawei.com,ira.weiny@intel.com,hpa@zytor.com,haibo1.xu@intel.com,gregkh@linuxfoundation.org,fan.ni@samsung.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,bp@alien8.de,bfaccini@nvidia.com,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch removed from -mm tree
Message-Id: <20250512005006.C6061C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: acpi,srat: give memory block size advice based on CFMWS alignment
has been removed from the -mm tree.  Its filename was
     acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -429,13 +430,23 @@ static int __init acpi_parse_cfmws(union
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

cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed.patch
vmscancgroup-apply-mems_effective-to-reclaim.patch
dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch

