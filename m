Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8324B28DF27
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752184519; cv=none; b=ZEClX0MXm+LSv81+AUZQSyESLV1cOSR07f0GgpFmNdWA21yvdSAB5kPyyWVC4o0T8f5lmx6eKlSnsxw/mwPhSxCTodxNYLUhHNt2F5xKzijnDqIEFa3+JW+0uQaGC0Mgqy3xODKOh25kKuZvFsne4ZnWINt5TO7MbRcDwLbT1DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752184519; c=relaxed/simple;
	bh=lxhCffRCiTtvT/Dm5Z5G3AXO3RS/yDYQ6RecZY0L+Vg=;
	h=Date:To:From:Subject:Message-Id; b=c7OWv+AjW5N4n2wsL5AtkQsti/sPMbbSSuzTnOP1mYOpIb5Lx9KUxcuFaS68HBWEiev3ZcrRF/81xQO6MVdy5iCaS0ie5m0T6dR8/krt9aPBDvTq6Yt8QBhtVfrM6EnCzTdS8rZbXFi2amKLJzvPbTa8WQ1BBC79HFdVwSG/qIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UK7UTY2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UK7UTY2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB034C4CEE3;
	Thu, 10 Jul 2025 21:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752184519;
	bh=lxhCffRCiTtvT/Dm5Z5G3AXO3RS/yDYQ6RecZY0L+Vg=;
	h=Date:To:From:Subject:From;
	b=UK7UTY2k5IRBYgO2xX/+86MoSYt3r6KgX6MfbmRJR/rObOY3kAZ2KZ467rDBBcfzi
	 0PdM4572WbaA+4Xrl16skNSzenHkN0QHY/ELtKuSfOIPoW0avTBaj++1Cq9Lahr5W+
	 cSm8C3u6e32JdOFXUGBA3rf3UXxCj/71lX54w5AQ=
Date: Thu, 10 Jul 2025 14:55:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,guanwentao@uniontech.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test.patch added to mm-nonmm-unstable branch
Message-Id: <20250710215518.DB034C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/thermal: remove duplicate sprintf() call in workload_hint_test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test.patch

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
Subject: selftests/thermal: remove duplicate sprintf() call in workload_hint_test
Date: Thu, 10 Jul 2025 21:04:12 +0800

Remove redundant sprintf() call that was duplicating the same operation of
formatting delay_str with argv[1].

Link: https://lkml.kernel.org/r/6338CD0E839B770B+20250710130412.284531-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Guan Wentao <guanwentao@uniontech.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c~selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test
+++ a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
@@ -68,8 +68,6 @@ int main(int argc, char **argv)
 			exit(1);
 
 		sprintf(delay_str, "%s\n", argv[1]);
-
-		sprintf(delay_str, "%s\n", argv[1]);
 		fd = open(WORKLOAD_NOTIFICATION_DELAY_ATTRIBUTE, O_RDWR);
 		if (fd < 0) {
 			perror("Unable to open workload notification delay\n");
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test.patch
selftests-thermal-remove-duplicate-newlines-in-perror-calls.patch

