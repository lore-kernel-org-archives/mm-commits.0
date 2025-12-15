Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9512F0C68
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765818302; cv=none; b=sfLPsV4MVllx8m1z1uYrdmqAOJ7wtUy1b1YPto2qjE+5z4VjPz5V7dCiPRz8ax74m42kz2nsURLBDFLe46BCzYfcqhbB4fFynqN1c1jubmrYlg1mvFRTtpD536FgMXTcsGHb7RNsaqjIGswY0vygSisUzNFsUBSrQBq49UnMTIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765818302; c=relaxed/simple;
	bh=8oApPI9Ol45JT8wt3GrRDUbF7O6J1aiMJb13H497vIc=;
	h=Date:To:From:Subject:Message-Id; b=YBrYcOR+2kIhtWhfn8e0vY1nhDSFTUlAnWsI7uKPJ6DpWJzQYuTHdZFWtmoJkCjlI1pWHS+UK2CzeMaKKSOeGpaN351VrEwhhmUl3N2SwHMXXZEFCk9+mwKJqA96UeisQoxC9BdWqWOFg9SGbyXO54RXckFBYmvUTEojk34R0sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LRKkScZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LRKkScZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E802FC116B1;
	Mon, 15 Dec 2025 17:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765818302;
	bh=8oApPI9Ol45JT8wt3GrRDUbF7O6J1aiMJb13H497vIc=;
	h=Date:To:From:Subject:From;
	b=LRKkScZTe8UHJ3HatScI0dUlkajI9O+wjCPi74ow+zh42IY3OU1Q66eYl+FxTKlqd
	 tzVkAASv1+jjsG5wJ503+Ud2wRSHLiKd06RWHAF9YAFZ5ffzffPvQtL1+L7UXcLYzU
	 oIX4sLbGwTfsQbxzBqoROCPZVJ7/GWLhLVoeoPMU=
Date: Mon, 15 Dec 2025 09:05:01 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,joel.granados@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-move-memory_allocation_profiling_sysctls-into-rodata.patch added to mm-new branch
Message-Id: <20251215170501.E802FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: move memory_allocation_profiling_sysctls into .rodata
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-move-memory_allocation_profiling_sysctls-into-rodata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-move-memory_allocation_profiling_sysctls-into-rodata.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Joel Granados <joel.granados@kernel.org>
Subject: alloc_tag: move memory_allocation_profiling_sysctls into .rodata
Date: Mon, 15 Dec 2025 16:47:37 +0100

Remove the change in file mode permissions done before initializing the
sysctl.  It is not necessary as the writing of the kernel variable will be
blocked by the proc_mem_profiling_handler when writing is disallowed (also
controlled by mem_profiling_support).

Link: https://lkml.kernel.org/r/20251215-jag-alloc_tag_const-v1-1-35ea56a1ce13@kernel.org
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
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

alloc_tag-move-memory_allocation_profiling_sysctls-into-rodata.patch

