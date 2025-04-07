Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE9317BA3
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987947; cv=none; b=W6hwrRnzyq3m8qQbTyGmo4/I/kNIpr+gf3ckMGSQZYBIvsVXCTrVNkDL6a9WP2Yp5yDs0Dmnrop/2CFvBi8vETENkK7bxBV8fVRs2u9guC9oYdsxLpzj/PsaCXx3eJENH5YYx3pN33VywKibq7dGs60+Dk/nm+SA9WVp8z83ytw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987947; c=relaxed/simple;
	bh=QdFmt6IixuZICWYyyY9nrbMze0FQ3RQjh0LDqTtO3CE=;
	h=Date:To:From:Subject:Message-Id; b=YHNGPzvn5TGZawNsk2UjGaqsjgZx15KZP5Y7MKdk34ei9UDqOFuxNTSNxn1tELCf4BA0z2tJ1tgBU9Fh7lzW7H3/NiOR4qpIqcB6A/nhKrxw3WjOpIUW27olPYwzCaYyrF2c0OS+VyendGh5JkGETxMqDl07hQNJW/SdA4GTGMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e0DAQkaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e0DAQkaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6C5C4CEE3;
	Mon,  7 Apr 2025 01:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987946;
	bh=QdFmt6IixuZICWYyyY9nrbMze0FQ3RQjh0LDqTtO3CE=;
	h=Date:To:From:Subject:From;
	b=e0DAQkaTZio6REquPKBfgVtwjhBIdbwhYcMtfdCx0rtIQSoQhbkgYsElqybF14If6
	 6f0ihOxqGEfi/KQNCoG/GgmLGkDT+nYToVozd/bvU88lf8tt+8PGzf07Vjx6HGOliq
	 5T4u/ByyNMQvd1Hta8Qqic1QmExroYFHRug1i3bE=
Date: Sun, 06 Apr 2025 18:05:46 -0700
To: mm-commits@vger.kernel.org,viresh.kumar@linaro.org,lukas.bulwahn@gmail.com,louis.chauvet@bootlin.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powernow-use-pr_info_once.patch added to mm-nonmm-unstable branch
Message-Id: <20250407010546.9D6C5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powernow: use pr_info_once
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powernow-use-pr_info_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powernow-use-pr_info_once.patch

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
From: Jim Cromie <jim.cromie@gmail.com>
Subject: powernow: use pr_info_once
Date: Tue, 25 Mar 2025 17:51:56 -0600

This reduces log-msgs during boot from many pages to ~10 occurrences.  I
didn't investigate why it wasn't just 1, maybe its a low-level service to
other modules, re-probed by each of them ?

Link: https://lkml.kernel.org/r/20250325235156.663269-4-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Louis Chauvet <louis.chauvet@bootlin.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/powernow-k8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/powernow-k8.c~powernow-use-pr_info_once
+++ a/drivers/cpufreq/powernow-k8.c
@@ -482,7 +482,7 @@ static void check_supported_cpu(void *_r
 		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
 		if ((edx & P_STATE_TRANSITION_CAPABLE)
 			!= P_STATE_TRANSITION_CAPABLE) {
-			pr_info("Power state transitions not supported\n");
+			pr_info_once("Power state transitions not supported\n");
 			return;
 		}
 		*rc = 0;
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

checkpatch-dont-warn-about-unused-macro-arg-on-empty-body.patch
checkpatch-qualify-do-while-0-advice.patch
powernow-use-pr_info_once.patch

