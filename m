Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6F3EC4
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183062; cv=none; b=TXDqV+NCFhwauWQHvVhyJIIadGJGjCbh6MeiLAwcAsuVuV6aMzoLSEaDvdw1Jujo/p6i6GAwzfWVCq/muQy6h5WqxQ8PBfs5welc+zDf6maY4y4hKDpmkbZrJ5+ooHaJKe8MTPZgdssjT9wycYYQ8dPSyAhiuRFZZ1snH2MJ3o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183062; c=relaxed/simple;
	bh=fw36GWpb+myh8uRpke95iB9qcaejt2gTdW2fZ3zWol0=;
	h=Date:To:From:Subject:Message-Id; b=PxQGUxK/xm9bSzpGfvETTFu5XK/1vZOIIWQC4obw1GTz+99IXFMJvC2SQfucOcJsmI9bTJpVEXzo9orjAJoml2rSZ72Ww9fzNUxyY8jHkYD2yx14t79SqY6NVbBPzOFe2lO69YEYVbRS0TFbUYQNj4B2VUZcal5uaPYaTnJwdsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IMPXR/Zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IMPXR/Zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DABAC4CED6;
	Sat, 22 Feb 2025 00:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183062;
	bh=fw36GWpb+myh8uRpke95iB9qcaejt2gTdW2fZ3zWol0=;
	h=Date:To:From:Subject:From;
	b=IMPXR/ZfZT/WloXY2PHEGKVJlH5XIHgdSLn2azoVrvxjxVIOvxmTINxMCj8AykiIR
	 UOiTaoMt7EH2pRVHCDJfD/g47j5xSjYwu7S+emhfuFGHhkuVN2fDvZODhQpHO+h3nk
	 aBqJtfHJqc+Q/nQ2HaQKShga/tZAbuzOx4eyyA+0=
Date: Fri, 21 Feb 2025 16:11:01 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-assumption-that-sudo-is-present.patch added to mm-unstable branch
Message-Id: <20250222001102.7DABAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix assumption that sudo is present
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-assumption-that-sudo-is-present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-assumption-that-sudo-is-present.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: fix assumption that sudo is present
Date: Fri, 21 Feb 2025 18:25:41 +0000

If we are root, sudo isn't needed.  If we are not root, we need sudo, so
skip the test if it isn't present.

We already do this for on-fault-limit, but this uses separate
infrastructure since that is specifically for sudo-ing to the nobody user.

Note this ptrace_skip configuration still fails if that file doesn't
exist, but in that case the test is still fine, so this just prints an
error but doesn't break anything.  I suspect that's probably deliberate.

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-2-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   22 ++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-fix-assumption-that-sudo-is-present
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -89,6 +89,17 @@ RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
+# We can do stuff as root either if we are already root, or if sudo exists.
+if [ "$(id -u)" == 0 ]; then
+	HAVE_SUDO_ROOT=true
+	SUDO_ROOT=
+elif command -v sudo >/dev/null 2>&1; then
+	HAVE_SUDO_ROOT=true
+	SUDO_ROOT=sudo
+else
+	HAVE_SUDO_ROOT=false
+fi
+
 while getopts "aht:n" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
@@ -398,10 +409,13 @@ CATEGORY="madv_guard" run_test ./guard-p
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
-if [ -x ./memfd_secret ]
-then
-(echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
-CATEGORY="memfd_secret" run_test ./memfd_secret
+if [ -x ./memfd_secret ]; then
+	if $HAVE_SUDO_ROOT; then
+		(echo 0 | $SUDO_ROOT tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+		CATEGORY="memfd_secret" run_test ./memfd_secret
+	else
+		echo "# SKIP ./memfd_secret"
+	fi
 fi
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

