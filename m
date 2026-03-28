Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBF922B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671901; cv=none; b=s9uzFPgGzNQrx3VDzong99hso9PEaxY5JGFnCW/8/a0T+7Ek9MU6hoin3FSaerHB+bx50AHpJ21EoQPjtgMMdV3ocGsA9j1VqwP4BMTEfvo83PyFumL0yz3QFLMe4Bo8ZeODTQPEIs8VrmyRxCMkrFm+fuhRsH5UqEjd2tre1Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671901; c=relaxed/simple;
	bh=2b+KM+groGHR5QrnYDBwO4fdXeWdiRoS8GmQK+R8R8Y=;
	h=Date:To:From:Subject:Message-Id; b=WzKXJu4udhGaFjQaEVeQhhelhpxK1Wspu8/PBdzGOPRbXY7OnxCmsp/W+Y1rtebR+3eb7ddu2vN13iX1D9AsBLGA4xLEljqPpa6AUutCgJ8JL7wfqKHHpsXYUgoc9E8iG8tIIzFO7Wd4X/DaDu83kx+qUT5GnexvQUOtKfQ28BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZvsluYFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZvsluYFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13078C4CEF7;
	Sat, 28 Mar 2026 04:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671901;
	bh=2b+KM+groGHR5QrnYDBwO4fdXeWdiRoS8GmQK+R8R8Y=;
	h=Date:To:From:Subject:From;
	b=ZvsluYFrPcSKkmCohI95ZuKRKpx/4wqzZuWotBhjsku66w4nkKopp6cwkNi/mzYg0
	 AzU4Ggc8gEpZPPZ6h9LM3aYXI0QQZJazIP1TxkSdsHnND9bFHxh8cybNVnsQXIUOdY
	 H/ZXT6hiJupE/aCNP6Y6usCLC8qB/nvGBwPyW6KU=
Date: Fri, 27 Mar 2026 21:25:00 -0700
To: mm-commits@vger.kernel.org,legion@kernel.org,brauner@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-fchmodat2-use-ksft_finished.patch removed from -mm tree
Message-Id: <20260328042501.13078C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/fchmodat2: use ksft_finished()
has been removed from the -mm tree.  Its filename was
     selftests-fchmodat2-use-ksft_finished.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/fchmodat2: use ksft_finished()
Date: Thu, 26 Feb 2026 22:24:43 +0000

The fchmodat2 test program open codes a version of ksft_finished(), use
the standard version.

Link: https://lkml.kernel.org/r/20260226-selftests-fchmodat2-v4-2-a6419435f2e8@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/fchmodat2/fchmodat2_test.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/tools/testing/selftests/fchmodat2/fchmodat2_test.c~selftests-fchmodat2-use-ksft_finished
+++ a/tools/testing/selftests/fchmodat2/fchmodat2_test.c
@@ -196,8 +196,5 @@ int main(int argc, char **argv)
 	test_regfile();
 	test_symlink();
 
-	if (ksft_get_fail_cnt() + ksft_get_error_cnt() > 0)
-		ksft_exit_fail();
-	else
-		ksft_exit_pass();
+	ksft_finished();
 }
_

Patches currently in -mm which might be from broonie@kernel.org are


