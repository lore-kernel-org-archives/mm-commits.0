Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92AE2163B6
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188355; cv=none; b=DbqbGIZJaM60gBT9QbdvKBMy2OdiDlFkougmcCtLHSwp3TXkV8uhamYprn9VVojYgkjfr/PC2qB/1Ld7IeCnJ11Bp/sWGm1/Y/DYwk7lvlu1pK9Z8oLCvNDVu1fD/cuRfnOYkDJEg+28ejqbWZv+sLyjmFTEK5LjQhK5IzWLT7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188355; c=relaxed/simple;
	bh=NPnmkWNHEdaN0gI9XymuJMFbFE01Lw7FPtLAnyGIC+g=;
	h=Date:To:From:Subject:Message-Id; b=khWfD7uk8Bqi5dtIRf31GuYYtkTLhounCNn54zK98fL26+xfKMtSnG7jm7hwvioJqzOnHyodLQedQeCIEG6qp3QS4O/zMRYTMR8xqzlsgFuW/EKI99kyZr7ZucZ1Tnhsq+kvYJQSjJedYVA6z9UhNJUP1PghxOaJ5rrBmqPshM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A9AlGn5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A9AlGn5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50615C4CEEC;
	Mon, 17 Mar 2025 05:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188355;
	bh=NPnmkWNHEdaN0gI9XymuJMFbFE01Lw7FPtLAnyGIC+g=;
	h=Date:To:From:Subject:From;
	b=A9AlGn5Mn+geT4FSuGyHk7MzDI5TXHnHNFZEGsnR0CrRgDVRHrCzVpEm7GvZVuD+t
	 FJj0hBPncVw5wOEQJbSMHVqXufTJJajE80B5G+e6+1ZH2jFIXRRTTGDpfI0DLPncKy
	 7eHn6xWVMT+i9Z0AQ4/+DLvXCv7dLfdlqlL/nBy0=
Date: Sun, 16 Mar 2025 22:12:34 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch removed from -mm tree
Message-Id: <20250317051235.50615C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: categorize DAMOS filter types based on handling layer
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: categorize DAMOS filter types based on handling layer
Date: Tue, 18 Feb 2025 14:37:08 -0800

On what DAMON layer a DAMOS filter is handled is important to expect in
what order filters will be evaluated.  Re-organize the DAMOS filter types
list on the design doc to categorize types based on the handling layer, to
let users more easily understand the handling order.

Link: https://lkml.kernel.org/r/20250218223708.53437-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   34 ++++++++++++----------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer
+++ a/Documentation/mm/damon/design.rst
@@ -602,25 +602,21 @@ filters-checking overhead.
 
 Below ``type`` of filters are currently supported.
 
-- anon
-    - Applied to pages that containing data that not stored in files.
-    - Handled by operations set layer.  Supported by only ``paddr`` set.
-- memcg
-    - Applied to pages that belonging to a given cgroup.
-    - Handled by operations set layer.  Supported by only ``paddr`` set.
-- young
-    - Applied to pages that are accessed after the last access check from the
-      scheme.
-    - Handled by operations set layer.  Supported by only ``paddr`` set.
-- hugepage_size
-    - Applied to pages that managed in a given size range.
-    - Handled by operations set layer.  Supported by only ``paddr`` set.
-- addr
-    - Applied to pages that belonging to a given address range.
-    - Handled by the core logic.
-- target
-    - Applied to pages that belonging to a given DAMON monitoring target.
-    - Handled by the core logic.
+- Core layer handled
+    - addr
+        - Applied to pages that belonging to a given address range.
+    - target
+        - Applied to pages that belonging to a given DAMON monitoring target.
+- Operations layer handled, supported by only ``paddr`` operations set.
+    - anon
+        - Applied to pages that containing data that not stored in files.
+    - memcg
+        - Applied to pages that belonging to a given cgroup.
+    - young
+        - Applied to pages that are accessed after the last access check from the
+          scheme.
+    - hugepage_size
+        - Applied to pages that managed in a given size range.
 
 To know how user-space can set the filters via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

