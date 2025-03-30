Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219891DE2C2
	for <mm-commits@vger.kernel.org>; Sun, 30 Mar 2025 21:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743370060; cv=none; b=XInNjt9XDbBKcvqZSwl97iEKkihxt98/6Ex/O6wGXLFvaCNOqDurqTUiwTSHcJ3xkjqIjiE6hWEzyv89K1ny1crKJkxpS4wsxqWZs9vZZQLmu0I5VNha935/8yW5yHRMFQpbHRsx2ljdCIPBy6LV/EAogB5mngtUm0RxyitLulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743370060; c=relaxed/simple;
	bh=RlBuFmqnlZBFYP7wvqXhNsysuIr0KEu8P79DmoVAd3U=;
	h=Date:To:From:Subject:Message-Id; b=q3ay1HQtFlUzGU6si/WrY8k9rryOJSkpCv+9nEhNArMnq6GZbJk21tUQeJB7tLY138jQVah/n9n54LevKG72mQZ+8+jeRB92VZ1Uyf7fSdJThbNtRIx1nr9CLfGfUxKwIvJf3729Nsxoi9Ag6Y+UwGWL/S1TfPmHVVZ1oZPgZek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tV7uFvSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tV7uFvSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85827C4CEDD;
	Sun, 30 Mar 2025 21:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743370059;
	bh=RlBuFmqnlZBFYP7wvqXhNsysuIr0KEu8P79DmoVAd3U=;
	h=Date:To:From:Subject:From;
	b=tV7uFvSwUCzHrgsxjdU/UsruGAGY3OAMyo6u8hsLFrs3B8cEQ6kFKUXUI+4ttLTxq
	 YZjat5Pxm/UxwjdQ8cbcNLwVR6FTJp2T4v4e8rWsnRZvrWdeEIn8b8YLDEUNlEDqio
	 6g7tpffIocKzyKuzq5Zx5IaR5YWJ7ZYJU3RtNPs4=
Date: Sun, 30 Mar 2025 14:27:38 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,acarmina@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-add-test-cases-for-backtrace-warning-suppression-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250330212739.85827C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: fix backtrace suppression test module description
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-add-test-cases-for-backtrace-warning-suppression-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-add-test-cases-for-backtrace-warning-suppression-fix.patch

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
From: Alessandro Carminati <acarmina@redhat.com>
Subject: kunit: fix backtrace suppression test module description
Date: Sat, 29 Mar 2025 15:05:29 +0000

Add module description to the backtrace suppression test.

Link: https://lkml.kernel.org/r/20250329150529.331215-1-acarmina@redhat.com
Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Acked-by: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kunit/backtrace-suppression-test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/kunit/backtrace-suppression-test.c~kunit-add-test-cases-for-backtrace-warning-suppression-fix
+++ a/lib/kunit/backtrace-suppression-test.c
@@ -102,3 +102,4 @@ static struct kunit_suite backtrace_supp
 kunit_test_suites(&backtrace_suppression_test_suite);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit test to verify warning backtrace suppression");
_

Patches currently in -mm which might be from acarmina@redhat.com are

kunit-add-test-cases-for-backtrace-warning-suppression-fix.patch

