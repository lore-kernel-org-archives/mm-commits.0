Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583382FFF8F;
	Tue, 24 Feb 2026 19:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960446; cv=none; b=O3zSxXv+Nf4Ap1xAVHFgq4YbcnOkt4SEa5kV4KKCdNJMP4SQPqwVPbaJ9DWX6oAoETPZlLY0nMNYaFVIra7/rlWlnd243AhUoWVWfHNiYNRIfZWBuJ6/oJhhUrEGYxaK5hQR+ZLXpN/aC4Ygj+mGPEBa1qkK5ddpQATzujdTD7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960446; c=relaxed/simple;
	bh=MkEGDWBpYEAaUMY1Dn1NfJUAOW7zTauLzOoJ8hwUkBw=;
	h=Date:To:From:Subject:Message-Id; b=fwOyO6zJTVrPoiMoAsdTgehwZWIyoY1RbzJ/GN5n1AougEuVrhYFPw8uYmW+yXZT12fYQpaM+Clk9dogvxQVm7BF/Vi0ThDsdjM7yrsIo1jYouYphVfbPN5CVgSul9zBDA4vtsJ9/fGTNVyR2TArlLhEotFCmXh974+UMXX/kC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HukmJsrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HukmJsrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E452C116D0;
	Tue, 24 Feb 2026 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960446;
	bh=MkEGDWBpYEAaUMY1Dn1NfJUAOW7zTauLzOoJ8hwUkBw=;
	h=Date:To:From:Subject:From;
	b=HukmJsrlrWuTYa8CHhyJUk08wZka8XWjtyZGc9tVUxZDNIcyr5y26zsJzg8pCdgd2
	 xN8Dbkn35Zpd2mB/TPufXiyPNnffYxkf6HIHQsHsmi5DGcrH0DbpGc9e7Ao4MoV+zD
	 Lwqr8yeEy2orXuBr68OQJpdYJHDMicMaVlEdscKc=
Date: Tue, 24 Feb 2026 11:14:05 -0800
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-disallow-non-power-of-two-min_region_sz.patch removed from -mm tree
Message-Id: <20260224191406.2E452C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: disallow non-power of two min_region_sz
has been removed from the -mm tree.  Its filename was
     mm-damon-core-disallow-non-power-of-two-min_region_sz.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: disallow non-power of two min_region_sz
Date: Sat, 14 Feb 2026 13:41:21 -0800

DAMON core uses min_region_sz parameter value as the DAMON region
alignment.  The alignment is made using ALIGN() and ALIGN_DOWN(), which
support only the power of two alignments.  But DAMON core API callers can
set min_region_sz to an arbitrary number.  Users can also set it
indirectly, using addr_unit.

When the alignment is not properly set, DAMON behavior becomes difficult
to expect and understand, makes it effectively broken.  It doesn't cause a
kernel crash-like significant issue, though.

Fix the issue by disallowing min_region_sz input that is not a power of
two.  Add the check to damon_commit_ctx(), as all DAMON API callers who
set min_region_sz uses the function.

This can be a sort of behavioral change, but it does not break users, for
the following reasons.  As the symptom is making DAMON effectively broken,
it is not reasonable to believe there are real use cases of non-power of
two min_region_sz.  There is no known use case or issue reports from the
setup, either.

In future, if we find real use cases of non-power of two alignments and we
can support it with low enough overhead, we can consider moving the
restriction.  But, for now, simply disallowing the corner case should be
good enough as a hot fix.

Link: https://lkml.kernel.org/r/20260214214124.87689-1-sj@kernel.org
Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org>	[6.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-disallow-non-power-of-two-min_region_sz
+++ a/mm/damon/core.c
@@ -1252,6 +1252,9 @@ int damon_commit_ctx(struct damon_ctx *d
 {
 	int err;
 
+	if (!is_power_of_2(src->min_region_sz))
+		return -EINVAL;
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from sj@kernel.org are


