Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848DC14830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011005; cv=none; b=gQZ521F/Zo5c4iKEkrHbOBFcr9Hb/0Fq0d0xU4tpJ+biEuM9CvEU7r7Gy2U6+P+CkUNDqmy2c2VCr769qEEvZ8I8rI3r7YeK0mNyXllWTrgyZmGQ5McsZb1n9nJyk7/cjTYLErAOshHxj3I0QJrIS2tMBKr4fdsjwpmSlCdmrh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011005; c=relaxed/simple;
	bh=7iuZU+Q/YUxICLJq5vvqxdg8UEIvo13oW4mOuaT5JLY=;
	h=Date:To:From:Subject:Message-Id; b=KJ+XnjAi+xvCF0KTOXVr53VT1y2ope9B1prgt7XXrWa93mXk6/Eus9xzmwDHTXrIa+fLL0T7zYdkZuymfpjR+MAbfbENywpNfPaNQKXozXGX7QrJX+TVDzzuEhzW653jwO6MjSyjCIk8l1ibE+yp4JrLgpOA+6LJsNShZmHWlAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iwbyN7tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iwbyN7tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8BCC4CEE4;
	Mon, 12 May 2025 00:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011005;
	bh=7iuZU+Q/YUxICLJq5vvqxdg8UEIvo13oW4mOuaT5JLY=;
	h=Date:To:From:Subject:From;
	b=iwbyN7tr5zuunC6I50H9uUYbI+OPSE3VZm9cex6ejCZhGI08OSHkXMn/sPyuOZgGk
	 2XvTeBssoAR4Y8debFtFkyES+6OjpjQ8GL3P9tfW5aISTdypqkokTY9lBsVYrKgpgQ
	 VgJ6a2EIv7WHO3aiSOmafS34jGSdECiv3cw0OM0Y=
Date: Sun, 11 May 2025 17:50:04 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rrichter@amd.com,rppt@kernel.org,rafael.j.wysocki@intel.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,Jonathan.Cameron@huawei.com,ira.weiny@intel.com,hpa@zytor.com,haibo1.xu@intel.com,gregkh@linuxfoundation.org,fan.ni@samsung.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,bp@alien8.de,bfaccini@nvidia.com,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-probe-memory-block-size-advisement-value-during-mm-init.patch removed from -mm tree
Message-Id: <20250512005005.4F8BCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: probe memory block size advisement value during mm init
has been removed from the -mm tree.  Its filename was
     x86-probe-memory-block-size-advisement-value-during-mm-init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: x86: probe memory block size advisement value during mm init
Date: Mon, 27 Jan 2025 10:34:04 -0500

Systems with hotplug may provide an advisement value on what the memblock
size should be.  Probe this value when the rest of the configuration
values are considered.

The new heuristic is as follows

1) set_memory_block_size_order value if already set (cmdline param)
2) minimum block size if memory is less than large block limit
3) if no hotplug advice: Max block size if system is bare-metal,
   otherwise use end of memory alignment.
4) if hotplug advice: lesser of advice and end of memory alignment.

Convert to cpu_feature_enabled() while at it.[1]

[1] https://lore.kernel.org/all/20241031103401.GBZyNdGQ-ZyXKyzC_z@fat_crate.local/

Link: https://lkml.kernel.org/r/20250127153405.3379117-3-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: Borislav Petkov <bp@alien8.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bruno Faccini <bfaccini@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haibo Xu <haibo1.xu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Robert Richter <rrichter@amd.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-probe-memory-block-size-advisement-value-during-mm-init
+++ a/arch/x86/mm/init_64.c
@@ -1464,16 +1464,21 @@ static unsigned long probe_memory_block_
 	}
 
 	/*
-	 * Use max block size to minimize overhead on bare metal, where
-	 * alignment for memory hotplug isn't a concern.
+	 * When hotplug alignment is not a concern, maximize blocksize
+	 * to minimize overhead. Otherwise, align to the lesser of advice
+	 * alignment and end of memory alignment.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
+	bz = memory_block_advised_max_size();
+	if (!bz) {
 		bz = MAX_BLOCK_SIZE;
-		goto done;
+		if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+			goto done;
+	} else {
+		bz = max(min(bz, MAX_BLOCK_SIZE), MIN_MEMORY_BLOCK_SIZE);
 	}
 
 	/* Find the largest allowed block size that aligns to memory end */
-	for (bz = MAX_BLOCK_SIZE; bz > MIN_MEMORY_BLOCK_SIZE; bz >>= 1) {
+	for (; bz > MIN_MEMORY_BLOCK_SIZE; bz >>= 1) {
 		if (IS_ALIGNED(boot_mem_end, bz))
 			break;
 	}
_

Patches currently in -mm which might be from gourry@gourry.net are

cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed.patch
vmscancgroup-apply-mems_effective-to-reclaim.patch
dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch

