Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655DD28FAB7
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752184521; cv=none; b=nZMmkfgj3mu+nesOnI9exKG2L1rMrzqXht7xUYHFc+Vgb/EDJu8+q/3UzgMtSUw9ieduZ0+7cHQwXCiW7lb+OEko54R4v6FUw1Ug5WWw78V3TyEiHRvhetFSybNtA7CBeJrWAG8JQL05t34PXK4+CCAuE8LdSbDKFQs1zFyJGIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752184521; c=relaxed/simple;
	bh=aE80nrDdOkHIZkHHhtEmtHELY4xhg5mBOZ1v2YWCtwE=;
	h=Date:To:From:Subject:Message-Id; b=mgFKE7mIQ6mKQKSNSeExoKtyHMJ1HAQl6xq60HZDvGBdyoNZvNIowlFiOmxTcdq+4FxGnN0h5keAkoi4Oa+C3R37618en5L9348PTNpuU7jyBw3espOFBUT7zLUMuEIC15hRL9UbIpy7GZr21wn1EXmjU0b2JP+Q0/zKbFwAz1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J2xILIEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J2xILIEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C623BC4CEE3;
	Thu, 10 Jul 2025 21:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752184520;
	bh=aE80nrDdOkHIZkHHhtEmtHELY4xhg5mBOZ1v2YWCtwE=;
	h=Date:To:From:Subject:From;
	b=J2xILIEfEcJmRS2uTgqc2Cc+9AWEK6vKohUR3HXpGoxrHAgGzU1xO3U4+NGElA4TE
	 T4bZb2uLJszc3xgsNGhyd2hbBi4oAqod4yMmQU58DEjSM4Zt/y0PHGvgV4L6s3fHKB
	 UHuOIu9jugJSjZiX0FJAA7/8CbcgmdzN0Du88FqQ=
Date: Thu, 10 Jul 2025 14:55:20 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,guanwentao@uniontech.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-thermal-remove-duplicate-newlines-in-perror-calls.patch added to mm-nonmm-unstable branch
Message-Id: <20250710215520.C623BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/thermal: remove duplicate newlines in perror calls
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-thermal-remove-duplicate-newlines-in-perror-calls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-thermal-remove-duplicate-newlines-in-perror-calls.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: selftests/thermal: remove duplicate newlines in perror calls
Date: Thu, 10 Jul 2025 21:47:51 +0800

perror() automatically appends a newline character, so the explicit '\n'
in the format strings is redundant and results in duplicate newlines in
the output.

Remove the redundant '\n' characters from perror() calls in
workload_hint_test.c to fix the formatting.

Link: https://lkml.kernel.org/r/F482FB1EC020000C+20250710134751.306096-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Guan Wentao <guanwentao@uniontech.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c |   14 +++++-----
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c~selftests-thermal-remove-duplicate-newlines-in-perror-calls
+++ a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
@@ -32,12 +32,12 @@ void workload_hint_exit(int signum)
 
 	fd = open(WORKLOAD_ENABLE_ATTRIBUTE, O_RDWR);
 	if (fd < 0) {
-		perror("Unable to open workload type feature enable file\n");
+		perror("Unable to open workload type feature enable file");
 		exit(1);
 	}
 
 	if (write(fd, "0\n", 2) < 0) {
-		perror("Can't disable workload hints\n");
+		perror("Can't disable workload hints");
 		exit(1);
 	}
 
@@ -70,12 +70,12 @@ int main(int argc, char **argv)
 		sprintf(delay_str, "%s\n", argv[1]);
 		fd = open(WORKLOAD_NOTIFICATION_DELAY_ATTRIBUTE, O_RDWR);
 		if (fd < 0) {
-			perror("Unable to open workload notification delay\n");
+			perror("Unable to open workload notification delay");
 			exit(1);
 		}
 
 		if (write(fd, delay_str, strlen(delay_str)) < 0) {
-			perror("Can't set delay\n");
+			perror("Can't set delay");
 			exit(1);
 		}
 
@@ -92,12 +92,12 @@ int main(int argc, char **argv)
 	/* Enable feature via sysfs knob */
 	fd = open(WORKLOAD_ENABLE_ATTRIBUTE, O_RDWR);
 	if (fd < 0) {
-		perror("Unable to open workload type feature enable file\n");
+		perror("Unable to open workload type feature enable file");
 		exit(1);
 	}
 
 	if (write(fd, "1\n", 2) < 0) {
-		perror("Can't enable workload hints\n");
+		perror("Can't enable workload hints");
 		exit(1);
 	}
 
@@ -108,7 +108,7 @@ int main(int argc, char **argv)
 	while (1) {
 		fd = open(WORKLOAD_TYPE_INDEX_ATTRIBUTE, O_RDONLY);
 		if (fd < 0) {
-			perror("Unable to open workload type file\n");
+			perror("Unable to open workload type file");
 			exit(1);
 		}
 
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test.patch
selftests-thermal-remove-duplicate-newlines-in-perror-calls.patch

