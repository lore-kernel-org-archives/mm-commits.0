Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42630253F2D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 23:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747092878; cv=none; b=rg4JT0TeODGKLOWDaO/0rgG+Jb1QD3a/qENFP5yWPgnWEVv5KpcHb8NaVHLLmIgWSm2sYqD8ZYdIDKmoggcQjyoRnBKvHFWWEdO/XgvVGeRA2yAWp/fuiWfKWtcRery+2FL/bYddWaT1MzWuo7zkr+S8+/rNdYCSI36+HL7erww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747092878; c=relaxed/simple;
	bh=21fKG6OydwtMc6tJyXwFP1rly0EAsmMwgB20nWQie8o=;
	h=Date:To:From:Subject:Message-Id; b=dmlTv+BbSdqEyZQSjFe5nAtO4Oa3/vxi8XIV5bvHlVmkvfiCNoacSSFywWcx3RgCMkdqS802xblU3Q/A0++IIDnsv8G9l7oFGYcP0ilfrhHuDSeUdcZYl2JN9+ScpxPlOzBYfrn9PTAvQetJ3T/s2ZcHKSzq/vkNPt8xB43Iuws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NwczLEuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NwczLEuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16236C4CEE7;
	Mon, 12 May 2025 23:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747092878;
	bh=21fKG6OydwtMc6tJyXwFP1rly0EAsmMwgB20nWQie8o=;
	h=Date:To:From:Subject:From;
	b=NwczLEuHctO23jNOJi0Ax8r3Nj6C3aR/xsJalDlObGXvZpu7OKjhxsSw45tQm3ElZ
	 RHriLqxwI0eqNlvhxsbvLJ0F4sC0P1YBmldsyF1hH2jVy81kjBtOTQj8QaINQLhU7x
	 HVMDqg/cZaPOfU7jWISMFgbwEjyJrMThL9KGg1Ac=
Date: Mon, 12 May 2025 16:34:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-inline-memtype_match-into-memtype_erase.patch added to mm-new branch
Message-Id: <20250512233438.16236C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm/pat: inline memtype_match() into memtype_erase()
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-pat-inline-memtype_match-into-memtype_erase.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-inline-memtype_match-into-memtype_erase.patch

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
Subject: x86/mm/pat: inline memtype_match() into memtype_erase()
Date: Mon, 12 May 2025 14:34:22 +0200

Let's just have it in a single function.  The resulting function is
certainly small enough and readable.

Link: https://lkml.kernel.org/r/20250512123424.637989-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
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

 arch/x86/mm/pat/memtype_interval.c |   31 +++++++--------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

--- a/arch/x86/mm/pat/memtype_interval.c~x86-mm-pat-inline-memtype_match-into-memtype_erase
+++ a/arch/x86/mm/pat/memtype_interval.c
@@ -49,21 +49,6 @@ INTERVAL_TREE_DEFINE(struct memtype, rb,
 
 static struct rb_root_cached memtype_rbroot = RB_ROOT_CACHED;
 
-static struct memtype *memtype_match(u64 start, u64 end)
-{
-	struct memtype *entry_match;
-
-	entry_match = interval_iter_first(&memtype_rbroot, start, end-1);
-
-	while (entry_match != NULL && entry_match->start < end) {
-		if (entry_match->start == start && entry_match->end == end)
-			return entry_match;
-		entry_match = interval_iter_next(entry_match, start, end-1);
-	}
-
-	return NULL; /* Returns NULL if there is no match */
-}
-
 static int memtype_check_conflict(u64 start, u64 end,
 				  enum page_cache_mode reqtype,
 				  enum page_cache_mode *newtype)
@@ -119,14 +104,16 @@ int memtype_check_insert(struct memtype
 
 struct memtype *memtype_erase(u64 start, u64 end)
 {
-	struct memtype *entry_old;
-
-	entry_old = memtype_match(start, end);
-	if (!entry_old)
-		return ERR_PTR(-EINVAL);
+	struct memtype *entry = interval_iter_first(&memtype_rbroot, start, end - 1);
 
-	interval_remove(entry_old, &memtype_rbroot);
-	return entry_old;
+	while (entry && entry->start < end) {
+		if (entry->start == start && entry->end == end) {
+			interval_remove(entry, &memtype_rbroot);
+			return entry;
+		}
+		entry = interval_iter_next(entry, start, end - 1);
+	}
+	return ERR_PTR(-EINVAL);
 }
 
 struct memtype *memtype_lookup(u64 addr)
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

