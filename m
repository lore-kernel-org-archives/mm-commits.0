Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCB02D838C
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280703; cv=none; b=bx97ZTkmuoNPS+5wmkydsHTJlF3YQoim+SAwkGY/jrpazjXFgjqNET9idSiQTSsq8jBRh1WG05GLLN7CXwg64Cd9dpULu2U3a+n+OoClcFnN+YnNNa5JwfkrWl+ANCgIXA8tNyelUBrkEmrerQjKJQ1ZhxzmtMB5sfcFULdwCUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280703; c=relaxed/simple;
	bh=cjJCqH4s6Pw4WKZybP/juhKKjoGF7dCsv7KPY/c9r4w=;
	h=Date:To:From:Subject:Message-Id; b=BTehoFSdXUbfqfJY/bHfwKwr1HfmrpJnZcRnmbT06WLUL1OWZXIHSErSxmID5DpKs5bxvTYPAyDLkvy5QYIU2XRXxfD+Oo+tCZE3cGTmxvAS+HMrnDE3Uj65FlmOeZ250WHJj+4+Bg+6Ryj+oi0+S/oKCBzaMZiiFtC4Fzj/0lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TAaoujZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TAaoujZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB57C116C6;
	Tue, 13 Jan 2026 05:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280703;
	bh=cjJCqH4s6Pw4WKZybP/juhKKjoGF7dCsv7KPY/c9r4w=;
	h=Date:To:From:Subject:From;
	b=TAaoujZvvq89wK63teWUffd6idsgNzFvt174Of1YoK7Qw0mDGNaFbvv7zqTFND6On
	 0+wJAyeKoQvphCW/XS7/qFaaAtxe9k2z9G0ZVKnCCa2ll8VymUtVZBiY+g7jfzRnxm
	 FKtCKhIRN0XcpSOoKSwJb6vafL7FTMhrVdCwUilE=
Date: Mon, 12 Jan 2026 21:05:02 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch removed from -mm tree
Message-Id: <20260113050502.EDB57C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch

This patch was dropped because it was folded into mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix
Date: Wed Dec  3 02:13:35 PM PST 2025

add comment, per Michal

Link: https://lkml.kernel.org/r/aS_y9AuJQFydLEXo@tiehlicka
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix
+++ a/mm/page_alloc.c
@@ -6667,6 +6667,11 @@ static int percpu_pagelist_high_fraction
 	int old_percpu_pagelist_high_fraction;
 	int ret;
 
+	/*
+	 * Avoid using pcp_batch_high_lock for reads as the value is read
+	 * atomically and a race with offlining is harmless.
+	 */
+
 	if (!write)
 		return proc_dointvec_minmax(table, write, buffer, length, ppos);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

