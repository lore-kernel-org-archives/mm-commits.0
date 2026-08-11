Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F96239E9B;
	Tue, 11 Aug 2026 03:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786418582; cv=none; b=dq61xdUr2jsw274uC0W+edKwglV0pUakw3Qqun7qjhWuU2eZncvw23bQQSzCuhLr/QNVpyke6UCMHHagXhFi3Fg0DD7ZwKqiNrDuDwTZyyNbT8qR+3qQ2k1IVindh/7aKHTF5zAA85KL552FOa0cZtTHxQRBy6HnDAVgrNd/PTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786418582; c=relaxed/simple;
	bh=ydNMzMe0rkRm74rJSalYUHdFn4AElTELTytdpO1THs4=;
	h=Date:To:From:Subject:Message-Id; b=A4zhIeOvpXGE1sZwfk5FN8YyjPaNV95cdylCgGmBPEIE42O/WYBN2l/nZEq0kZklT1V4iU0AfUApWoiiSGB0cMBYppXJtgZMdfs54Ylvc9PC+mHQO4gXGC9A9s0Bc6DWPcXvCESvfyXkhvl+BfGk4q2ohfbLCeOX3FQb6zkOdlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ufaab2B+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ufaab2B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D4B1F000E9;
	Tue, 11 Aug 2026 03:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786418580;
	bh=HuftU/q0Vx+A3VZbaApGCs0UmgQ3xilNRE+Y0UGOs6A=;
	h=Date:To:From:Subject;
	b=ufaab2B+x+YcZnjU2QJVgQo9Ymh0MqeZ9T6NNpV8kbppOfgoa2FGMIr18sbuxgTfc
	 uOowaJFaoB1vqBl4tHQ0G58UFqHpp+N6Gkk9eXuQqygetW0FNI5GEajO2DtvLq+UaE
	 FVl1FeLFlNJ0k0gQ13IYuc7YRjnWh/Hga6LQLX7o=
Date: Mon, 10 Aug 2026 20:23:00 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch removed from -mm tree
Message-Id: <20260811032300.98D4B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix undetected compressed tag overflow when profiling is disabled
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: alloc_tag: fix undetected compressed tag overflow when profiling is disabled
Date: Wed, 5 Aug 2026 17:06:33 +0800

In reserve_module_tags(), the tag overflow check is gated on
mem_alloc_profiling_enabled():

    if (mem_alloc_profiling_enabled() && !tags_addressable())

If profiling is toggled off at runtime and a module is loaded whose tags
exceed the compressed-mode limit, shutdown_mem_profiling() is skipped. 
vm_module_tags_populate() still maps memory for the tags and the module
loads successfully, but the total tag count now exceeds what
NR_UNUSED_PAGEFLAG_BITS can address.

Once profiling is re-enabled, ref_to_idx() computes each tag's index as
its position in the alloc_tag array.  update_page_tag_ref() masks it to
alloc_tag_ref_mask before storing in page->flags.  Indices beyond the mask
are truncated and idx_to_ref() resolves them to wrong tags.

This silently corrupts /proc/allocinfo: allocated pages get attributed to
the wrong call sites, so the statistics it reports are wrong.

mem_alloc_profiling_enabled() and mem_profiling_compressed are
independent.  Once compressed mode is established at boot, it stays active
regardless of runtime toggles of mem_profiling.

Remove the mem_alloc_profiling_enabled() guard.  Also return an error
after shutdown_mem_profiling() to skip vm_module_tags_populate(), as the
mapped pages would never be reused - shutdown_mem_profiling() sets
mem_profiling_support to false, so no future module load enters the
codetag path.

Link: https://lore.kernel.org/20260805090633.141001-1-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/alloc_tag.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/alloc_tag.c~alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled
+++ a/mm/alloc_tag.c
@@ -904,10 +904,11 @@ unlock:
 		int grow_res;
 
 		module_tags.size = offset + size;
-		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
+		if (!tags_addressable()) {
 			shutdown_mem_profiling(true);
-			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
-				mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			pr_warn_once("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
+				     mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			return ERR_PTR(-ENOMEM);
 		}
 
 		grow_res = vm_module_tags_populate();
_

Patches currently in -mm which might be from hao.ge@linux.dev are


