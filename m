Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E91F3C4B6F
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439209; cv=none; b=JZkkr/l09bqUwY/X0NWGXJLyKO5x15z37XeDq6LpnOqQzOn3aAnkc08GVpFdAm7PNdiEmjLOjjceH3BfJCa8L5pbSZtLIkUd7tQKnx1AZv4gClmP+0K+OJpjN2scW1VouQ8mShcoAhbS3OrkFBfPgLMZOr1coCNvgV0llt9K9eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439209; c=relaxed/simple;
	bh=FJljeY9qW8cMikpa5ZmZRWsIE4rWr4bmfwA4hs7nNNU=;
	h=Date:To:From:Subject:Message-Id; b=Z5o5ZkGH68H9ge3KzqeIw8ySH3aGjiocR/nHfVfWjcrlstc3f0enf8JGVDSQs1E7YJrm2DZsFSEnvUekkmhWPm83pT6aGDtRWhtckDi4KIPsOVFP5sLjxXIqq3Khm2XGYUBT+ETUIkXiTzhsyAUQp6dNXwDLicftMycsdN4qt0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DPZutns4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DPZutns4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135DC1F00898;
	Tue,  2 Jun 2026 22:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439208;
	bh=yM8ml23QAKKHMSU7WSXraWQaayj2f0TpfPNH1DSAsFk=;
	h=Date:To:From:Subject;
	b=DPZutns4jpPgLvu0CKVCE41zDyUk+GeFZMdmvy4lU5uyUWBXHkV3KjGTgSnaF0wZ2
	 gMx22CbVClb5tvpoZ9PXzEAs6Ql5cT34cwsG+eXVF6V9Of1FdpTJWJhswihPsLDlXq
	 lsYrP+VWr7+MU9CHTtpA4xQvzEPlKkICjR1IjZ38=
Date: Tue, 02 Jun 2026 15:26:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,aris@redhat.com,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-remove-unused-variable-sig-in-fuse_test.patch removed from -mm tree
Message-Id: <20260602222648.135DC1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd: remove unused variable 'sig' in fuse_test
has been removed from the -mm tree.  Its filename was
     selftests-memfd-remove-unused-variable-sig-in-fuse_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: selftests/memfd: remove unused variable 'sig' in fuse_test
Date: Sun, 24 May 2026 22:35:57 +0300

  fuse_test.c: In function 'sealing_thread_fn':
  fuse_test.c:165:13: warning: unused variable 'sig' [-Wunused-variable]
    165 |         int sig, r;
        |             ^~~

Remove unused 'sig' to fix -Wunused-variable warning.

Link: https://lore.kernel.org/20260524193732.48853-3-eva.kurchatova@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/fuse_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/memfd/fuse_test.c~selftests-memfd-remove-unused-variable-sig-in-fuse_test
+++ a/tools/testing/selftests/memfd/fuse_test.c
@@ -162,7 +162,7 @@ static void *global_p = NULL;
 
 static int sealing_thread_fn(void *arg)
 {
-	int sig, r;
+	int r;
 
 	/*
 	 * This thread first waits 200ms so any pending operation in the parent
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are


