Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1BA3F412C
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 19:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791400673; cv=none; b=QGREoQawDHVMNpMhLhBps/thtErSzvZY/k7IT5vHwkugxQUp+YpqgOn1R9hNeV2hOllktTjJVmViLPlofFGzIy4DPGEIqWilw7JsX4Moim87mSA9b4I3VPYUkMIx1RT71X/y07JpkYKXRZ9xRu7n6PDwohiuE8Gc5rmpos/ui58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791400673; c=relaxed/simple;
	bh=u1jtA0VgCNtRcTudo+OwAncC/U0ekoTdoKUrF9yb2EU=;
	h=Date:To:From:Subject:Message-Id; b=ZBHrfN3hgDTh2tIebZ6x67H+8cMcMyAmUB+QQukd9vNTVhUOWAL+mu8bJ44o1UWToJq6SWLeHBXHk+1nTu0EPB14d5gAVWQMysBI9j0JbH3wxlGHAX4S85vrLbrJSFsoHGhl8yqXA2aySqseFMPrX4tgPR4DVQ5jUSP0Fq9YxWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LpYp3ycP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LpYp3ycP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B13D1F00893;
	Wed,  7 Oct 2026 19:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791400671;
	bh=Fz/IBBtFzOM3nq2bRgSCIqW78EVDCQvBRODG49Ku7xQ=;
	h=Date:To:From:Subject;
	b=LpYp3ycPwlMzCEhoLO8XbI55IwvYEYBEu+SXeLuVy8dgLPRv6NdIJix5f3ayg8IbD
	 il07uJkBkDlhDUyg36Z1b3UQt4LbSy0ivymBpL4VeNPSV5yVoJsJ6M6n84O0HuuUad
	 +yROmGseClJe20Wwx9+UUtwc/SER8y5unro0NvbY=
Date: Wed, 07 Oct 2026 12:17:50 -0700
To: mm-commits@vger.kernel.org,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-run-tests-on-nommu-architecture.patch removed from -mm tree
Message-Id: <20261007191751.2B13D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: run tests on nommu architecture
has been removed from the -mm tree.  Its filename was
     selftests-run-tests-on-nommu-architecture.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hajime Tazaki <thehajime@gmail.com>
Subject: selftests: run tests on nommu architecture
Date: Wed, 30 Sep 2026 08:57:10 +0900

Patch series "support kselftest on nommu platform", v4.

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
Especially the test harness helper (kselftest_harness.h) uses the syscall,
which cannot be simply with vfork(2).  `timeout` command used in
`runner.sh` never works for nommu platform as it uses fork(2).

nommu component in the mm subsystem has several known issues and having
test cases should help this situation, thus this patchset is very first
step toward enriching test environment which has not been well tested for
a while.  The test cases is implemented based on the document
(Documentation/admin-guide/mm/nommu-mmap.rst).

Initial shape for this patches is implemented as an opt-in TARGET, not
built/invoked automatically if users don't specify this nommu target.


This patch (of 2):

Architectures lacking MMU don't support fork(2) syscall and only vfork(2)
is available with limitations.  Thus, we cannot run kselftest on nommu
architecture as is.

This commit addresses this issue with the following changes:

- on test run stage, avoid calling timeout command when NOMMU=1 variable
  added to environmental variable, since timeout command uses fork
  syscall which nommu platform doesn't support.
- describe the difference of nommu tests in the document.

So command line to build/execute tests for nommu should be like below:

 $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu
 $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
 $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
   -c nommu

Link: https://lore.kernel.org/20260929235711.2287931-1-thehajime@gmail.com
Link: https://lore.kernel.org/20260929235711.2287931-2-thehajime@gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Daniel Palmer <daniel@thingy.jp>
---

 Documentation/dev-tools/kselftest.rst       |   14 ++++++++++++++
 tools/testing/selftests/kselftest/runner.sh |    6 +++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/Documentation/dev-tools/kselftest.rst~selftests-run-tests-on-nommu-architecture
+++ a/Documentation/dev-tools/kselftest.rst
@@ -230,6 +230,20 @@ section::
 
 .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
 
+Build and test on nommu target
+==============================
+
+If you (cross-)build kselftests for nommu targets, or run tests on nommu targets, use
+``NOMMU=1`` as a make variable/environment setting to tell build system to do the additional
+checks.  These nommu targets may differ in several ways, such as not supporting fork(2) or
+using musl or another libc.  Set this variable to apply the necessary build and test adjustments.
+
+::
+
+  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu  # <= build-only
+  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
+  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu
+
 Contributing new tests
 ======================
 
--- a/tools/testing/selftests/kselftest/runner.sh~selftests-run-tests-on-nommu-architecture
+++ a/tools/testing/selftests/kselftest/runner.sh
@@ -38,8 +38,12 @@ tap_prefix()
 
 tap_timeout()
 {
+	# nommu doesn't support timeout command (missing fork(2))
+	if [ "$NOMMU" = "1" ] ; then
+		echo "timeout isn't supported for NOMMU"
+		$1
 	# Make sure tests will time out if utility is available.
-	if [ -x /usr/bin/timeout ] ; then
+	elif [ -x /usr/bin/timeout ] ; then
 		/usr/bin/timeout --foreground "$kselftest_timeout" \
 			/usr/bin/timeout "$kselftest_timeout" $1
 	else
_

Patches currently in -mm which might be from thehajime@gmail.com are

selftests-nommu-add-nommu-mmap-and-mremap-behavior-tests.patch

