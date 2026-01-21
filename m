Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F1030F92E
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768965992; cv=none; b=SvjAT4ov4Ed3fkxdgofYlDuiiWhIGKZwk1abuUHT3ULfHe7dt94rVQEQ0kbeyNGceGNu8be4i4NueHsQo1tl8RGl639mJJ78smWKcp3eMqud5WwSaem5pD3oCDmGhRhu4zPUU7DspTrZQsFZyCKrh54pEd6Xrf1bDs2TsE6Xc+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768965992; c=relaxed/simple;
	bh=DSPPePSg3F4YdNx2AZ0vsXWd8O4KNtggWjKyOpRGa4A=;
	h=Date:To:From:Subject:Message-Id; b=ViZzelY1/sfvsOc6mYIFEJDwL7ZQdrvI2L2a8lk9rOQ2Jb71ZkgE3Ve2XAeGfvZa8rHliC1L+qQkHhAzbtbEZY+oufM2qvcHI6Q1Eyaq2V725zcr9NfBwPyY5cuvrvL59X8VKHmdef4hB1R98PU+Mjf9L8O/5/FH2PcEcVqon8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UCYZ1sVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UCYZ1sVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2883C19423;
	Wed, 21 Jan 2026 03:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768965991;
	bh=DSPPePSg3F4YdNx2AZ0vsXWd8O4KNtggWjKyOpRGa4A=;
	h=Date:To:From:Subject:From;
	b=UCYZ1sVsge08552s4I8PNpeU1w2gyvtQ+rFyPVji3LSVIqLYMrQVdv3diF1nZN2DT
	 h9VOlkqIPg7i2n2oiMBBYhsSr06cY07+xO2BJQ5/IgRFFsnVL1HtRYmPsfnODBdr4p
	 0EkoGure6NmwfYIFM7k/rJxoHOrN1hhDpbRdZbTg=
Date: Tue, 20 Jan 2026 19:26:31 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,joel.granados@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-move-memory_allocation_profiling_sysctls-into-rodata.patch removed from -mm tree
Message-Id: <20260121032631.D2883C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: move memory_allocation_profiling_sysctls into .rodata
has been removed from the -mm tree.  Its filename was
     alloc_tag-move-memory_allocation_profiling_sysctls-into-rodata.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joel Granados <joel.granados@kernel.org>
Subject: alloc_tag: move memory_allocation_profiling_sysctls into .rodata
Date: Mon, 15 Dec 2025 16:47:37 +0100

Remove the change in file mode permissions done before initializing the
sysctl.  It is not necessary as the writing of the kernel variable will be
blocked by the proc_mem_profiling_handler when writing is disallowed (also
controlled by mem_profiling_support).

Link: https://lkml.kernel.org/r/20251215-jag-alloc_tag_const-v1-1-35ea56a1ce13@kernel.org
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-move-memory_allocation_profiling_sysctls-into-rodata
+++ a/lib/alloc_tag.c
@@ -783,7 +783,7 @@ static int proc_mem_profiling_handler(co
 }
 
 
-static struct ctl_table memory_allocation_profiling_sysctls[] = {
+static const struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
 		.data		= &mem_alloc_profiling_key,
@@ -798,9 +798,6 @@ static struct ctl_table memory_allocatio
 
 static void __init sysctl_init(void)
 {
-	if (!mem_profiling_support)
-		memory_allocation_profiling_sysctls[0].mode = 0444;
-
 	register_sysctl_init("vm", memory_allocation_profiling_sysctls);
 }
 #else /* CONFIG_SYSCTL */
_

Patches currently in -mm which might be from joel.granados@kernel.org are


