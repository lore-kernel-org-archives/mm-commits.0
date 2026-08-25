Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD1349CC4
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622961; cv=none; b=NX0Tye7TvZ00Bzdpc9F+SStzHwoVIlgh/iHJmghhC8zMZJqwbA9HdHP+/aLKTWw0ggvX2wZW3Elb5mHutfq89P5LrMW+hT+TkwSQEYsK4v9YeHgxH9AVUVQpMh+Raach/bp910H6vsDWp/0ahUvZ+vLCCF1Uq4IA/nPm3BdlL8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622961; c=relaxed/simple;
	bh=m64ui3FLe8Vm/xaXSJKdQv7YywDzREpM/fW0duMhxFA=;
	h=Date:To:From:Subject:Message-Id; b=qoCEuUKrus3a2TL8vkf1UHYiyP1iag6HGON+/gvwIZrQIS8oHtgMx7Q1c8mu0l6D5SuGMSw3bGHQcNdMBx1xBYsl5XBCZKh8VM+hqPeRe7M1EJKmGPO4oxOvYlJOTdR+3yQbZ1cxw5EP1Wbj6RBn9lllVg9tVj/YHT6o804BTug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+9SEGso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+9SEGso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0341B1F000E9;
	Tue, 25 Aug 2026 01:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622960;
	bh=hijnXD+aFsrwOfvYOUEOALqi8Z9EnQZ7Om285ifRJkc=;
	h=Date:To:From:Subject;
	b=C+9SEGsoDOIPwJKkNAgMJDHTJpMST0hKBkgdfaOFEEcT/DAro3c9qa8aPMofjs18k
	 8EOLaH4WZkoDVOjo5Tpr7O7J0Xr0WIDBExDCXm/jgWogROE+oY5w15hClvZIBI5dWF
	 E76UT2Ym3girsjQrKZZnv+FjIL4bnADwFuIAqztU=
Date: Mon, 24 Aug 2026 18:55:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,sarthak.sharma@arm.com,ljs@kernel.org,david@kernel.org,akpm@linux-foundation.org,anshumantewari123@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-check-stat-return-value-in-khugepaged-get_finfo.patch removed from -mm tree
Message-Id: <20260825015600.0341B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: check stat() return value in khugepaged get_finfo()
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-stat-return-value-in-khugepaged-get_finfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman <anshumantewari123@gmail.com>
Subject: selftests/mm: check stat() return value in khugepaged get_finfo()
Date: Wed, 19 Aug 2026 17:44:26 +0530

get_finfo() calls stat() to get metadata about the target directory, but
never checks the return value.  On failure, stat() returns -1 and leaves
path_stat unmodified, so path_stat.st_mode may contain uninitialized stack
data.

The code then checks S_ISDIR(path_stat.st_mode) against this potentially
garbage value.  This can produce a misleading "Not a directory" error when
the real problem is a nonexistent or inaccessible path, or, in the worst
case, the check could pass by chance on garbage data and let the function
continue using an invalid path_stat for the rest of its logic.

Check the return value and fail with a clear error message if stat()
fails, matching the error-handling style already used for statfs() and
read_file() later in the same function.

Link: https://lore.kernel.org/20260819121426.49500-1-anshumantewari123@gmail.com
Signed-off-by: Anshuman <anshumantewari123@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-check-stat-return-value-in-khugepaged-get_finfo
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -124,7 +124,8 @@ static void get_finfo(const char *dir)
 	char *str, *end;
 
 	finfo.dir = dir;
-	stat(finfo.dir, &path_stat);
+	if (stat(finfo.dir, &path_stat))
+		ksft_exit_fail_perror("stat()");
 	if (!S_ISDIR(path_stat.st_mode))
 		ksft_exit_fail_msg("%s: Not a directory (%s)\n", __func__, finfo.dir);
 	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
_

Patches currently in -mm which might be from anshumantewari123@gmail.com are


