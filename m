Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F037C35F191
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236704; cv=none; b=BrfYtpLDkX4n5cg/wNYtPokK9FLgFJ9lmtRz3TTpRWYMd0mVqL9KwH/1KkEzbzw7xONFcLNPsOrGXxIR3cYtJA2BlxUKPOf9ZDaUpnwxeAI5mzMDEfSvGu8nH5ztkMDv0E6+7pAKL7DG5je8s8qGJgCE7rLS1j0Afkf7j7x6IrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236704; c=relaxed/simple;
	bh=qehlmtCJspNkfJnvjL2M70S72Zal0HQDnSHTNXCQ5xU=;
	h=Date:To:From:Subject:Message-Id; b=Qwevt/CC4LHGidbEI+UKR50j9zt7wuiJ+EsFkr4l2fICBHnibbYvSUrs4M2SNCyPi8SDR2/GZ8cxXZ/j3oR/lUENcbTUG5WZvc9i/ccEefclPcVRCzHT3DWwoNL1MsUh1nAXombJ+NVVT/TI0jzM4gLanePnUsdQwDTaGUykABo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MP08gPSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MP08gPSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E121F000E9;
	Sun,  5 Jul 2026 07:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236702;
	bh=QM/1kZtpox+TRXqacsYbVH6JDG3hqTKNlfPAXXHMhBU=;
	h=Date:To:From:Subject;
	b=MP08gPSKpanUWitfBHYn70bEeuNHZaChcqBTEPE52H0Ktbjo3rY8SAESs8hVpL95z
	 Kw2R98qvSBuMpCZeIPbi4BDG50KtpXhhmjQxCIo5rk8t+4T3ioZFIFeMdAf+Eb0ETs
	 9IxQxdgKunEXWIR920lpmHh1LBSPTOl/75wWU0rA=
Date: Sun, 05 Jul 2026 00:31:42 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sgi-xp-use-higher-level-allocator-api.patch added to mm-new branch
Message-Id: <20260705073142.A3E121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sgi-xp: use higher-level allocator API
has been added to the -mm mm-new branch.  Its filename is
     sgi-xp-use-higher-level-allocator-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sgi-xp-use-higher-level-allocator-api.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: sgi-xp: use higher-level allocator API
Date: Fri, 03 Jul 2026 12:31:51 +0000

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-11-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: Gemini:unknown-model
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-use-higher-level-allocator-api
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -170,9 +170,8 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = __alloc_pages_node(nid,
-				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
-				      pg_order);
+	page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
+				pg_order);
 	if (page == NULL) {
 		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to alloc %d "
 			"bytes of memory on nid=%d for GRU mq\n", mq_size, nid);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch
mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch

