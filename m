Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D2319E992
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749510471; cv=none; b=KR61vDlE1Q5edek7NXItcJD/cgh8dDs06dwx/PlrDFou0rpJ4GSikrPbNL9jftrBpktSPY89A7uIHI7iemXtBJKoqNNumWzMibuR/rFPTFcjuhVf79Skyz503KcPm3bhfllYohQODziC+1i00eqV6Z2cdfpnSRo1jOJ7S0bp5LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749510471; c=relaxed/simple;
	bh=QdqiqSJ/jJH8FvBHQNthi9JH8C0Rx8XRyh2cbYTjQc4=;
	h=Date:To:From:Subject:Message-Id; b=qVUu0MCuLxWbCHezTpI0BYP76Cy340dHOMqwOxHZLL+rKTInpiRCm2uH3WOiMziJXLngidus+RV5x7gLjImq4dPUR9yYq4xmj1MEzlIC2CvJ/BdiWdh3G8wnsXc3Y+CYvp/jhkh1StYZAzHIbH9ACztHR5fUkv5Kf6suPxpvt4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AL8MVNaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AL8MVNaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9144C4CEEB;
	Mon,  9 Jun 2025 23:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749510471;
	bh=QdqiqSJ/jJH8FvBHQNthi9JH8C0Rx8XRyh2cbYTjQc4=;
	h=Date:To:From:Subject:From;
	b=AL8MVNaH0cSTZUwSUKPnD+LkqnvQGgKER8e45+MHVVwPDrPWfVq32BNLQ1FmFVqnP
	 T4UpzGZ09WrmeJYr7dUY57l3MZXhPdE35eZ6+V5Wpqfi9w9baQozb7e6WqWh4alQMc
	 2x7JyMtpdHKfRwdLTqXPsGWIewqWfSbwluQgdxbI=
Date: Mon, 09 Jun 2025 16:07:50 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-increase-timeout-from-180-to-900-seconds.patch added to mm-hotfixes-unstable branch
Message-Id: <20250609230750.E9144C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: increase timeout from 180 to 900 seconds
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-increase-timeout-from-180-to-900-seconds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-increase-timeout-from-180-to-900-seconds.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Shivank Garg <shivankg@amd.com>
Subject: selftests/mm: increase timeout from 180 to 900 seconds
Date: Mon, 9 Jun 2025 12:06:07 +0000

The mm selftests are timing out with the current 180-second limit.
Testing shows that run_vmtests.sh takes approximately 11 minutes
(664 seconds) to complete.

Increase the timeout to 900 seconds (15 minutes) to provide sufficient
buffer for the tests to complete successfully.

Link: https://lkml.kernel.org/r/20250609120606.73145-2-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/settings |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/settings~selftests-mm-increase-timeout-from-180-to-900-seconds
+++ a/tools/testing/selftests/mm/settings
@@ -1 +1 @@
-timeout=180
+timeout=900
_

Patches currently in -mm which might be from shivankg@amd.com are

selftests-mm-increase-timeout-from-180-to-900-seconds.patch

