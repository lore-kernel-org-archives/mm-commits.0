Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B29E272813
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646614; cv=none; b=DkbphwH4CWIRRRM7ZQE2tPj1drEV8NxUA0XYnpxTM/U/U1CKT+kxX8W06DQBvBFpD0xpS4tj7tpwJRFb7WzWQo1sjvIO21epHbwObThpICTxza9zMwhA8M6o2DNV7Ul+06VC7ZjqPnoHhGHv+83qwtsQD4QQbLaVj/L4Wls51hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646614; c=relaxed/simple;
	bh=4184u+wMKNcfAntM4cw1BYS3Cdn/7kdbOgrwhpbdI6I=;
	h=Date:To:From:Subject:Message-Id; b=qePqj5KN3y37n5vWYTCEZL+KB28FieA1oEVw2tpyOOxoZ9iYfg2/N3cFUxyO/D3Se54gvmdnJmDdjG9vDItSqtB9/ySQYStI6y7Ze3X9LOefNO4hTObwSO+H4/HuKKdvO66O/SAq08hR1cnHHp0gE8rd02Or3Ethk4GuM0P0ERM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OLxjY/U8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OLxjY/U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A66C113D0;
	Tue, 19 Aug 2025 23:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646613;
	bh=4184u+wMKNcfAntM4cw1BYS3Cdn/7kdbOgrwhpbdI6I=;
	h=Date:To:From:Subject:From;
	b=OLxjY/U8FsEvfIY9HWhuLZxBidc3yqQ8CWx8zTM1JZkZMOOqha2sDWtKA7BGeH09C
	 Wn2qoRdTmlplx5z9gm9Wi/FoeTU07mfdTKQxJDDh94TdTxDumKIbWGJHpW4Pz64zty
	 /guc2N2e0PSUsl4k2N3ZHJAgBUpN1WITBT7GfEXE=
Date: Tue, 19 Aug 2025 16:36:53 -0700
To: mm-commits@vger.kernel.org,alexghiti@rivosinc.com,alex@ghiti.fr,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-put-damos-dests-dir-after-removing-its-files.patch removed from -mm tree
Message-Id: <20250819233653.B4A66C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: put damos dests dir after removing its files
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-put-damos-dests-dir-after-removing-its-files.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: put damos dests dir after removing its files
Date: Sat, 16 Aug 2025 09:55:59 -0700

damon_sysfs_scheme_rm_dirs() puts dests directory kobject before removing
its internal files.  Sincee putting the kobject frees its container
struct, and the internal files removal accesses the container,
use-after-free happens.  Fix it by putting the reference _after_ removing
the files.

Link: https://lkml.kernel.org/r/20250816165559.2601-1-sj@kernel.org
Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Alexandre Ghiti <alex@ghiti.fr>
Closes: https://lore.kernel.org/2d39a734-320d-4341-8f8a-4019eec2dbf2@ghiti.fr
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-put-damos-dests-dir-after-removing-its-files
+++ a/mm/damon/sysfs-schemes.c
@@ -2158,8 +2158,8 @@ static void damon_sysfs_scheme_rm_dirs(s
 {
 	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
-	kobject_put(&scheme->dests->kobj);
 	damos_sysfs_dests_rm_dirs(scheme->dests);
+	kobject_put(&scheme->dests->kobj);
 	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	kobject_put(&scheme->watermarks->kobj);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch

