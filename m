Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996A7189F39
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743648737; cv=none; b=aPxwnAHOkQhhuAb7YRbulutNUWaLTnMQVYHhDYwnzo9ITHd2KLUutn7NjLvugMLjZ/viDqjT+FjSvRL60eIVdIW6BlJH7dJJsCaXpkAv5qHMesciI0bDROHi9FvlHIqx/webwnGNQhzTWb0jTl6IkeuRU5Sx9kRVwBN8IFBryIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743648737; c=relaxed/simple;
	bh=tLZX8+10kYw9IBElAjBivuYGJ9ccKZk2ekO+r8p6f4s=;
	h=Date:To:From:Subject:Message-Id; b=ps6LrzDEK31QnLMCg3BaXVQLQTbo4r4LlYcUyQNaLNXS+qPJaAFuTyN63DFCuCZoV92SqKCOqZHYX96ZY4i4n5wL/NC3jroNZ9frSbofLztw66oHkeieQpfwOc3gFJXxluTboUywm+7eZYJgUvXTDt5M98ECX7JMMo65xTl32Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ndDFT3da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ndDFT3da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CE6C4CEDD;
	Thu,  3 Apr 2025 02:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743648736;
	bh=tLZX8+10kYw9IBElAjBivuYGJ9ccKZk2ekO+r8p6f4s=;
	h=Date:To:From:Subject:From;
	b=ndDFT3da9AXXeSTwT+i8r5ZjFsZ6a8XMf6ujlMhriw0UuApIkMpRfMldRN4y7nzmh
	 XnxUaD2KDNH8pfciTXh/EWdvpQ67b1+pdCRl+87xgR2oPUTVxoNXAGd5AO/cVlvgWa
	 IVn2hxgmxG8Nz4EIeDUSuNDt2uaKUbU6L2z47k2A=
Date: Wed, 02 Apr 2025 19:52:15 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rrichter@amd.com,rppt@kernel.org,rafael.j.wysocki@intel.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,Jonathan.Cameron@huawei.com,ira.weiny@intel.com,hpa@zytor.com,haibo1.xu@intel.com,gregkh@linuxfoundation.org,fan.ni@samsung.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,bp@alien8.de,bfaccini@nvidia.com,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-probe-memory-block-size-advisement-value-during-mm-init.patch added to mm-new branch
Message-Id: <20250403025215.E1CE6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: probe memory block size advisement value during mm init
has been added to the -mm mm-new branch.  Its filename is
     x86-probe-memory-block-size-advisement-value-during-mm-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-probe-memory-block-size-advisement-value-during-mm-init.patch

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
@@ -1455,16 +1455,21 @@ static unsigned long probe_memory_block_
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

memory-implement-memory_block_advise-probe_max_size.patch
x86-probe-memory-block-size-advisement-value-during-mm-init.patch
acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch

