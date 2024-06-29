Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26F518C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628622; cv=none; b=TxAFE5sRrmmGNdcTgbHHQ0g8PM5fR/E8bLpelavC/jTUCD9lToyTPeEa8+rSIlw/cQgjQRbTKkqfDZhhls/3PPOv0gpZ7p4QQHo1tiTZ0YTwuhEoGRYeAIzUFwVD9MU1gwsyIEtYDmQ0zyNqbuTWOxZpOy0Eks5ScaimA1AkKi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628622; c=relaxed/simple;
	bh=VJ4A1GdM2XBfzjRkVeYc+mNCewQ6tw/ZZbb8Ayk/dc8=;
	h=Date:To:From:Subject:Message-Id; b=CoIhELsyUxOyYvR/pZB0+J5RB+T2Ny2hWoCVqAjm56MDDtV/wMqB+A1BfwYPAwF+RvqcP/iGLbsSkpXC4EWJJtjKjpZy9scgOXPPhi/YiFKh4ez3R8BRV1etWEjac9UpQsYr+6L/GWz6QysmftZSny7KfdstYnZZUiGCArWYXLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0lN8EiSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0lN8EiSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CACCC116B1;
	Sat, 29 Jun 2024 02:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628622;
	bh=VJ4A1GdM2XBfzjRkVeYc+mNCewQ6tw/ZZbb8Ayk/dc8=;
	h=Date:To:From:Subject:From;
	b=0lN8EiSYWB60Q3FLXjtpzxEXWPCKZiRyyjF3wkRwGsOo9ctCdPwwryz8tnemVnisP
	 YYDHWT1qoB/uI6YT3Y1BR+mYmF5vzBk5tAkh5JTPpgKGg1+5egNMjLle7zIOdMWWbt
	 4SWbPwSz17Ln68OQhJ7+w6WKLR/FPRzQT+c5r74s=
Date: Fri, 28 Jun 2024 19:37:01 -0700
To: mm-commits@vger.kernel.org,swarupkotikalapudi@gmail.com,shuah@kernel.org,lkp@intel.com,javier.carrasco.cruz@gmail.com,hughd@google.com,adobriyan@gmail.com,amer.shanawany@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-proc-remove-unreached-code-and-fix-build-warning.patch removed from -mm tree
Message-Id: <20240629023702.5CACCC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: proc: remove unreached code and fix build warning
has been removed from the -mm tree.  Its filename was
     selftests-proc-remove-unreached-code-and-fix-build-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Amer Al Shanawany <amer.shanawany@gmail.com>
Subject: selftests: proc: remove unreached code and fix build warning
Date: Mon, 3 Jun 2024 14:42:20 +0200

fix the following warning:
proc-empty-vm.c:385:17: warning: ignoring return value of `write'
 declared with attribute `warn_unused_result' [-Wunused-result]
  385 |                 write(1, buf, rv);
      |                 ^~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20240603124220.33778-1-amer.shanawany@gmail.com
Signed-off-by: Amer Al Shanawany <amer.shanawany@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202404010211.ygidvMwa-lkp@intel.com/
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~selftests-proc-remove-unreached-code-and-fix-build-warning
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -381,9 +381,6 @@ static int test_proc_pid_statm(pid_t pid
 
 	assert(rv >= 0);
 	assert(rv <= sizeof(buf));
-	if (0) {
-		write(1, buf, rv);
-	}
 
 	const char *p = buf;
 	const char *const end = p + rv;
_

Patches currently in -mm which might be from amer.shanawany@gmail.com are


