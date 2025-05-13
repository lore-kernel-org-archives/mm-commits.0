Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099F21EEA27
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119289; cv=none; b=ptvpGr0ILcAJz7Ry8m+ifV0kdvqKQfsoYbGLHO3vb6ZXCOcZZrclNu73ZoIaRUy07w4a1dzTGcg4MYZJnyviLuKJyOIAWyfakWHYQ72qTYCdUNC0DLsAb2DRIIf0y+WzKR7IAqxHt6kmhSJP5GHPJMck+a8Pkz5mW4b68rFAI68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119289; c=relaxed/simple;
	bh=mlIlhDeMc7Y2GDzkthe3x4e5zAaFgFb9yb6fX6gJrs4=;
	h=Date:To:From:Subject:Message-Id; b=XjZrfICiwS/StZEOUb57Eh8HcQw+1Hdp9DlNdeYw3ugrxxKR6zO5rYUDe7OiEh44h+ZuLilyG52FidXiFxSZ+QXXDsTjBgpVrYsIJFp5SEaDhATpYCcJDAM8WNci7eKiFhUxSn7wXP4iIj0BXir/sU3+55k5/Za7I4qXyjEgJ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qlD/Vcap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qlD/Vcap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA38C4CEE4;
	Tue, 13 May 2025 06:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119288;
	bh=mlIlhDeMc7Y2GDzkthe3x4e5zAaFgFb9yb6fX6gJrs4=;
	h=Date:To:From:Subject:From;
	b=qlD/VcaptzbHb/30ICGLw3ixUpCIHx6yBstiUAnjEYxKL9yQxltu5sBZfJjWaOjRb
	 R9Bhws2+mBnpyxHbP8iKzpPyB6XVbFQRuC/jVzkYPx2ljzauA7gN1j+6omYeIw0dSv
	 HIPofDJBYb+2QeKJ/0MD97T/uITJNzLZp2rSeJjE=
Date: Mon, 12 May 2025 23:54:48 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch removed from -mm tree
Message-Id: <20250513065448.CAA38C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Hui <suhui@nfschina.com>
Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
Date: Mon, 21 Apr 2025 14:24:24 +0800

It's safer to use kmalloc_array() and size_add() because it can prevent
possible overflow problem.

Link: https://lkml.kernel.org/r/20250421062423.740605-1-suhui@nfschina.com
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add
+++ a/mm/damon/sysfs-schemes.c
@@ -465,7 +465,8 @@ static ssize_t memcg_path_store(struct k
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	char *path = kmalloc(sizeof(*path) * (count + 1), GFP_KERNEL);
+	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
+				   GFP_KERNEL);
 
 	if (!path)
 		return -ENOMEM;
@@ -2064,7 +2065,7 @@ static int damon_sysfs_memcg_path_to_id(
 	if (!memcg_path)
 		return -EINVAL;
 
-	path = kmalloc(sizeof(*path) * PATH_MAX, GFP_KERNEL);
+	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
 	if (!path)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from suhui@nfschina.com are


