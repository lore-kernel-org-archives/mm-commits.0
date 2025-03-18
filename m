Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E83B1CF5C0
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274634; cv=none; b=kJGtQ1ZRYTuwgjgEI8MOpetN9uue5ODgPJjUfz8YuC1M8RBfXtDqo74KZOEn/fH9I7N/X0oqgLG4/JS3oK5nZV0juLm3x5ek08xzQ21hrpKkFR4o5LfSf5gB/GFyzoBOmgic/7v+dUT/fFkXzrcyf1hP0Ar22+qnD7liQm4YmKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274634; c=relaxed/simple;
	bh=2xGLQjBAnWZIfgkwzdNUDxCFOcF/bzC4d4g4+SF9ErY=;
	h=Date:To:From:Subject:Message-Id; b=gxf992fkSticipkoM2+D1Y8Z1ROP8nr35g7pID0OA7x8R8S2TceS7hvoBNijNF0iy73jm4mIpC54o/tk8zFXOqUBuOqqTPWSoJOwD2VuhvZS1fV6CIcFH2GB2uRTebGBh+3HXOMhVIWDU/jHz90p9qCmY0jHLqMWBBt/E1ybr6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O4oQo69/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O4oQo69/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23649C4CEDD;
	Tue, 18 Mar 2025 05:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274634;
	bh=2xGLQjBAnWZIfgkwzdNUDxCFOcF/bzC4d4g4+SF9ErY=;
	h=Date:To:From:Subject:From;
	b=O4oQo69/+G7U7ZR5OD1dm5pMJiSXYTd0ntbwXcIVAT1XzTNVXwhCv7d3niMJr7EzJ
	 rUmh3BkMCNfi1mrwOYScKng0AoNjpqEJrJhVR2xGkdtl3zAgr0/RSflqfE4oOMNtTq
	 /0hpFHKKLsajbwdAjlMf81FOmSNLfaQRiH1S5BvE=
Date: Mon, 17 Mar 2025 22:10:33 -0700
To: mm-commits@vger.kernel.org,arnd@arndb.de,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch removed from -mm tree
Message-Id: <20250318051034.23649C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: avoid Wformat-security warning on damon_sysfs_access_pattern_add_range_dir()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: avoid Wformat-security warning on damon_sysfs_access_pattern_add_range_dir()
Date: Mon, 10 Mar 2025 09:50:09 -0700

When -Wformat-security is given, compiler warns as a potential security
issue on damon_sysfs_access_pattern_add_range_dir() as below:

    mm/damon/sysfs-schemes.c: In function `damon_sysfs_access_pattern_add_range_dir':
    mm/damon/sysfs-schemes.c:1503:25: warning: format not a string literal and no format arguments [-Wformat-security]
     1503 |                         &access_pattern->kobj, name);
          |                         ^

Fix it by using "%s" as the format and the name as the argument.

Link: https://lkml.kernel.org/r/20250310165009.652491-1-sj@kernel.org
Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir
+++ a/mm/damon/sysfs-schemes.c
@@ -1471,7 +1471,7 @@ static int damon_sysfs_access_pattern_ad
 	if (!range)
 		return -ENOMEM;
 	err = kobject_init_and_add(&range->kobj, &damon_sysfs_ul_range_ktype,
-			&access_pattern->kobj, name);
+			&access_pattern->kobj, "%s", name);
 	if (err)
 		kobject_put(&range->kobj);
 	else
_

Patches currently in -mm which might be from sj@kernel.org are


