Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7F2627E9
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 23:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747092880; cv=none; b=QfeygkKIWXTmgKWG9HnHlPPzgDVc4+rYg/NQPFIVWzcGbRqJ+XgYoDZsEhdzxrvBko2kWZNv8urisOlDeQg2njqy05jVVW4ibwdJOlQgeK9IXFBw55A/18YzFVSLAgeQzwXmKh0IKZu5Jb3j5BwYEZwlpv7WmLlxjeMVb6V1reQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747092880; c=relaxed/simple;
	bh=db3kgX9FY7jhKp3bZ8vP3YYNoRfNFaLRa1ib748CSvg=;
	h=Date:To:From:Subject:Message-Id; b=QT7k2G/Aat7eq7t+ut5B0qzut50EicO/WWgNbeqVlxEOBu82v5TvB6OBrBNcTqma+9N9Ta33nfGKcpn8QIeRiYseIrkoEhmmZHfZgN2EtWwa2TR4w0RVcvbcUTtOYht3XGtZERfrnNivqYFl40aKJBM49kZ9TZGcyvEfqLK4ZkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V7hbunM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V7hbunM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A9DC4CEE7;
	Mon, 12 May 2025 23:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747092880;
	bh=db3kgX9FY7jhKp3bZ8vP3YYNoRfNFaLRa1ib748CSvg=;
	h=Date:To:From:Subject:From;
	b=V7hbunM9xBxhK/I3yWSz0fHbxKJocfd8IL5bg+ZCyOu2sCJYud6GX7EkaBay/aZ7O
	 9/85BmNVvFbT1CcYhnCjlN9sovN2BfTBjVKoLsV+h/VT7mF20vRH2OK1edrX8MDrEg
	 aMc7cIB0UnClfgqBzAyKjAGDxEwb5nTUBRl3nZf8=
Date: Mon, 12 May 2025 16:34:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-i915-track_pfn-pfnmap-tracking.patch added to mm-new branch
Message-Id: <20250512233440.40A9DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/i915: track_pfn() -> "pfnmap tracking"
has been added to the -mm mm-new branch.  Its filename is
     drm-i915-track_pfn-pfnmap-tracking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-i915-track_pfn-pfnmap-tracking.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: drm/i915: track_pfn() -> "pfnmap tracking"
Date: Mon, 12 May 2025 14:34:23 +0200

track_pfn() does not exist, let's simply refer to it as "pfnmap tracking".

Link: https://lkml.kernel.org/r/20250512123424.637989-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org> # x86 bits
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch
x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch
mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode.patch
mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap.patch
mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack.patch
x86-mm-pat-remove-old-pfnmap-tracking-interface.patch
mm-remove-vm_pat.patch
x86-mm-pat-remove-strict_prot-parameter-from-reserve_pfn_range.patch
x86-mm-pat-remove-memtype__match.patch
x86-mm-pat-inline-memtype_match-into-memtype_erase.patch
drm-i915-track_pfn-pfnmap-tracking.patch
mm-io-mapping-track_pfn-pfnmap-tracking.patch

