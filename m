Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6608F3FE36C
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757204; cv=none; b=svXpgRtIAYL2WI0jUMlzh57KQUCh1RzX/IyHDE0htWSMNOD1ciuBkIciiwqzw853mCKcDo3v15jTQH680NpnlHQwP5kA8E3aI46pqsmuFxH1gY6U7+Xprku/haPXNYPprIoJIglTSPdhSWA1rs2KvgWoaBOBIOnR0prVX9zhj28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757204; c=relaxed/simple;
	bh=9KWNk8GdHakksdrJdCDbCJL80WXK+Dbg4Ugt2vcSuc4=;
	h=Date:To:From:Subject:Message-Id; b=P7KJFFLOHH/ZF9bFbTun4bFH23oznDulflAXgQNM60ClFi2wLcGxfWextmdhdxXnW8EGSAbG2wkKHWnhVpFplvn3Fqm8EOojx2n8SEUkJm5za/C8RDiTDg8B8KgsbK7xSc65+dA0A/nW1g9OJRbIV7m88lOyJRBl7xB5D/hMHOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iAiteKyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iAiteKyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2693A1F0089C;
	Sun, 11 Oct 2026 22:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757203;
	bh=Ympk6zIWufeCKJeQI8hah/rhIUXMzcaPH2AkTpf1ZbA=;
	h=Date:To:From:Subject;
	b=iAiteKyJxdCg/+mwbXnDig3jzWMYOeMf4H8uxVDD6kZ+cCWjy81lb5s9ClFaEsdjQ
	 d/X9WbqbtjUzsriIqqXeCWOWFUBIOzrDX8cYk24+JtIBDN1IOpACjpjn4tm276J48z
	 RO86pHtydig7qrdJm8jv1CnJ8k6bo1bO3MB8jWcs=
Date: Sun, 11 Oct 2026 15:20:02 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jlayton@kernel.org,broonie@kernel.org,danishkhateeb03@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kselftest-filelock-plan-for-the-five-ofdlocks-tests.patch removed from -mm tree
Message-Id: <20261011222003.2693A1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest/filelock: plan for the five ofdlocks tests
has been removed from the -mm tree.  Its filename was
     kselftest-filelock-plan-for-the-five-ofdlocks-tests.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


