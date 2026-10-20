Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792468913;
	b=br50xpyDtNS9SqZLM5+P3+MzlEQM3UxXhuBCYuMnQsqkcculgpNy1aj8qTQa3HtfFlkM
	 JDgn2up+J/MspTCaQJ68V5VuDADZcrSNs+gEtXUkpaiIO/25VK+v7AfxEwpwFNmTTFB5j
	 lahctHgXRq1hKTJgZ8AMWYyitmSMHCNIA8BLmN+ndpmwucdJx5jMaxAjGgpzjmiu0NeDg
	 w2/5TaQnYL0ACe/Y7Gvgy25L+ISz4i0kJ5aSx6MJi8K3ZhbddFNvMfjSlaOZt/jbvx+L8
	 oYiVd76Ykd0YEzdkNZHgY4e1OR4bWRcCEr3642GjJpjUFZ97qJPsIuPUVTUpODC2G3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468913;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Bt7XsJIgW4Lu6Mhb+nkalyGmIkyhNEANpu9bya4kirI=;
	b=0Qazj9eh6R8gcLsJ3Fwt7gXaP3bceK2tpWh1wGY1xJJFYIceofp3es/97urUtwOMpSsT
	 HoQXQyqfAW/RgftiGzfzygS6PN5JcjNMIhLHB/XYBmEsAynQ3VDS/GhgLZV0l3JJ81rup
	 QfpMtEDhKgde6K/YvZXEgimv9nGbzGSJsyJU8ez0ixWF8TTElbvPL6SKKB0UXiaUXyn5o
	 P12gOqCenr2nfhTcAxwAXuKZzW54FEAOdyrnE2bJAXoYbCBhl2oQxNTXqWZi544nl5TDq
	 zkcDh3IUgy86m78LRvqRgBvDCZHKf974p9ceh/+30uFIg1nUXqbHCjwO7DDqytpOxCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="0D/GUNTu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE64606A319;
	Tue, 20 Oct 2026 04:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0D/GUNTu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECB11F000C5;
	Tue, 20 Oct 2026 04:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792468912;
	bh=Bt7XsJIgW4Lu6Mhb+nkalyGmIkyhNEANpu9bya4kirI=;
	h=Date:To:From:Subject;
	b=0D/GUNTuMXWbuAW4NhmM9vZ6tX8zV4DJ6bbfeHfeyt9ZLOmW3K2V756KRxaKIpYvq
	 FQGj+MWVz2nWSMrWbk9JGtOTHljYn7FRAip8wuYx2uxXzOnlkQGwpCyy2jJDdv0M8/
	 PuCiLZITSh1+HBDPGCAthNRkfjBsFtOVxsaC6+SU=
Date: Mon, 19 Oct 2026 21:01:51 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-unreachable-damos-charge_targetaddr_from.patch added to mm-unstable branch
Message-Id: <20261020040152.5ECB11F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: remove unreachable damos charge_{target,addr}_from
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-remove-unreachable-damos-charge_targetaddr_from.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-unreachable-damos-charge_targetaddr_from.patch

This patch will later appear in the mm-unstable branch at
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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Mon, 19 Oct 2026 19:39:56 -0700

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
---

 mm/damon/core.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-remove-unreachable-damos-charge_targetaddr_from
+++ a/mm/damon/core.c
@@ -3383,6 +3383,26 @@ static void damos_trace_esz(struct damon
 	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -3418,6 +3438,8 @@ static void damos_adjust_quota(struct da
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (damos_quota_is_full(quota, c->min_region_sz))
 		return;
 	if (!c->ops.get_scheme_score)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch
mm-damon-core-filter-out-damos-address-filter-split-failed-region.patch
mm-damon-core-remove-unreachable-damos-charge_targetaddr_from.patch

