Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4937618C031
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006308; cv=none; b=DltvIL/XSsK10BfATNXhx1GwskPWYn3u+zAg4xz01mo8bUngZDG7jlzaGrm+PUcrIIE/nrpXHwK6cDZF6jq/FcR3HpokvMa6yBmvE77ZHTyZ5x/ZVnS/gvCnNvj0CyOLXySmfRqtchiw6pjzgMbcSvgrEuOULcNYjzqIDwigaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006308; c=relaxed/simple;
	bh=JO4dOVCs7P6pVef4vHbPy604w3DcEV4+RMo69LpQY3A=;
	h=Date:To:From:Subject:Message-Id; b=a5yupQxFOqYhJZ54h4CEMj0Mn5WwVRBeZ/zvEnA1tE4+3VzyKxOLIcM2SMCo3jB1zK8k/H0145cTKJK6ocq2KL57qo7r9F8GqtuJNTmX4advJHfacypuoZgOy2yVa2HQ6nrcUJwyY+aci3EEngP9heNKVHQD1Dg7RXH7WFgQ4/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vGFooTlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vGFooTlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDE4C4CED6;
	Thu, 16 Jan 2025 05:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006307;
	bh=JO4dOVCs7P6pVef4vHbPy604w3DcEV4+RMo69LpQY3A=;
	h=Date:To:From:Subject:From;
	b=vGFooTlAKgmWEy4yeGbZ+2ZpIcrh7uEo6lensN9Cbvjz9G7r0IgG26MfnMyFtH7c4
	 yPk5rVZUtmwPaexPY7MpwMFdhrYDKz6kkywl225TaTwbMyWmlq5ogxt1pSXJHUkRgO
	 IPVTzlzVBTnE+aWyZ3z77EVuH4lDXOy9SNokM+tA=
Date: Wed, 15 Jan 2025 21:45:07 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-improve-readability-of-damon_pa_stat.patch removed from -mm tree
Message-Id: <20250116054507.CFDE4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: improve readability of damon_pa_stat
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-improve-readability-of-damon_pa_stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/damon/paddr: improve readability of damon_pa_stat
Date: Mon, 13 Jan 2025 13:01:56 -0800

damon_pa_stat contains an unnecessary goto statement, and the if/else can
be re-written to be more readable.

This patch is written on top of SJ's patch series [1], which in turn is
written on top of another one of his series [2].

[1] https://lore.kernel.org/all/20241219040327.61902-1-sj@kernel.org/
[2] https://lore.kernel.org/all/20241213215306.54778-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20250113210201.446051-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-improve-readability-of-damon_pa_stat
+++ a/mm/damon/paddr.c
@@ -513,11 +513,8 @@ static unsigned long damon_pa_stat(struc
 			continue;
 		}
 
-		if (damos_pa_filter_out(s, folio))
-			goto put_folio;
-		else
+		if (!damos_pa_filter_out(s, folio))
 			*sz_filter_passed += folio_size(folio);
-put_folio:
 		addr += folio_size(folio);
 		folio_put(folio);
 	}
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are


