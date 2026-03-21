Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E357C311C32;
	Sat, 21 Mar 2026 18:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774117702; cv=none; b=u2X9JPOdThDEoRB0yQwzIfT6rgXWYo2aya24C8uXmQk7g5L7tbfAbxp0ei7jezFDKDaTKfMN6H5pZwl45Q4TLN5z0tG4qy4MaymBIBpS5Dt3csI8Sd9V8yXvISSqVbim4ZfCfU7RElyF7YJjfQUrazzRrlt4tl43BCDVWDQQOiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774117702; c=relaxed/simple;
	bh=oBID60Mn8tY5owzZdEfs3uUWxHGjP8bqVh4u8vKqC1I=;
	h=Date:To:From:Subject:Message-Id; b=hG6ZzTsZoPhGGI7t/38PmyoIbM3BgfjjaFVheU5jh0QNDKewUQquecClJOntFLSiVP+2UDfM6kFXQW28MWI5gdo2nBelTeSUVKrjRSYDDkT9QtcPbq9FxFwFfF5uQVN/zxF9P3E9zYgupUdujLm5sK+rKM0audg5B5W3m3n/5IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O3agV0h3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O3agV0h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CDBC19421;
	Sat, 21 Mar 2026 18:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774117701;
	bh=oBID60Mn8tY5owzZdEfs3uUWxHGjP8bqVh4u8vKqC1I=;
	h=Date:To:From:Subject:From;
	b=O3agV0h3ecRj2P+HasF1y7uR5K03DzEIiUylmwqosLEYdRXKrea1tdCFqlDxJHgTu
	 qEssKGq2QZQJvrMgxKYjZOlFpJJDE6SDIXU5Ct1LKqK9wgle6KsyRDy+vwgmsHmfUj
	 VGrCTtluhZs9Zd3tcCN4oe9a+bUd6QReR9r13UTM=
Date: Sat, 21 Mar 2026 11:28:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-check-contexts-nr-in-repeat_call_fn.patch added to mm-hotfixes-unstable branch
Message-Id: <20260321182821.73CDBC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: check contexts->nr in repeat_call_fn
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-check-contexts-nr-in-repeat_call_fn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-check-contexts-nr-in-repeat_call_fn.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Josh Law <objecting@objecting.org>
Subject: mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Sat, 21 Mar 2026 10:54:26 -0700

damon_sysfs_repeat_call_fn() calls damon_sysfs_upd_tuned_intervals(),
damon_sysfs_upd_schemes_stats(), and
damon_sysfs_upd_schemes_effective_quotas() without checking contexts->nr. 
If nr_contexts is set to 0 via sysfs while DAMON is running, these
functions dereference contexts_arr[0] and cause a NULL pointer
dereference.  Add the missing check.

For example, the issue can be reproduced using DAMON sysfs interface and
DAMON user-space tool (damo) [1] like below.

    $ sudo damo start --refresh_interval 1s
    $ echo 0 | sudo tee \
            /sys/kernel/mm/damon/admin/kdamonds/0/contexts/nr_contexts

Link: https://patch.msgid.link/20260320163559.178101-3-objecting@objecting.org
Link: https://lkml.kernel.org/r/20260321175427.86000-4-sj@kernel.org
Link: https://github.com/damonitor/damo [1]
Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-check-contexts-nr-in-repeat_call_fn
+++ a/mm/damon/sysfs.c
@@ -1620,9 +1620,12 @@ static int damon_sysfs_repeat_call_fn(vo
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return 0;
+	if (sysfs_kdamond->contexts->nr != 1)
+		goto out;
 	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
 	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
 	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
+out:
 	mutex_unlock(&damon_sysfs_lock);
 	return 0;
 }
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-sysfs-fix-param_ctx-leak-on-damon_sysfs_new_test_ctx-failure.patch
mm-damon-sysfs-check-contexts-nr-before-accessing-contexts_arr.patch
mm-damon-sysfs-check-contexts-nr-in-repeat_call_fn.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
lib-bug-remove-unnecessary-variable-initializations.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch
lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch
lib-bch-fix-signed-left-shift-undefined-behavior.patch
lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch

