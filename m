Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B944D284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126262; cv=none; b=ZYbGWAgGz2nJcSEvNq8qFExvanMDghVZ9wKku5oQq2qBVxanQPwvWkosoiUGBxIglQU1UsFNUuAa2+S3RPvyCdz31GsPjzlFO5eV9kqvByFPAZfChze8aKw5pq3cvj3ZFE2enf0tb61ySC8RqoTD2XWPx8N0a0Z7V2qEC4BTmEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126262; c=relaxed/simple;
	bh=m6B3Oijf0qZY1mqCTfRF3xN5d+PYFlskApeRdtGz1KQ=;
	h=Date:To:From:Subject:Message-Id; b=sIdDdWxsCAu902+dUJOYN2nvYBCKYECe0kbtRF6hQgCCYxyepq+4EJCE9xqm2jD1eb3k6P0dyL8EFExlAKGhBwumVG3OSCZVNlaDTbAOyw6Jq8IJN/eQaDHheI14xQ8pL58u59P4vv1cmmHy5Z8+6hmdHLDvcjh/bzmSi3olayQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f49xF2FT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f49xF2FT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAA6C4CEE3;
	Thu, 10 Jul 2025 05:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126262;
	bh=m6B3Oijf0qZY1mqCTfRF3xN5d+PYFlskApeRdtGz1KQ=;
	h=Date:To:From:Subject:From;
	b=f49xF2FT34Dzmq00oob6ywI5PD1i8m4CM3ajnQrV3kj/DVNo9v/nP14zJeeQT5Uzf
	 fNRMPhkk8HR2tZLMZABF3tRtnCJ+6exMKQ8cCCIK1IJr5OwQXMCcyhLuVb/Y7grXnv
	 Nys2pytdzWu0sMB36e9ldpf5Xw3Tz9f8oPWW4r3A=
Date: Wed, 09 Jul 2025 22:44:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch removed from -mm tree
Message-Id: <20250710054422.8CAA6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: convert some cow error reports to ksft_perror()
has been removed from the -mm tree.  Its filename was
     selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: convert some cow error reports to ksft_perror()
Date: Tue, 10 Jun 2025 15:13:55 +0100

This prints the errno and a string decode of it.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-2-43cd7457500f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-convert-some-cow-error-reports-to-ksft_perror
+++ a/tools/testing/selftests/mm/cow.c
@@ -332,7 +332,7 @@ static void do_test_vmsplice_in_parent(c
 	if (before_fork) {
 		transferred = vmsplice(fds[1], &iov, 1, 0);
 		if (transferred <= 0) {
-			ksft_print_msg("vmsplice() failed\n");
+			ksft_perror("vmsplice() failed\n");
 			log_test_result(KSFT_FAIL);
 			goto close_pipe;
 		}
@@ -562,7 +562,7 @@ static void do_test_iouring(char *mem, s
 	while (total < size) {
 		cur = pread(fd, tmp + total, size - total, total);
 		if (cur < 0) {
-			ksft_print_msg("pread() failed\n");
+			ksft_perror("pread() failed\n");
 			log_test_result(KSFT_FAIL);
 			goto quit_child;
 		}
@@ -628,7 +628,7 @@ static void do_test_ro_pin(char *mem, si
 
 	tmp = malloc(size);
 	if (!tmp) {
-		ksft_print_msg("malloc() failed\n");
+		ksft_perror("malloc() failed\n");
 		log_test_result(KSFT_FAIL);
 		return;
 	}
_

Patches currently in -mm which might be from broonie@kernel.org are


