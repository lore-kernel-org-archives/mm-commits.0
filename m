Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A3A371CE0
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028741; cv=none; b=gVRCa3u3IzGiyksucRbrRpy8KiOzzfS9LiGJN7hYNtRD91/b7WOPrMpzOz83VmB7iYcmfkhiqX1G3fcG3ZW59E3o7WemM3td9328Xk9FcPt4Jbz3WA5RZjQfeIPLobBqxFSON3CD05/XUNFiuH7DblCRU1zn2E+RhhAUKxriiXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028741; c=relaxed/simple;
	bh=0u3kOvLLcxaUVrmC5Iy20LRj+auQ1vZh0tgMoJDR0kg=;
	h=Date:To:From:Subject:Message-Id; b=MC4v75r0OxTg480L8sJWHeTJnH6vGDCtKKnFEQIr0pj5jcfudh4mqtVzxNIJ5IkrkMHCTSwqmz9UeucXdQykjYJWB3ouNJbmc/t3ssRZ/VBho7YLARrTbrQXfkAVyvK5O7LeGCLZTrYi9RP4M2MhtumlsqbT+Ii45bEJF0Rs7vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tPaV28n/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tPaV28n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8381F00898;
	Fri, 29 May 2026 04:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028740;
	bh=4zYBs6i8XrSe3Y0UTUg3zLKbSk4wyuX5zlL2ljIhRis=;
	h=Date:To:From:Subject;
	b=tPaV28n/WcpHVaBW1YT+wmIuwm6DN93IjWA0WmjHJ1YQw+FSd8uIxk3BghWa82gFY
	 eM/jyDsWi5KFnW1BTpLYwi7IdyQrxSO9Do56VgrMRkxLPGU1jiuxKfXpFEvNtrSI09
	 pwfJxlfZoXv7xsGMpqPv15H52N6nHQCUb2234x6E=
Date: Thu, 28 May 2026 21:25:39 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingo@kernel.org,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] clang-format-fix-formatting-of-guard-and-scoped_guard-statements.patch removed from -mm tree
Message-Id: <20260529042540.2B8381F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: clang-format: fix formatting of guard() and scoped_guard() statements
has been removed from the -mm tree.  Its filename was
     clang-format-fix-formatting-of-guard-and-scoped_guard-statements.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: clang-format: fix formatting of guard() and scoped_guard() statements
Date: Mon, 13 Apr 2026 11:23:48 -0700

Without this patch clang-format formats guard() and scoped_guard()
statements as follows:

	guard(...)(...)
	{
		...
	}

With this patch clang-format formats guard() and scoped_guard()
statements as follows:

	guard(...)(...) {
		...
	}

Link: https://lore.kernel.org/20260413182348.1865138-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .clang-format |    2 ++
 1 file changed, 2 insertions(+)

--- a/.clang-format~clang-format-fix-formatting-of-guard-and-scoped_guard-statements
+++ a/.clang-format
@@ -481,6 +481,7 @@ ForEachMacros:
   - 'genradix_for_each'
   - 'genradix_for_each_from'
   - 'genradix_for_each_reverse'
+  - 'guard'
   - 'hash_for_each'
   - 'hash_for_each_possible'
   - 'hash_for_each_possible_rcu'
@@ -674,6 +675,7 @@ ForEachMacros:
   - 'rq_list_for_each'
   - 'rq_list_for_each_safe'
   - 'sample_read_group__for_each'
+  - 'scoped_guard'
   - 'scsi_for_each_prot_sg'
   - 'scsi_for_each_sg'
   - 'sctp_for_each_hentry'
_

Patches currently in -mm which might be from bvanassche@acm.org are

lib-split-codetag_lock_module_list.patch

