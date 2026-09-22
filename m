Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983572EEE85;
	Tue, 22 Sep 2026 03:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790048799; cv=none; b=UePmLvHRhGzo/ReDZ+ih114+d4Jc2aRQS4AfghREsxYARbN5qqpTOnOJLIWtMCoIVC4Ud6PCXnsElkzVLkFnWnJ6g+Fz1PdWQEz/xAWVMBjVX2r6n/ITQk8eKiduTOmkjSNhFsd0g5MnEB6h1kmTv6/ivNkI8IIqZfBpBm2pATE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790048799; c=relaxed/simple;
	bh=S3qlVY22Zsepelo7E3c9GhNxbL3Gy1kcvXxJFMnuRwc=;
	h=Date:To:From:Subject:Message-Id; b=hmFrzKZNjjUherK0ZajG5IE2TOjELCZBodj5QeapoR/eBfI+165v8ArPVilYFXfjnzgx6w7TQx5lswk+DZi/34kfHIb3GyfCsS08rg6fRqlN2yxClz2ZfaSPDORJ5eL/3p3knH7dvxfmnXQP4zX0Ivrdv1toJuA/4tbtgHpBXfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U8yyY6W2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U8yyY6W2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2A21F000FF;
	Tue, 22 Sep 2026 03:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790048797;
	bh=rx9YqJKGy2bTriZW7u8ATGKkcfkoaq2dm1q6UIWAH2M=;
	h=Date:To:From:Subject;
	b=U8yyY6W2/Wl7v5f73POSOnJ+SY/1pym+uUfVwbkoYkqVWO07a7v1EWjNWzMmPjHHA
	 lNCl4s8fH9JglE/m8XPMGprbV3C8lSLA9piprDw5a3ufexjg/oIiOYkuTutBzj7eTQ
	 7kKXcJ5l8sulTriUvGfLae6RXTYk1Q4/C/pYXWDA=
Date: Mon, 21 Sep 2026 20:46:36 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch removed from -mm tree
Message-Id: <20260922034637.0A2A21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: skip percpu counter allocation when profiling is disabled
has been removed from the -mm tree.  Its filename was
     alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: alloc_tag: skip percpu counter allocation when profiling is disabled
Date: Mon, 17 Aug 2026 14:27:25 +0800

Patch series "alloc_tag: fix a leak and a deadlock around
shutdown_mem_profiling()", v2.

Two fixes for issues reported by sashiko:

  1. percpu counter leak on modules loaded after profiling is disabled.
  2. AB-BA deadlock between module load and /proc/allocinfo readers.


This patch (of 2):

After shutdown_mem_profiling() clears mem_profiling_support,
needs_section_mem() returns false, so later modules have their codetag
section placed as regular data and never enter the alloc_tag maple tree. 
codetag_load_module() still called load_module(), which allocated a percpu
counter for every tag; release_module_tags() could not find these modules
on unload, so the counters leaked.

Return -EOPNOTSUPP from load_module() when profiling is off:
codetag_module_init() drops the module's cmod, no counters are allocated
and the module loads without its tags.  codetag_unload_module() now always
calls free_section_mem(), since a module whose module_load() returned
-EOPNOTSUPP is not in the idr but may still hold a reserved section.

Link: https://lore.kernel.org/20260817062726.106511-1-hao.ge@linux.dev
Link: https://lore.kernel.org/20260817062726.106511-2-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
---

 lib/codetag.c  |   10 ++++++++--
 mm/alloc_tag.c |    4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/lib/codetag.c~alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled
+++ a/lib/codetag.c
@@ -240,7 +240,9 @@ static int codetag_module_init(struct co
 
 	if (err < 0) {
 		kfree(cmod);
-		return err;
+		/* -EOPNOTSUPP means we can load the module without its tag. */
+		if (err != -EOPNOTSUPP)
+			return err;
 	}
 
 	return 0;
@@ -388,7 +390,11 @@ void codetag_unload_module(struct module
 			++cttype->content_id;
 		}
 		up_write(&cttype->mod_lock);
-		if (found && cttype->desc.free_section_mem)
+		/*
+		 * A module whose module_load() returned -EOPNOTSUPP is not
+		 * in the idr but may still hold reserved section memory.
+		 */
+		if (cttype->desc.free_section_mem)
 			cttype->desc.free_section_mem(mod, true);
 	}
 	mutex_unlock(&codetag_lock);
--- a/mm/alloc_tag.c~alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled
+++ a/mm/alloc_tag.c
@@ -975,6 +975,10 @@ static int load_module(struct module *mo
 	struct alloc_tag *stop_tag;
 	struct alloc_tag *tag;
 
+	/* Profiling disabled: load the module without its tags. */
+	if (!mem_profiling_support)
+		return -EOPNOTSUPP;
+
 	/* percpu counters for core allocations are already statically allocated */
 	if (!mod)
 		return 0;
_

Patches currently in -mm which might be from hao.ge@linux.dev are

module-fix-lost-error-code-from-codetag_load_module.patch
alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch
mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch

