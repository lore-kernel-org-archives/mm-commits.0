Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100C8B673
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957133; cv=none; b=pGChrSQ7GdAO9hXLFbq8cms6wKLnVshzSb+XmCFb+MRPcvC8wcL1qcUaCgOLYRwgUfQPUFBqLRdAi1KedVOErbgxLfTR91ODAu7OR7I/D+9nZXc7D934ZMY/I3jzYhiet+c1GPsbuyWTeLp69hXxZtnx3odh1noAJrMlZBwRuU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957133; c=relaxed/simple;
	bh=SWhoHUIAf4SWcsD7kB5YEe0OZTVzqnBPGgRuCPwe40c=;
	h=Date:To:From:Subject:Message-Id; b=SUqf/eOfijbSwZ1yPxDe3xxzDi5MWpScAxuGBaQSf+of9nG1CoB0rYnQnJHzCzy7gL2SwfyJg6U0N48pz7BVrVS9R5wJ3iB04rqbTNwWm9FEIFnTcSRpSOH7lBNXRpCcPkecM/rpiDNkwJjTL2hmV3jcG/9eGz8aaLd1cybJPA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AiLg+9GC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AiLg+9GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A66C113CC;
	Mon,  6 May 2024 00:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957132;
	bh=SWhoHUIAf4SWcsD7kB5YEe0OZTVzqnBPGgRuCPwe40c=;
	h=Date:To:From:Subject:From;
	b=AiLg+9GC7DOPeYNXvurHpAKtyfhE9CF7M2uL0UmPw4OoHDH8wOd5yGAfrda6kokYh
	 DZCrzjBQ7/+34SccrN7QgXEpGpC7Tc+3/hSQ+ISF4om4sxJvP6VtZS+jP5dEmTEEcz
	 +maQSbvZbUDkpkINJhja3CzZZADCLDsUkcoyCdK4=
Date: Sun, 05 May 2024 17:58:52 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-implement-damos-filter-type-young.patch removed from -mm tree
Message-Id: <20240506005852.85A66C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: implement DAMOS filter type YOUNG
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-implement-damos-filter-type-young.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: implement DAMOS filter type YOUNG
Date: Fri, 26 Apr 2024 12:52:43 -0700

DAMOS filter of type YOUNG is defined, but not yet implemented by any
DAMON operations set.  Add the implementation on 'paddr', the DAMON
operations set for the physical address space.

Link: https://lkml.kernel.org/r/20240426195247.100306-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-implement-damos-filter-type-young
+++ a/mm/damon/paddr.c
@@ -214,6 +214,11 @@ static bool __damos_pa_filter_out(struct
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMOS_FILTER_TYPE_YOUNG:
+		matched = damon_folio_young(folio);
+		if (matched)
+			damon_folio_mkold(folio);
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

