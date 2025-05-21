Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4836A17A310
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846637; cv=none; b=sRF6zb09QH520jtol/eXePyriiQrNnBsU4FebN2QQU9r2Ze3vOmlezEtSeSq1sT8547d3Bn5/DQyVqnNri8RG1GlIIzufkaE55NxkblkSNkiFmraz0dqTEFlJklWvllhGzeDkxHSmq3HUUl6tyfcn4pZtPB69dtAxdOge13pBGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846637; c=relaxed/simple;
	bh=lGfdiDP3j+o5jJYO92WZKbIrlIFe01EFliNN8nDBtJo=;
	h=Date:To:From:Subject:Message-Id; b=uf6UFXdhexT6lfjxUSO/4yCQWy1T2U4FB2zfpFQnWTiELpAgZUd+aMBpGhnFv7rtYPIVvd40aSAk/okqrkMNCY+nynasrFSL7bCH5qHJiP6Cgf6b8ECKIV17f7xr1tbORtSSrlIWGqn5hCvXF7crTuyUzj78rJLUQ6KUs3FP3q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oV8wC4l1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oV8wC4l1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099FDC4CEE4;
	Wed, 21 May 2025 16:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846637;
	bh=lGfdiDP3j+o5jJYO92WZKbIrlIFe01EFliNN8nDBtJo=;
	h=Date:To:From:Subject:From;
	b=oV8wC4l1/JhCA44vpHNYC+zYtfdGO6Zv2HIeriK1+24URbjXqZKT6i35CP+l1OTb4
	 v6cCkl39/cznwJBKZAYhbyzq/mhRsuSqJvyowZPFnkvmJ/JfWLN2/xf2mzSM2CYa0F
	 88MjyTu13ymj06UQ4IqgEHaiqQiSDSnBzdbrMV/o=
Date: Wed, 21 May 2025 09:57:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-i915-track_pfn-pfnmap-tracking.patch removed from -mm tree
Message-Id: <20250521165717.099FDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/i915: track_pfn() -> "pfnmap tracking"
has been removed from the -mm tree.  Its filename was
     drm-i915-track_pfn-pfnmap-tracking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drm/i915: track_pfn() -> "pfnmap tracking"
Date: Mon, 12 May 2025 14:34:23 +0200

track_pfn() does not exist, let's simply refer to it as "pfnmap tracking".

Link: https://lkml.kernel.org/r/20250512123424.637989-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org>	[x86 bits]
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_mm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_mm.c~drm-i915-track_pfn-pfnmap-tracking
+++ a/drivers/gpu/drm/i915/i915_mm.c
@@ -100,7 +100,7 @@ int remap_io_mapping(struct vm_area_stru
 
 	GEM_BUG_ON((vma->vm_flags & EXPECTED_FLAGS) != EXPECTED_FLAGS);
 
-	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
+	/* We rely on prevalidation of the io-mapping to skip pfnmap tracking. */
 	r.mm = vma->vm_mm;
 	r.pfn = pfn;
 	r.prot = __pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
@@ -140,7 +140,7 @@ int remap_io_sg(struct vm_area_struct *v
 	};
 	int err;
 
-	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
+	/* We rely on prevalidation of the io-mapping to skip pfnmap tracking. */
 	GEM_BUG_ON((vma->vm_flags & EXPECTED_FLAGS) != EXPECTED_FLAGS);
 
 	while (offset >= r.sgt.max >> PAGE_SHIFT) {
_

Patches currently in -mm which might be from david@redhat.com are


