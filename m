Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976E4372662
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028754; cv=none; b=YUjzcH19KNcPHTvp+tBf5VGfaW2amGDO/aHdaDxuycGxuchzP7saoz2TWqy0kOXYjdhefKZJqcumPHMZJEu9rW8Lj/iB+ZxWqnbvWMrG8FoJ9dyIhqRUCkXe/bCdBDdxRGXf57MsuP6UiYtlONhk2wu1dbyH1q38WjirqxxqeWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028754; c=relaxed/simple;
	bh=ymydo9ldWguFzUNdqInppXSS/xu94pFU9nNmQtYYB/Y=;
	h=Date:To:From:Subject:Message-Id; b=Sb0n0zUuwkrWmqVGrikWIiAY/ww+C5L3pD2Jzblo2lHSzXKpVnLdWJkqGAJ0RX4Ubxxfi5/9iG8mcIwryy4e9zp5iaPbuIpodPeeKz76NglkVAJxjXft3KNbWq4L35QJJyWREBf3JAEEZOV22r81TZTA72tY8ck84laxeLMg3Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GWDcLlZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GWDcLlZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D9C1F00898;
	Fri, 29 May 2026 04:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028753;
	bh=Zt9GbhsIowTF9mi70be67SigawbBwKePUI8nq7waTbE=;
	h=Date:To:From:Subject;
	b=GWDcLlZ5qq25LBYGxj1+7ivcvyDXyi57gsRfx14dAvFYJrAqyR2xI5zwFXXwlSoL5
	 h+QBGru9i80lfBdEvaRwsRnGRXXi7u9qdrSiL/7EDiJNg9s577wnb8pnqwfCgxFVpB
	 E1tIBil3eMlYbl4hqK57NDJPhGtQ5i2lvsnzjzzA=
Date: Thu, 28 May 2026 21:25:53 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jlayton@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kselftest-filelock-use-ksft_perror.patch removed from -mm tree
Message-Id: <20260529042553.68D9C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest/filelock: use ksft_perror()
has been removed from the -mm tree.  Its filename was
     kselftest-filelock-use-ksft_perror.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: kselftest/filelock: use ksft_perror()
Date: Thu, 26 Feb 2026 16:05:25 +0000

Patch series "selftests/filelock: Make output more kselftestish", v4.

This series makes the output from the ofdlocks test a bit easier for
tooling to work with, and also ignores the generated file while we're
here.


This patch (of 3):

The ofdlocks test reports some errors via perror() which does not produce
KTAP output, convert to ksft_perror() which does.

Link: https://lore.kernel.org/20260226-selftest-filelock-ktap-v4-0-db8ae192ff42@kernel.org
Link: https://lore.kernel.org/20260226-selftest-filelock-ktap-v4-1-db8ae192ff42@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filelock/ofdlocks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/filelock/ofdlocks.c~kselftest-filelock-use-ksft_perror
+++ a/tools/testing/selftests/filelock/ofdlocks.c
@@ -16,7 +16,7 @@ static int lock_set(int fd, struct flock
 	fl->l_whence = SEEK_SET;
 	ret = fcntl(fd, F_OFD_SETLK, fl);
 	if (ret)
-		perror("fcntl()");
+		ksft_perror("fcntl()");
 	return ret;
 }
 
@@ -28,7 +28,7 @@ static int lock_get(int fd, struct flock
 	fl->l_whence = SEEK_SET;
 	ret = fcntl(fd, F_OFD_GETLK, fl);
 	if (ret)
-		perror("fcntl()");
+		ksft_perror("fcntl()");
 	return ret;
 }
 
_

Patches currently in -mm which might be from broonie@kernel.org are


