Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583E138C40B
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385832; cv=none; b=hAeWYIoEO37T+jK4oHruNMi/sAAUB8l7VNn/91iYyrHaTKNB+9eqfjJWdW7MEh2shsCLZhfGGQ9s7Npvez6GEnKGuNzweBRiss+pslzVS9VOX+4fK894/rB38edHo/TOCsXTkM2yk9CPCoYLNNB8YpzE6xJiB6v5Vte1qBJuhCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385832; c=relaxed/simple;
	bh=mnM4laUFaCLd4vWdEWJFL2FIt2L44otnWexikrhV7CY=;
	h=Date:To:From:Subject:Message-Id; b=oGZMUX4x2ezAoUYYcwMZc6RfwZyWNP+r3UC7L9OamS1RD/bCr6ytbzpENpk7epkNEj95e0Wa7v8y73Je4Vf8Mb+8s3vfLth3o14gbSOtBfTIxUxJk8oBSPRF84pHclYvtmIAPVuFR0ALsaWTHKfkX6MBjYCaq0gP64ejhGr4Q9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yfE9eNeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yfE9eNeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD505C2BCAF;
	Tue, 28 Apr 2026 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777385831;
	bh=mnM4laUFaCLd4vWdEWJFL2FIt2L44otnWexikrhV7CY=;
	h=Date:To:From:Subject:From;
	b=yfE9eNeHATBkCmG3E3Z4rgHroeXHtPUy7j7jUZaY1Ek78NBy+HQXmwfy0gKvs5Q8D
	 GwzBqHikJ7TlkW8ZiIhrsgCfyvo406cGwHBnXi71dzaT45ktg9OJK0fR6U+emOXbeE
	 N+4CyFkqwOWrPV4pCtpX3D9uR1H4IoBJHwYRllBA=
Date: Tue, 28 Apr 2026 07:17:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-document-page_owner-filter-features.patch added to mm-new branch
Message-Id: <20260428141711.CD505C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: document page_owner filter features
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-document-page_owner-filter-features.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-document-page_owner-filter-features.patch

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
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: document page_owner filter features
Date: Tue, 28 Apr 2026 15:11:12 +0800

Add documentation for the page_owner filter functionality, including:
- Print mode filter (full stack vs stack handle)
- NUMA node filter (single node, multiple nodes, ranges)
- Usage examples for both filters

Link: https://lore.kernel.org/20260428071112.1420380-5-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_owner.rst |   55 +++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

--- a/Documentation/mm/page_owner.rst~mm-page_owner-document-page_owner-filter-features
+++ a/Documentation/mm/page_owner.rst
@@ -74,7 +74,17 @@ Usage
 
 3) Do the job that you want to debug.
 
-4) Analyze information from page owner::
+4) (Optional) Use filters to focus on specific memory allocations::
+
+    cd /sys/kernel/debug/page_owner_filter
+
+    # Print only stack handles instead of full traces
+    echo 1 > print_mode
+
+    # Filter by NUMA nodes
+    echo "0,2-3" > nid
+
+5) Analyze information from page owner::
 
 	cat /sys/kernel/debug/page_owner_stacks/show_stacks > stacks.txt
 	cat stacks.txt
@@ -238,6 +248,49 @@ Usage
 				./page_owner_sort <input> <output> --tgid=1,2,3
 				./page_owner_sort <input> <output> --name name1,name2
 
+Page Owner Filters
+==================
+
+The page_owner feature provides filtering capabilities to focus on specific
+memory allocations (e.g., by NUMA node). Filters are controlled through debugfs
+files in ``/sys/kernel/debug/page_owner_filter/``.
+
+Print Mode Filter
+-----------------
+
+The ``print_mode`` file controls the level of detail in stack trace output.
+
+Available modes:
+
+- ``0`` (default): Print full stack traces
+- ``1``: Print only stack handles
+
+The ``print_mode=1`` output format::
+
+    Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
+    pid 1, tgid 1 (systemd), ts 349667370 ns
+    PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
+    Flags 0x33fffe0000004124(...)
+    handle: 17432583
+
+To retrieve the full stack trace for a handle, use::
+
+    cat /sys/kernel/debug/page_owner_stacks/show_stacks_handles
+
+NUMA Node Filter
+----------------
+
+The ``nid`` file filters pages by NUMA node. This is useful for NUMA-aware
+environments to analyze node-specific memory allocation.
+
+Supported input formats:
+
+- Single node: ``echo "2" > nid``
+- Multiple nodes: ``echo "0,2,3" > nid``
+- Node range: ``echo "0-3" > nid``
+- Mixed format: ``echo "0,2-4,7" > nid``
+- Disable filter: ``echo "-1" > nid``
+
 STANDARD FORMAT SPECIFIERS
 ==========================
 ::
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-add-filter-infrastructure.patch
mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support.patch
mm-page_owner-document-page_owner-filter-features.patch
mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

