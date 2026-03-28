Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B79443;
	Sat, 28 Mar 2026 00:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774658360; cv=none; b=BWTQy49lm+sRMZgQ48fcV3+oL1nVnbZ+lUUALAJ1DuVVM8X+FmbOojj6GjJM1kWMHCLd4aYyH6MTGexJwPJPvtDrD0wU8/VqMpI327vhUWxCmytDj7SCOksgp42Onq+1m0c9cjI+w4BjGuEYrNzivS3jSsVpihmrg67ko94tw8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774658360; c=relaxed/simple;
	bh=7cpAsVyuyg87M3+Wqf6b58oK8qw7wjxNntQBjtGbY4M=;
	h=Date:To:From:Subject:Message-Id; b=ZMAmC/2X9jvV6FW2jq8g8jTOStgEtVAuKJm53yndGeXj4lFGFm5quDJW5q4no5dbZivQPGvMO5GNoZk2k1/R9c+mnpjfnXDabZiDW5JhWUt1aFeKb8vtAZn9p9f4y2h2YNGsel3PEyrtJn9XpVIpHlo9Ojb43W8nfg0QW8ED3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n0f96Lq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n0f96Lq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4516EC2BCB1;
	Sat, 28 Mar 2026 00:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774658360;
	bh=7cpAsVyuyg87M3+Wqf6b58oK8qw7wjxNntQBjtGbY4M=;
	h=Date:To:From:Subject:From;
	b=n0f96Lq5/fU913oLpd7DYws6NU7KMKVeeoim3vJj1hmsxFcizNAIcWZTEnO0dsacv
	 IKPDR8pNZI8IE65WQNEl9WoUl5jNSHZMQG0nzRFJi5zFyXkfR7cQ3F9TtrHpKYvLRH
	 YL1Alhc54T6RevPfpgXHHBUDNY4wt5bxWExntC08=
Date: Fri, 27 Mar 2026 17:39:19 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-check-contexts-nr-in-repeat_call_fn.patch removed from -mm tree
Message-Id: <20260328003920.4516EC2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: check contexts->nr in repeat_call_fn
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-check-contexts-nr-in-repeat_call_fn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
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
lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch
lib-bch-fix-signed-left-shift-undefined-behavior.patch
lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

