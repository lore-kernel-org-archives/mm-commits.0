Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05371C6889
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 04:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273244; cv=none; b=pHWbdh2ZelkpaRZhyJs6MhX7pvZqEXWOn3Uno+5tRMGks3zRq097DdjVZyQMC5Flcu8TcTb686EuWiUGqxNuOVpiLRhU3AWXy9kyzidftGSKpGwhV9d9IMSr3l/pW44cSh4PO/vM1LdtmzB2OtRDLQEpcT8Ovp+efeoQViEE1Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273244; c=relaxed/simple;
	bh=PD3c+GyK6UWzDwYDrbev0wEgYm9Utb5JzMk8lvg/Tyk=;
	h=Date:To:From:Subject:Message-Id; b=gxli7P1xdNL+kXAixF7tYYbNTWhYL+vkWD11cS3uw7+1jPPJFXttAciDJDDByZlvQn+8fHfT/UsvqwEd8NCS06EPGnQwFszXRyHx9ohi+0KdY6bR/9Pgv2qIeiYWd3LWnNBA3mv6hNtmmuRqAhFKvXbMUl+qyNv/ZpNC21g8jJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0TGDIb/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0TGDIb/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC30C4CEEA;
	Tue, 18 Mar 2025 04:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742273243;
	bh=PD3c+GyK6UWzDwYDrbev0wEgYm9Utb5JzMk8lvg/Tyk=;
	h=Date:To:From:Subject:From;
	b=0TGDIb/Sl7AhjvLfFx9Do/nQiQJ0WX6Ox5schFg2VdX7TYf9nxvjl0KQyeNzUkGNb
	 4QAcY7p3X76BiYdawreWDq6TOxEhMryIGfauYgXVrH1KGoTWRclp5OKX6VXoTtdImc
	 AUmukZHIeWCDkSBKe6pjWOdK4nZfFF8XHOHsu5OU=
Date: Mon, 17 Mar 2025 21:47:22 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,sj@kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix.patch removed from -mm tree
Message-Id: <20250318044723.5DC30C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: avoid Wformat-security warning
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/damon/sysfs-schemes: avoid Wformat-security warning
Date: Mon, 10 Mar 2025 14:51:37 +0100

This warning is for potentially user-defined format strings:

mm/damon/sysfs-schemes.c:1664:4: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
 1664 |                         name);

Change this to use "%s" as the format and the name as the argument.

Link: https://lkml.kernel.org/r/20250310135142.4176976-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix
+++ a/mm/damon/sysfs-schemes.c
@@ -1616,7 +1616,7 @@ static int damon_sysfs_scheme_set_filter
 		return -ENOMEM;
 	err = kobject_init_and_add(&filters->kobj,
 			&damon_sysfs_scheme_filters_ktype, &scheme->kobj,
-			name);
+			"%s", name);
 	if (err)
 		kobject_put(&filters->kobj);
 	else
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch

