Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE8DCA64
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 01:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736903168; cv=none; b=W8lpUGvk7PltTxAHD4sui8qWX6mvbOL0lj/Qb0cG/URIFgCFrUU/KOkxhccyPu1G6qQry8wzUeec7firCUoCzqNYUhxWRJ1gUm/hB0USgjEvUvKXozNjenBtXKrXDkidOVWp16g3UsBeY8gZ7qIN7sNIx5fFl3OmteWa2qAU1QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736903168; c=relaxed/simple;
	bh=yN/gL4TmZmXwuOYNCEvuSRdd5rrUwvGrA8NA8/hOEnU=;
	h=Date:To:From:Subject:Message-Id; b=ZMj2oytKt//dmcur3MbQdrmsQOnmdKJj3466NJ4XLkAX3gWP8re2PStqQaiGlBYHuzsOt2Hsl28f3/jmwBOExcB5PVQn9nYhNCstsWx2DpT6F9gJK7X7IqIawfcc9OFCaYFm35AES2N8/fum67QDNTj6Mk1DX9NIR0g/Yqhjd5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdS9YOQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdS9YOQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847AFC4CEDD;
	Wed, 15 Jan 2025 01:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736903167;
	bh=yN/gL4TmZmXwuOYNCEvuSRdd5rrUwvGrA8NA8/hOEnU=;
	h=Date:To:From:Subject:From;
	b=ZdS9YOQmQb2XSt2lgAgC8XsX70HGkVVfRTmrvLA+9WBBbMiRV2JAjbFuDTkD2kpXH
	 AvWmZY7KJ1q9dMePloXDTBmKoQikR6RjZ24llpVC77HuUoOslpDw7aVK5QwyFlQGH+
	 fldVC4jlYQcXEjnJWrbpEMDF7ylN+HT9hAUfqMdY=
Date: Tue, 14 Jan 2025 17:06:06 -0800
To: mm-commits@vger.kernel.org,ville.syrjala@linux.intel.com,rppt@kernel.org,mingo@redhat.com,bp@alien8.de,peterz@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] x86-disable-execmem_rox-support.patch removed from -mm tree
Message-Id: <20250115010607.847AFC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: disable EXECMEM_ROX support
has been removed from the -mm tree.  Its filename was
     x86-disable-execmem_rox-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: x86: disable EXECMEM_ROX support
Date: Mon, 13 Jan 2025 12:29:34 +0100

module_writable_address() made a mess of alternative.c, and it still
contains bugs -- notably some of the CFI variants crash and burn.

Mike has been working on patches to clean all this up again, but given the
current state of things, this stuff just isn't ready.

Disable for now, lets try again next cycle.

Link: https://lkml.kernel.org/r/20250113112934.GA8385@noisy.programming.kicks-ass.net
Fixes: 5185e7f9f3bd ("x86/module: enable ROX caches for module text on 64 bit")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Ville Syrjl <ville.syrjala@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/Kconfig~x86-disable-execmem_rox-support
+++ a/arch/x86/Kconfig
@@ -83,7 +83,6 @@ config X86
 	select ARCH_HAS_DMA_OPS			if GART_IOMMU || XEN
 	select ARCH_HAS_EARLY_DEBUG		if KGDB
 	select ARCH_HAS_ELF_RANDOMIZE
-	select ARCH_HAS_EXECMEM_ROX		if X86_64
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
_

Patches currently in -mm which might be from peterz@infradead.org are


