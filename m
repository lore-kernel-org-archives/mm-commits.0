Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477FA2C3261
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 03:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748920260; cv=none; b=JYCNRoUYp5UwAKsWLTU8tp0dqzegD+qYWuflyyeEkB7TBhq/SfRzHKCzeURjC+uOxGZlEHRUSClu9VLx31xGTSJOtTU1WaGyi0NVAsRezo9g0fLm/mnQNf7ZeuA5U1GhOMYI09W/KIEI0Yie6lBD30BFgzCB6QCA12hJ81c+JTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748920260; c=relaxed/simple;
	bh=Wwyfm1h3kXIrtKbzeaYp2/IBpR0xe/uXv4rhvcJsM7o=;
	h=Date:To:From:Subject:Message-Id; b=GSkhXLAvKd4SawHqm2L2OYz3h9elWpdplYVfqlYUC1bIZ6dMLjLJINBNE8wW7F2FmZAiv2CvQc6b582VRE6a2lEejj8XPGWUbBtQsMrWTRpPzEagwKu930XRX4eEY1IXgAyRo7wb3QgZhjhAezRirmWFqGQuWVx8rLfl/+tTKEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UqfWVmix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UqfWVmix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A883BC4CEEB;
	Tue,  3 Jun 2025 03:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748920259;
	bh=Wwyfm1h3kXIrtKbzeaYp2/IBpR0xe/uXv4rhvcJsM7o=;
	h=Date:To:From:Subject:From;
	b=UqfWVmixqDIEEcjL86VQpVe5uFTzK8l1b+FdP4RkcQJ4T4hbey07CcpuIKgaRnr1i
	 AZ+tF2tMmxPRLxd3rCS9gBRZSwFgpB9xFyhqjM6c+c8mSeLx6j6A+ZEWFKvmOtfGOD
	 LK/Xnh0rTKlC5Y92tUVaBMiqRh5i07wgDmEwr7wA=
Date: Mon, 02 Jun 2025 20:10:59 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-alloc_tag-add-the-arch_needs_weak_per_cpu-macro-when-statically-defining-the-percpu-variable-alloc_tag_counters.patch added to mm-new branch
Message-Id: <20250603031059.A883BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/alloc_tag: add the ARCH_NEEDS_WEAK_PER_CPU macro when statically defining the percpu variable alloc_tag_counters.
has been added to the -mm mm-new branch.  Its filename is
     mm-alloc_tag-add-the-arch_needs_weak_per_cpu-macro-when-statically-defining-the-percpu-variable-alloc_tag_counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-alloc_tag-add-the-arch_needs_weak_per_cpu-macro-when-statically-defining-the-percpu-variable-alloc_tag_counters.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/alloc_tag: add the ARCH_NEEDS_WEAK_PER_CPU macro when statically defining the percpu variable alloc_tag_counters.
Date: Thu, 29 May 2025 15:35:37 +0800

Recently discovered this entry while checking kallsyms on ARM64:
ffff800083e509c0 D _shared_alloc_tag

If ARCH_NEEDS_WEAK_PER_CPU is not defined,there's no need to statically
define the percpu variable alloc_tag_counters.

Therefore, add the relevant macro guards at the appropriate location.

Link: https://lkml.kernel.org/r/20250529073537.563107-1-hao.ge@linux.dev
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/alloc_tag.c~mm-alloc_tag-add-the-arch_needs_weak_per_cpu-macro-when-statically-defining-the-percpu-variable-alloc_tag_counters
+++ a/lib/alloc_tag.c
@@ -24,8 +24,10 @@ static bool mem_profiling_support;
 
 static struct codetag_type *alloc_tag_cttype;
 
+#ifdef ARCH_NEEDS_WEAK_PER_CPU
 DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 EXPORT_SYMBOL(_shared_alloc_tag);
+#endif /* ARCH_NEEDS_WEAK_PER_CPU */
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-alloc_tag-add-the-arch_needs_weak_per_cpu-macro-when-statically-defining-the-percpu-variable-alloc_tag_counters.patch

