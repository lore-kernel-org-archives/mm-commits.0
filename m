Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794862096;
	b=AW4mQ4syBIjnM8P2VbYn/uUDGNdjPjAgEiSrhZHCbCtuVNTZw2CWWIdMRQaZfqXVHUE3
	 0qMMlYh9Us/o7r3ZcDE8ohnyJYcyXBb9fZmV+01TmSlTjEaGv+7iRXoR5uPmR1NhIrAd9
	 0RPQGCq16LPxY6vS5pV6VTuK97YBpMcWY/a6xFj7pAvxJ+D3cATAj82hHkCb8tVev2Qrt
	 0nHINeZ1VX0Cw129bkmIzYGM5Nn9G3KBk5WX4OxUkZpAz3AO1uRNq9LHmvtSD6eiKsMFV
	 nrYh3wfNYT48jPIpAQqwHg8dH7nSUhB+zhwrSmMZkPJzrSGotfHooAJd4wgftwFSqIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794862096;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hhnt70TAxROvszQtnt9SH9gEGSiJtcy798xjACUGOwA=;
	b=M8f80Pb3IWJNfbQqC/WEG1BDxSmCmJNK+NdmTAjnsjQIIsez2+1BZ2QcwPwI38Ifa6Br
	 jEDLT4yGGLbH0nh7UiwB6oL+DIfAPAnBNm6kDSOrF/mB8X9aCOlQMHwnBLlHd4R4gfud9
	 HMz8UW9qePYSs4hey4xLv9v5hg10unq51YmP2+yho8abUHx8Vw4DZSuVVVi6s4GlxM2V+
	 /B5T6IuYvY5hHQZlXeTMcSEthcU+13EmdQTkpxZNZ8XE86p23au+YrbJskr8Mg2OUngDp
	 ynwVKCy8gySuaLDNG6yUAIolMI9Vw/1eaOmx6QrpFPlF4xl8fGIlRgSopvtkxBT5K/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ps3xqUk+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68662606A32A
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ps3xqUk+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FF51F000C4;
	Mon, 16 Nov 2026 20:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794862096;
	bh=hhnt70TAxROvszQtnt9SH9gEGSiJtcy798xjACUGOwA=;
	h=Date:To:From:Subject;
	b=ps3xqUk+Jg3IbZCw29JbsirmY/EQsibGY0XUGy3rdwsjXu9K0998Ns0achUiCKnby
	 YaMNDHnna59/Ed3GMfu0Ws8Lgoi2III+Pd4EmWe5APeE/hXxQW8VPQ5zo+RSF5Ea0/
	 ocQu9dAbkjW2Ey8aUmRty8QtyQrap2dNI+Nh9RTw=
Date: Mon, 16 Nov 2026 12:48:15 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,jm5905938@gmail.com,corbet@lwn.net,lienze@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-replace-same-to-with-same-as.patch added to mm-new branch
Message-Id: <20261116204816.22FF51F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/design: replace "same to" with "same as"
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-replace-same-to-with-same-as.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-replace-same-to-with-same-as.patch

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
From: Enze Li <lienze@kylinos.cn>
Subject: Docs/mm/damon/design: replace "same to" with "same as"
Date: Mon, 16 Nov 2026 07:10:52 -0800

"same to" is not idiomatic; it should be "the same as" or "same as".
This doc has six such usages.  Fix all of them at once for consistency.

Link: https://lore.kernel.org/20261116151057.81692-3-sj@kernel.org
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>

 Documentation/mm/damon/design.rst |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-replace-same-to-with-same-as
+++ a/Documentation/mm/damon/design.rst
@@ -292,17 +292,17 @@ DAMON :ref:`context <damon_design_execut
 registration is made by specifying a probe per attribute.  Each of the probes
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
-same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently below filter types are supported.
+the same as :ref:`DAMOS filters <damon_design_damos_filters>` except the
+supported filter types.  Currently below filter types are supported.
 
-- ``anon``: Same to that for DAMOS filters.
-- ``memcg``: Same to that for DAMOS filters.
+- ``anon``: Same as that for DAMOS filters.
+- ``memcg``: Same as that for DAMOS filters.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
-- ``active``: Same to that for DAMOS filters.
+- ``active``: Same as that for DAMOS filters.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -706,7 +706,7 @@ There are two such tuning algorithms tha
 The goal can be specified with six parameters, namely ``target_metric``,
 ``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
 auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
-``target_metric`` be same to ``target_value``.
+``target_metric`` be the same as ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   have interest in for the value.  User space main workload's latency or
@@ -736,7 +736,7 @@ auto-tuning mechanism tries to make ``cu
 
 ``complement`` is a boolean parameter that determines whether to use
 complemented value of the target metric.  For example, if ``complement`` is set
-and target metric is ``active_mem_bp``, it is effectively same to
+and target metric is ``active_mem_bp``, it is effectively the same as
 ``inactive_mem_bp``.  ``complement`` is no-op when the target metric type is
 ``user_input``.  For the metric type, the user should be able to emit
 complemented metric values on their own.
_

Patches currently in -mm which might be from lienze@kylinos.cn are

docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst.patch
mm-hugetlb-drop-unused-mm-parameter-from-unmap_ref_private.patch
mm-hugetlb_cma-remove-two-unused-include-files.patch
mm-damon-core-use-list_nextprev_entry-in-damon_nextprev_region.patch
docs-mm-damon-design-replace-same-to-with-same-as.patch

