Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7753E121A
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 23:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784676143; cv=none; b=qy8BrqtbvsLmb+IMi9bvs+4AbvIGGlRg/IYp9pA7pbb9eW25nq49P+OZGgpdWH4COhgeljm1HYmkLQ4/nB8aQZgwhECZS0sjgBP+W1UnKluVTZxyG6FzDAEuUnJutfbkeWT0R1frsEKSTVaYYXN5sJfrvPoOywunCtcqKiH1wn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784676143; c=relaxed/simple;
	bh=QkpREHT388Z/m8ZTc5aRS/LxWdoUR8c1XrxI2aN8B+w=;
	h=Date:To:From:Subject:Message-Id; b=gw3pmBBFrW6sIFDMIxpwJJrW63VQ+Etv5KqxM2Q2BiWbMi9N4Oc51af0eZN2UJUML9r0wPaKcnRRu/jN50gkLZXz2zjhYDBAAI4tXbPKXBWWNPG9X6stf+giN+A4Z3THiQTZHJb3zHReyaANmapShqk1n4owhKjqZVguSXItEaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0nMVL04l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0nMVL04l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1644F1F000E9;
	Tue, 21 Jul 2026 23:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784676141;
	bh=41TTXyqgMXBEqmCnvqKx0YM25xe/MtydgJ+CeMQ+7vE=;
	h=Date:To:From:Subject;
	b=0nMVL04lnRIBDPnLalzFJabSqNG1mYZ1PE9BYyfyFMg3aUrGIRtI4yrdz1rLwH7qd
	 +56lG654GZavFtkhyIpZ52gd2knyl6+pd9xec1sUoxPyNT5huK6GAah/U4ImfPe1Ay
	 2jNwTgauAbKHEzaZ2AW5fTPg+0xdEGdA7GJ4xhTU=
Date: Tue, 21 Jul 2026 16:22:20 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-update-outdated-comment-about-damos-filter-handling.patch added to mm-new branch
Message-Id: <20260721232221.1644F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: update outdated comment about DAMOS filter handling
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-update-outdated-comment-about-damos-filter-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-update-outdated-comment-about-damos-filter-handling.patch

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
From: Song Hu <husong@kylinos.cn>
Subject: mm/damon: update outdated comment about DAMOS filter handling
Date: Tue, 21 Jul 2026 07:00:08 -0700

The kernel-doc comment above enum damos_filter_type states that only the
anon and memcg type filters are handled by damon_operations (and therefore
accounted as 'tried'), and that DAMON_OPS_VADDR and DAMON_OPS_FVADDR do
not support those two filter types.

Neither is accurate anymore.  damos_filter_for_ops() routes every filter
type except ADDR and TARGET to the operations layer, and the VADDR and
FVADDR operations (the latter being a copy of the former) handle all of
those types through damos_folio_filter_match() / damos_va_filter_out(). 
Update the comment to match the code.

Link: https://lore.kernel.org/20260721140011.269802-1-sj@kernel.org
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/damon.h~mm-damon-update-outdated-comment-about-damos-filter-handling
+++ a/include/linux/damon.h
@@ -398,16 +398,15 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
- * The anon pages type and memcg type filters are handled by underlying
- * &struct damon_operations as a part of scheme action trying, and therefore
- * accounted as 'tried'.  In contrast, other types are handled by core layer
- * before trying of the action and therefore not accounted as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
+ * are handled by the underlying &struct damon_operations as a part of scheme
+ * action trying, and therefore accounted as 'tried'.  In contrast,
+ * &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET filters are handled
+ * by the core layer before trying of the action, and therefore not accounted
+ * as 'tried'.
  *
- * The support of the filters that handled by &struct damon_operations depend
- * on the running &struct damon_operations.
- * &enum DAMON_OPS_PADDR supports both anon pages type and memcg type filters,
- * while &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR don't support any of
- * the two types.
+ * Support for the operations-handled filters depends on the running
+ * &struct damon_operations.
  */
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
_

Patches currently in -mm which might be from husong@kylinos.cn are

mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch
docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch
docs-abi-damon-fix-typos.patch
docs-abi-damon-document-update_tuned_intervals-state-command.patch
docs-abi-damon-document-tried_regions-probe-hits.patch
mm-damon-update-outdated-comment-about-damos-filter-handling.patch

