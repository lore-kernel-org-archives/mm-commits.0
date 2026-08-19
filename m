Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439DF377AB4
	for <mm-commits@vger.kernel.org>; Wed, 19 Aug 2026 20:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787172956; cv=none; b=blGaNBDLcF3dpsGUtpVZ+4VHQaeSfJHp52XP7MbQRkXox25rtwxqVrlFxTn47jf7Xfwd0cM4QU8OpTcIKrQlWVxFOr6T677PNNTVE7b8x1HeBqlEdu8Jdw/G6Ry6C0K/fxqG9Y0f/YhvByV7WcZMiNPddFC+9m/ZLFwm6zuyDC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787172956; c=relaxed/simple;
	bh=j66ie4yofuirthRBwPHlWRoMJ3nJmkzr40Bd8tClpTc=;
	h=Date:To:From:Subject:Message-Id; b=A5UQiGLujrzXtkXQkG6BUSzJKJyqLPhOS3zYIqmiL1GBvVNVnyUjtR6y9yJXgSWqnVXBEHVSMejl3ziludYORbPLGeqamEDzB9gOlgGx+YMtwmgki2/VKNy8/EolHXuvqHtvVRYR1uIvNDEE2KpsY5LKwwCUuhxNarzPZCe+zVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zF2x3z2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zF2x3z2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A791F000E9;
	Wed, 19 Aug 2026 20:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787172954;
	bh=fnujot3aPBhwwRImXwTIE2Jiw5RT3gDqaTxOdP+UuX4=;
	h=Date:To:From:Subject;
	b=zF2x3z2QYgW4Gag2RKIG0RTtWk4kIxujfneUBM4OC8qlijAnTOdK09ozflSaiQu8s
	 xcCeoJKv+Y4ZS/l0KB98hpjlFvWszHM0IIt/gUJBPrZ4UDag9xWdYma9xKe3Vtn0kw
	 Tzeebh/z7512sDZ6A6/Qt+sqoknRz5s67Vk7LVaA=
Date: Wed, 19 Aug 2026 13:55:54 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ljs@kernel.org,david@kernel.org,akpm@linux-foundation.org,anshumantewari123@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-stat-return-value-in-khugepaged-get_finfo.patch added to mm-unstable branch
Message-Id: <20260819205554.A1A791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: check stat() return value in khugepaged get_finfo()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-check-stat-return-value-in-khugepaged-get_finfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-stat-return-value-in-khugepaged-get_finfo.patch

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
Cc: David Hildenbrand <david@kernel.org>
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

selftests-mm-fix-unchecked-ftruncate-return-value-in-soft-dirty-test.patch
selftests-mm-check-stat-return-value-in-khugepaged-get_finfo.patch

