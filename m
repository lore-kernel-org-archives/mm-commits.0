Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0A33BBFCE
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896570; cv=none; b=J1G7TQ0PHASBT+zmLWogsmgH2W+ndLdh656ZpGmcOBZBiiAIGFdlK8CC4DNfSQJoKIIxEYJO3zNX0pi/pz2tnkcEbLX8NBVDwpfdLVPOEmZgfzJFQG4rltgMVPiuGYD0IVO4pzMLPiWmovGx9+bnPOCHpkrHM4KpG8+/yVaqscc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896570; c=relaxed/simple;
	bh=2XmqO7/To1LSM88SNCk+h/WmrNxnm1RA6Px1gvVjwfU=;
	h=Date:To:From:Subject:Message-Id; b=EivlUOrOVyafrJMe/he1NTBBmhywJ3PZQTzHUDuegjY0/7mn524mchJySnqdX3ZNmXP06I68GBwzjK9BZfCelIM12rN24Zea04cn0dyTRFldvmsDVUtftqmLLU76d9N7iLSiN+EC5ASQRUUMz5o8iadYOcBS1CSt6KFE5fJXfAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i9a6lmQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i9a6lmQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9381F00A3A;
	Wed,  5 Aug 2026 02:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896567;
	bh=BkZgKB3kOkc0Dhywk9zCcfv5RBptdScpKYAbljKcP6I=;
	h=Date:To:From:Subject;
	b=i9a6lmQ91BgCPBtQUjXzKXue1YnDEFjvEckH56VgMnb5TyDEdTNOiTlTFbjFZCea5
	 n8XX/kot2YmsHqd0IDvuFF3i4qWCC7Xlhi5M+EQavx1i5IfmvNQReVAm3eBkbPCuTc
	 oHIWGm3QFBSxFgU13UZHq0fQIyXDbdz6N/x/IZNM=
Date: Tue, 04 Aug 2026 19:22:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,a929244872@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-check-correct-path-in-ensure_file-not_exist-case.patch removed from -mm tree
Message-Id: <20260805022247.3A9381F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: check correct path in ensure_file() not_exist case
has been removed from the -mm tree.  Its filename was
     selftests-damon-check-correct-path-in-ensure_file-not_exist-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wang wei <a929244872@163.com>
Subject: selftests/damon: check correct path in ensure_file() not_exist case
Date: Mon, 6 Jul 2026 21:43:04 +0800

In the ensure_file() function, the "not_exist" code path checks whether
$dir exists as a regular file.  However, the intent is to verify that the
target file ($file) does not exist, not the $dir.  Testing $dir makes the
existence check effectively useless -- it tests the wrong path and thus
never catches the case where the file is unexpectedly present.

Replace $dir with $file so the not_exist verification targets the correct
path.

Link: https://lore.kernel.org/20260706134305.5224-1-a929244872@163.com
Signed-off-by: wang wei <a929244872@163.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-check-correct-path-in-ensure_file-not_exist-case
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -67,7 +67,7 @@ ensure_file()
 			echo "$file permission: expected $permission but $perm"
 			exit 1
 		fi
-	elif [ "$to_ensure" = "not_exist" ] && [ -f "$dir" ]
+	elif [ "$to_ensure" = "not_exist" ] && [ -f "$file" ]
 	then
 		echo "$file is not expected but found"
 		exit 1
_

Patches currently in -mm which might be from a929244872@163.com are


