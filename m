Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1718827
	for <mm-commits@vger.kernel.org>; Wed,  1 Jan 2025 23:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735774772; cv=none; b=EdbXpYb1LWdTUUN5q4TOr317Qaa9b/ritvGhtMHuB9uq79wEhp/ZB30C+dslfkCjrTEqWoM50I8bIvHLTAqJUGHahwVB/Up7uaWtbE5LGLRH4UEiRfEU+0pjDtBMxK04CPFFgFvr6rvHiiU1lYMBt+EokD/W3fxtDii3JjwqPDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735774772; c=relaxed/simple;
	bh=PpX/i3n7/vvKG/mDWm4YiH40I3Aufili5uGEiSyvxNs=;
	h=Date:To:From:Subject:Message-Id; b=cnYTsCPGzIQMm/pz0DQ1I8sKOKwPJ29yqyW8tZma00tucuFhzXtOX4MV4nmfqSPawW1EylYTnjmdsgTrnvY1xZZASEI5oeHcQgXvQJBaveHZeJjuU8WPYLDCDsi0XbWBFg6Th5pmGvpLDwA64uA9QHqre/v0vTBAnIQ84UP3Ou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bREy9Jgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bREy9Jgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59232C4CECE;
	Wed,  1 Jan 2025 23:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735774771;
	bh=PpX/i3n7/vvKG/mDWm4YiH40I3Aufili5uGEiSyvxNs=;
	h=Date:To:From:Subject:From;
	b=bREy9JgjMxgE5yHYB5lFR1uSgdPMddmpCazcj7U3OTg9hNSmZG3uJX7SVcfeQ6HlS
	 TPLTQNNTGNdUKHwFN/DIQqtgmkguVIhmH4wfAIDN35aUx//CkFYQZJIMHhQ/Xu1Ma4
	 I4DWJExZsCfR7Nb1RqVhrsamJQbiLoN/yFRMcdSA=
Date: Wed, 01 Jan 2025 15:39:30 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch added to mm-unstable branch
Message-Id: <20250101233931.59232C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/config: remove configs for DAMON debugfs interface selftests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/config: remove configs for DAMON debugfs interface selftests
Date: Wed, 1 Jan 2025 13:35:23 -0800

It's time to remove DAMON debugfs interface, which has deprecated long
before in February 2023.  Read the cover letter of this patch series for
more details.

Remove configs for selftests of it from DAMON selftests config file, to
prevent unnecessary noises from the tests.

[1] https://lore.kernel.org/20230209192009.7885-1-sj@kernel.org

Link: https://lkml.kernel.org/r/20250101213527.74203-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/config |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/damon/config~selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests
+++ a/tools/testing/selftests/damon/config
@@ -1,6 +1,5 @@
 CONFIG_DAMON=y
 CONFIG_DAMON_SYSFS=y
-CONFIG_DAMON_DBGFS=y
 CONFIG_DAMON_PADDR=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_RECLAIM=y
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch

