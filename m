Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0156515E96
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724808455; cv=none; b=p/FX2SblqJdve+7GZe/L+qDJZ75K3AIG1IgsSoOa0B7/yfWvu7YaNmmztKIEcrPUdSe05/TQ7540DZEAZ7nQZidcWPhEcE6TXYYRthVtUXv4gb6/3eaeNwfY+DfME6AW3cQ5yiqd2sMrCFPkeWu6kO/5dkPV+y85PFPdwA/+8yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724808455; c=relaxed/simple;
	bh=pQ6G+iULG8FJnVfdK+h9BkYipaFYnBDQPF9RbcXwcZQ=;
	h=Date:To:From:Subject:Message-Id; b=lUGg/o15Iyfi+9mj2FAQyfmsEccMPj0Y6B8PuD/Gw5COMXsOOrf6+rz/nV02wXrnFINpyUDRx+lLF0rwcyCWsvA5mz1IwiZ9CEX8tJrPnG+8AzyyXSqDyC2USnKJICvobL+Z4llvXM0ReyS3sRZmn3N8XmCEHpnHLIR7Cr69E30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=URVLRPQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="URVLRPQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F5EC32782;
	Wed, 28 Aug 2024 01:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724808454;
	bh=pQ6G+iULG8FJnVfdK+h9BkYipaFYnBDQPF9RbcXwcZQ=;
	h=Date:To:From:Subject:From;
	b=URVLRPQtscaA447p63k80hZIW6ZqhQjoQAEEs/5SwxG7CD6OwmekhB0NIlGy6By33
	 Ol0/BGzE6Ax8Pgn07KX2a1Ych2npdJq4uS1lhMhkIEQY0Ren3d2/5ipEVgCspomBRC
	 LDX2MYgrgZ6dvyupRwSSWtD/gRh/XwmuKzLIIrfY=
Date: Tue, 27 Aug 2024 18:27:33 -0700
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-damon-maintainer-profile-add-links-in-place.patch added to mm-unstable branch
Message-Id: <20240828012734.64F5EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/damon/maintainer-profile: add links in place
has been added to the -mm mm-unstable branch.  Its filename is
     docs-damon-maintainer-profile-add-links-in-place.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-damon-maintainer-profile-add-links-in-place.patch

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
Subject: Docs/damon/maintainer-profile: add links in place
Date: Sun, 25 Aug 2024 18:57:40 -0700

maintainer-profile.rst for DAMON separates the links and target
definitions.  It is not really necessary, and only makes the readability
worse.  At least the definitions need the section title (say,
"References").  Just add the links in place on the doc.

Link: https://lkml.kernel.org/r/20240826015741.80707-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   82 ++++++++--------
 1 file changed, 43 insertions(+), 39 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-damon-maintainer-profile-add-links-in-place
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -7,23 +7,27 @@ The DAMON subsystem covers the files tha
 section of 'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
-linux-mm@kvack.org.  Patches should be made against the mm-unstable tree [1]_
-whenever possible and posted to the mailing lists.
+linux-mm@kvack.org.  Patches should be made against the mm-unstable `tree
+<https://git.kernel.org/akpm/mm/h/mm-unstable>` whenever possible and posted to
+the mailing lists.
 
 SCM Trees
 ---------
 
 There are multiple Linux trees for DAMON development.  Patches under
-development or testing are queued in damon/next [2]_ by the DAMON maintainer.
-Sufficiently reviewed patches will be queued in mm-unstable [1]_ by the memory
-management subsystem maintainer.  After more sufficient tests, the patches will
-be queued in mm-stable [3]_ , and finally pull-requested to the mainline by the
-memory management subsystem maintainer.
+development or testing are queued in `damon/next
+<https://git.kernel.org/sj/h/damon/next>` by the DAMON maintainer.
+Sufficiently reviewed patches will be queued in `mm-unstable
+<https://git.kernel.org/akpm/mm/h/mm-unstable>` by the memory management
+subsystem maintainer.  After more sufficient tests, the patches will be queued
+in `mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>` , and finally
+pull-requested to the mainline by the memory management subsystem maintainer.
 
-Note again the patches for mm-unstable tree [1]_ are queued by the memory
+Note again the patches for mm-unstable `tree
+<https://git.kernel.org/akpm/mm/h/mm-unstable>` are queued by the memory
 management subsystem maintainer.  If the patches requires some patches in
-damon/next tree [2]_ which not yet merged in mm-unstable, please make sure the
-requirement is clearly specified.
+damon/next `tree <https://git.kernel.org/sj/h/damon/next>` which not yet merged
+in mm-unstable, please make sure the requirement is clearly specified.
 
 Submit checklist addendum
 -------------------------
@@ -32,18 +36,27 @@ When making DAMON changes, you should do
 
 - Build changes related outputs including kernel and documents.
 - Ensure the builds introduce no new errors or warnings.
-- Run and ensure no new failures for DAMON selftests [4]_ and kunittests [5]_ .
+- Run and ensure no new failures for DAMON `selftests
+  <https://github.com/awslabs/damon-tests/blob/master/corr/run.sh#L49>` and
+  `kunittests
+  <https://github.com/awslabs/damon-tests/blob/master/corr/tests/kunit.sh>`.
 
 Further doing below and putting the results will be helpful.
 
-- Run damon-tests/corr [6]_ for normal changes.
-- Run damon-tests/perf [7]_ for performance changes.
+- Run `damon-tests/corr
+  <https://github.com/awslabs/damon-tests/tree/master/corr>` for normal
+  changes.
+- Run `damon-tests/perf
+  <https://github.com/awslabs/damon-tests/tree/master/perf>` for performance
+  changes.
 
 Key cycle dates
 ---------------
 
-Patches can be sent anytime.  Key cycle dates of the mm-unstable [1]_ and
-mm-stable [3]_ trees depend on the memory management subsystem maintainer.
+Patches can be sent anytime.  Key cycle dates of the `mm-unstable
+<https://git.kernel.org/akpm/mm/h/mm-unstable>` and `mm-stable
+<https://git.kernel.org/akpm/mm/h/mm-stable>` trees depend on the memory
+management subsystem maintainer.
 
 Review cadence
 --------------
@@ -58,16 +71,17 @@ Mailing tool
 
 Like many other Linux kernel subsystems, DAMON uses the mailing lists
 (damon@lists.linux.dev and linux-mm@kvack.org) as the major communication
-channel.  There is a simple tool called HacKerMaiL (``hkml``) [8]_ , which is
-for people who are not very familiar with the mailing lists based
-communication.  The tool could be particularly helpful for DAMON community
-members since it is developed and maintained by DAMON maintainer.  The tool is
-also officially announced to support DAMON and general Linux kernel development
-workflow.
-
-In other words, ``hkml`` [8]_ is a mailing tool for DAMON community, which
-DAMON maintainer is committed to support.  Please feel free to try and report
-issues or feature requests for the tool to the maintainer.
+channel.  There is a simple tool called `HacKerMaiL
+<https://github.com/damonitor/hackermail>` (``hkml``), which is for people who
+are not very familiar with the mailing lists based communication.  The tool
+could be particularly helpful for DAMON community members since it is developed
+and maintained by DAMON maintainer.  The tool is also officially announced to
+support DAMON and general Linux kernel development workflow.
+
+In other words, `hkml <https://github.com/damonitor/hackermail>` is a mailing
+tool for DAMON community, which DAMON maintainer is committed to support.
+Please feel free to try and report issues or feature requests for the tool to
+the maintainer.
 
 Community meetup
 ----------------
@@ -83,17 +97,7 @@ members including the maintainer.  The m
 slots, and attendees should reserve one of those at least 24 hours before the
 time slot, by reaching out to the maintainer.
 
-Schedules and available reservation time slots are available at the Google doc
-[9]_ .  DAMON maintainer will also provide periodic reminder to the mailing
-list (damon@lists.linux.dev).
-
-
-.. [1] https://git.kernel.org/akpm/mm/h/mm-unstable
-.. [2] https://git.kernel.org/sj/h/damon/next
-.. [3] https://git.kernel.org/akpm/mm/h/mm-stable
-.. [4] https://github.com/damonitor/damon-tests/blob/master/corr/run.sh#L49
-.. [5] https://github.com/damonitor/damon-tests/blob/master/corr/tests/kunit.sh
-.. [6] https://github.com/damonitor/damon-tests/tree/master/corr
-.. [7] https://github.com/damonitor/damon-tests/tree/master/perf
-.. [8] https://github.com/damonitor/hackermail
-.. [9] https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing
+Schedules and available reservation time slots are available at the Google `doc
+<https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`.
+DAMON maintainer will also provide periodic reminder to the mailing list
+(damon@lists.linux.dev).
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch
mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

