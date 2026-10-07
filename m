Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680004E020A
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 19:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401432; cv=none; b=gbMsYly80gHn2e0eD+TCFUJddZY1DEviaJMxRmiCLP9PkltYLYbqXCvAX0jlVN3QXGmsat39INqpws5MFgCNLXXJvV121+eGC2RFYL8Q4AVGuAXu4kbQ+BYp5PSOMGfhMenI/cje9cs+NroJFJfAjiBYD7Pon38HiBHRScyJsEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401432; c=relaxed/simple;
	bh=7fu2oL6SltB0G5oK2pPvBYRxwfcWbV84xnM0IFJdZSQ=;
	h=Date:To:From:Subject:Message-Id; b=eXETHbC/kGByGsGWzvaC2uE0bRSPfx+FnplOj6R20w4iuZAY2WT+ynK2kz1lP8hDNxsaDwIU+8wwJ2BEmTotn8IfFaf3W3uZjqg2sE3utXIRHokANbc7FQ7ctjlLWrMrCHK21hcERv3EKj4fdY+2WfYZGZT0bIjB4oq1ZIBwt0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dIDMxFWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dIDMxFWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166EE1F000FF;
	Wed,  7 Oct 2026 19:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791401431;
	bh=p8KSrxn3Ze+X6XHPh0mgTYu9sI5aCjXNk69dCzuETHs=;
	h=Date:To:From:Subject;
	b=dIDMxFWQllqXgNfBSvC3UZRcU7AFe7auXstRzk5o777upwrypNiOvsQ3yFD0u3TAX
	 v///zn0cSsRCwEj9PytmAnca3oM+ojZiMJljf8dp+NxYM5FLMltebxXEL8hTpHLTZS
	 hNceQsKeZnf62wt+o2iOnklzqfcYt0I8ftwPoedM=
Date: Wed, 07 Oct 2026 12:30:30 -0700
To: mm-commits@vger.kernel.org,wad@chromium.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rbm@suse.com,mhocko@suse.com,luto@amacapital.net,ljs@kernel.org,liuhangbin@gmail.com,liam@infradead.org,kees@kernel.org,geert@linux-m68k.org,david@kernel.org,daniel@thingy.jp,corbet@lwn.net,broonie@kernel.org,brendan.jackman@linux.dev,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-run-tests-on-nommu-architecture.patch added to mm-unstable branch
Message-Id: <20261007193031.166EE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: run tests on nommu architecture
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-run-tests-on-nommu-architecture.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-run-tests-on-nommu-architecture.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hajime Tazaki <thehajime@gmail.com>
Subject: selftests: run tests on nommu architecture
Date: Tue,  6 Oct 2026 17:56:41 +0900

Patch series "support kselftest on nommu platform", v5.

This patchset adds an ability to execute kselftest on nommu platforms.

Currently there are several issues if we wish to run kselftests on nommu
targets:

- it cannot compile/build test binaries because the current files mainly
  assume to build with glibc,
- some of the tests are not able to run on nommu targets as there are no
  fork(2) syscall.

The first issue can be avoided if we can build static PIE binaries (if
targets support it), but in our case (build on ubuntu/glibc and run on
alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
mechanism.  Thus, we need to cross-compile with musl toolchain, which
needs to be solved the first issue.

The second issue is the lack of fork(2) syscall on those platforms.
Especially the test harness helper (kselftest_harness.h) uses the
syscall, which cannot be simply with vfork(2).  `timeout` command used
in `runner.sh` never works for nommu platform as it uses fork(2).

nommu component in the mm subsystem has several known issues and having
test cases should help this situation, thus this patchset is very first
step toward enriching test environment which has not been well tested
for a while.  The test cases is implemented based on the document
(Documentation/admin-guide/mm/nommu-mmap.rst).

Initial shape for this patches is implemented as an opt-in TARGET, not
built/invoked automatically if users don't specify this nommu target.


This patch (of 2):

Architectures lacking MMU don't support fork(2) syscall and only vfork(2)
is available with limitations.  Thus, we cannot run kselftest on nommu
architecture as is.

This commit addresses this issue with the following changes:

- Detect NOMMU at runtime from the MmapCopy field in /proc/meminfo
  and avoid timeout, which requires fork(2).
- Document how to build and run the NOMMU tests, including the procfs
  prerequisite for runtime detection.

Build and run the tests with:

 $ make ARCH=um O=build kselftest-all TARGETS=nommu
 $ make ARCH=um O=build kselftest-install TARGETS=nommu
 $ ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu

Link: https://lore.kernel.org/20261006085642.3852152-1-thehajime@gmail.com
Link: https://lore.kernel.org/20261006085642.3852152-2-thehajime@gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: "Ricardo B. Marliere" <rbm@suse.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Daniel Palmer <daniel@thingy.jp>
---

 Documentation/dev-tools/kselftest.rst       |   18 ++++++++++++++++++
 tools/testing/selftests/kselftest/runner.sh |   11 ++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

--- a/Documentation/dev-tools/kselftest.rst~selftests-run-tests-on-nommu-architecture
+++ a/Documentation/dev-tools/kselftest.rst
@@ -230,6 +230,24 @@ section::
 
 .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
 
+Build and test on nommu target
+==============================
+
+The nommu selftests detect NOMMU at runtime by checking for the ``MmapCopy``
+entry in ``/proc/meminfo``. Ensure procfs is mounted at ``/proc`` before
+building and running the tests.
+
+::
+
+  $ make ARCH=um O=build kselftest-all TARGETS=nommu  # <= build-only
+  $ make ARCH=um O=build kselftest-install TARGETS=nommu
+  $ ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu
+
+The C tests report a skip if ``/proc/meminfo`` is unavailable. On a NOMMU
+system, the runner needs that file to avoid wrapping the tests in ``timeout``
+before they can report a skip. Mounting procfs is therefore a prerequisite
+for running this target through the kselftest runner.
+
 Contributing new tests
 ======================
 
--- a/tools/testing/selftests/kselftest/runner.sh~selftests-run-tests-on-nommu-architecture
+++ a/tools/testing/selftests/kselftest/runner.sh
@@ -36,10 +36,19 @@ tap_prefix()
 	fi
 }
 
+is_nommu()
+{
+	grep -q '^MmapCopy:' /proc/meminfo 2>/dev/null
+}
+
 tap_timeout()
 {
+	# nommu doesn't support timeout command (missing fork(2))
+	if is_nommu; then
+		echo "timeout isn't supported for NOMMU"
+		$1
 	# Make sure tests will time out if utility is available.
-	if [ -x /usr/bin/timeout ] ; then
+	elif [ -x /usr/bin/timeout ]; then
 		/usr/bin/timeout --foreground "$kselftest_timeout" \
 			/usr/bin/timeout "$kselftest_timeout" $1
 	else
_

Patches currently in -mm which might be from thehajime@gmail.com are

selftests-run-tests-on-nommu-architecture.patch
selftests-nommu-add-nommu-mmap-and-mremap-behavior-tests.patch

