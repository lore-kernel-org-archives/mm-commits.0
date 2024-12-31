Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF839664C6;
	Tue, 31 Dec 2024 02:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610417; cv=none; b=gah42FHBX8As/oR3ps2mjpTDUHTWdblflSeC0V+1OFfb1IgrKghJxkajbntjiYcJKDR6lV7xNDvlzKKkTe7ocey3jnkfztNh+ZG52fpaG3DjROuMnW98Gebh1YRModZsOk872G3KGZxEbe1Wk39bcB654zCUL8DYXE2Qth6yDlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610417; c=relaxed/simple;
	bh=H4X5ZentnSL4+Q+i67FLlYvTkdDnbSFwYwYErNrwcLE=;
	h=Date:To:From:Subject:Message-Id; b=kcRTFG78zNiBAFk1Vg6lKiAXiSPP010oBk7dl1y9RW1SMkZ56EIPKoY5qjicGvL1LEeuy+YK5jmuU+Jdlp9xIGDvbQVo4t3C70oeOcbwuZWS5zvA/4pliLNwOk1qg8wGhPfJfNBrSGgSvzrHkpkeP7Jyov4vrTxefmrkBLOgJ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IJWvm1vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IJWvm1vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E1EC4CED0;
	Tue, 31 Dec 2024 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610417;
	bh=H4X5ZentnSL4+Q+i67FLlYvTkdDnbSFwYwYErNrwcLE=;
	h=Date:To:From:Subject:From;
	b=IJWvm1vyP/v5DKE10i+A6F5iYEnGyvydVd28wmg0nz7MNPPOS+fV19BieqPhl8qlO
	 vGJjdcYS1NOONPe+EMdGQk0ZoA2SI7bqsQ69zbtk+8r+LuOnrNy5NgwyWXoR+qJGn+
	 aTGH4ADc3IWySH/0qusk8hv7TTMoXIRFoCdi/z7k=
Date: Mon, 30 Dec 2024 18:00:16 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes.patch removed from -mm tree
Message-Id: <20241231020017.61E1EC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix ignored quota goals and filters of newly committed schemes
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix ignored quota goals and filters of newly committed schemes
Date: Sun, 22 Dec 2024 15:12:22 -0800

damon_commit_schemes() ignores quota goals and filters of the newly
committed schemes.  This makes users confused about the behaviors. 
Correctly handle those inputs.

Link: https://lkml.kernel.org/r/20241222231222.85060-3-sj@kernel.org
Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes
+++ a/mm/damon/core.c
@@ -868,6 +868,11 @@ static int damon_commit_schemes(struct d
 				NUMA_NO_NODE);
 		if (!new_scheme)
 			return -ENOMEM;
+		err = damos_commit(new_scheme, src_scheme);
+		if (err) {
+			damon_destroy_scheme(new_scheme);
+			return err;
+		}
 		damon_add_scheme(dst, new_scheme);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch

