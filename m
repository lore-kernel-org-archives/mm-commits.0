Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF80F440A3E
	for <mm-commits@vger.kernel.org>; Fri, 25 Sep 2026 22:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790373856; cv=none; b=VoAmTdC3Ghe42x2fdlNcEjbCly2Z2uvhUWfmmUzw1nNV09v4Xi/p5GgqRCzgHwooCdMzoXOXM0xpxi3N3y7konvcq/9nS7yKpEqQNJeMaWHrVTrjl9K5jLNzAfvGWs3EN7jMe44ZtHGEwbU4SnGADIYrDnfQR0KT2ytBTvNjdZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790373856; c=relaxed/simple;
	bh=9Np+HJbFnHQ+2HlH6tPBJqUgytsVtc0wEzYnnITFiPo=;
	h=Date:To:From:Subject:Message-Id; b=sAR3FsCVjMo+gcFPEyiN91bu1Nxkm0v14acG0SIE5l0SZ639n7NZkRV0K1CQJLajJ+HMPAPCdGyd8Nfh7vhkjkLIKGcRCZsTIgTI8CAv4lWZvTOx785hM3VBYbAjj9HaJY5N6//DfjgKNCr9+GzgqKnhbCDWttUXNFsZElxZWXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vqCtw+m+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vqCtw+m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25B01F000FF;
	Fri, 25 Sep 2026 22:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790373854;
	bh=ZbqwNQp/QfkkwefwoPlhzt+vnLIzBoT3sds3LCobpWQ=;
	h=Date:To:From:Subject;
	b=vqCtw+m+3ehQqlKi0vufJCbxdgB/oeJqaLTWevwo1crO8LCqthqHwPrXd9+KaBL92
	 escLcevuwT+dkbvTabe9wuj35CsoSQESDvpT1JeIDkj3WvPjPSnX0jrTs8njivw6+V
	 E4lROE9MOkr0tVTz7IS0WiIPDuSSibnbW0UVXaNE=
Date: Fri, 25 Sep 2026 15:04:13 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jlayton@kernel.org,broonie@kernel.org,danishkhateeb03@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-filelock-plan-for-the-five-ofdlocks-tests.patch added to mm-nonmm-unstable branch
Message-Id: <20260925220413.E25B01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest/filelock: plan for the five ofdlocks tests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kselftest-filelock-plan-for-the-five-ofdlocks-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-filelock-plan-for-the-five-ofdlocks-tests.patch

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
From: Danish Khateeb <danishkhateeb03@gmail.com>
Subject: kselftest/filelock: plan for the five ofdlocks tests
Date: Fri, 25 Sep 2026 15:55:02 -0500

ofdlocks reports five results but plans for four, so even when they
all pass it ends with

  # Planned tests != run tests (4 != 5)

and exits with KSFT_FAIL, which run_kselftest.sh reports as a failure.

Link: https://lore.kernel.org/20260925205502.115327-1-danishkhateeb03@gmail.com
Fixes: 33d5b13098fb ("kselftest/filelock: report each test in oftlocks separately")
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
---

 tools/testing/selftests/filelock/ofdlocks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/filelock/ofdlocks.c~kselftest-filelock-plan-for-the-five-ofdlocks-tests
+++ a/tools/testing/selftests/filelock/ofdlocks.c
@@ -40,7 +40,7 @@ int main(void)
 	int fd2 = open("/tmp/aa", O_RDONLY);
 
 	ksft_print_header();
-	ksft_set_plan(4);
+	ksft_set_plan(5);
 
 	unlink("/tmp/aa");
 	assert(fd != -1);
_

Patches currently in -mm which might be from danishkhateeb03@gmail.com are

kselftest-filelock-plan-for-the-five-ofdlocks-tests.patch

