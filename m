Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A49372B2F
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 18:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777142286; cv=none; b=tl3pmjyq/CNVF3ueXg6wzkexvtZr27grFEIlT4ebvlfoPZPGMYoYJOcn5AxRZEsO0ty1foOm3tRjFcIWZAQoLM+2GWg27AGNCTJELlz3E6Po2efx5e+8/ArI06y7m+JOl9PrKO3ournPxpiFgvmBWr4q7XQT14C0KMzu3T04oW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777142286; c=relaxed/simple;
	bh=utsaDH5BUdsfR5jPo5FrtyGoxU0Hnz1HAHyEIAd+EwQ=;
	h=Date:To:From:Subject:Message-Id; b=WM7paWTA1rvCZXfq1rNlKnGo1w06+fZP1tfHMOCCc5Ckg58Kl7EZlX4RK43wUJ1ej5Z4zYsz33QzNo1Ep44cNWs8bAMVxh+MInwWi9Ccd4H2N5HWZK5nwWUfPvPik+udu6ZT9RKI/VS5DPTIb6MHHQuNjlA8aKF6C10poWa4Roc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l6FZEBES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l6FZEBES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F12C2BCB0;
	Sat, 25 Apr 2026 18:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777142285;
	bh=utsaDH5BUdsfR5jPo5FrtyGoxU0Hnz1HAHyEIAd+EwQ=;
	h=Date:To:From:Subject:From;
	b=l6FZEBESAeBhg6SXV3bpMA5Ow7643UXL9xeGnEePyaESayrIegrzuoZwZ/d3Wczzu
	 VBgMaZkf2aCZm+etdBVjKtlP/zoGeuxiHrk35WQalXJWYKLIiLSygVLRrNAo5R/EKT
	 c/T0jvVHXTcgbSzII6k8Ezw5Dbqj5TSeapEM0rjk=
Date: Sat, 25 Apr 2026 11:38:05 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jlayton@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-filelock-add-a-gitignore-file.patch added to mm-nonmm-unstable branch
Message-Id: <20260425183805.96F12C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest/filelock: add a .gitignore file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kselftest-filelock-add-a-gitignore-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-filelock-add-a-gitignore-file.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Mark Brown <broonie@kernel.org>
Subject: kselftest/filelock: add a .gitignore file
Date: Thu, 26 Feb 2026 16:05:27 +0000

Tell git to ignore the generated binary for the test.

Link: https://lore.kernel.org/20260226-selftest-filelock-ktap-v4-3-db8ae192ff42@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filelock/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/filelock/.gitignore a/tools/testing/selftests/filelock/.gitignore
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/filelock/.gitignore
@@ -0,0 +1 @@
+ofdlocks
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch
kselftest-filelock-use-ksft_perror.patch
kselftest-filelock-report-each-test-in-oftlocks-separately.patch
kselftest-filelock-add-a-gitignore-file.patch

