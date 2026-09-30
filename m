Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF673B42ED
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 22:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790805695; cv=none; b=daQDWWKYwzBf+/2lMOf2DXesGa9zeeakUmlHzenVPPQkd4z06fXkLolZayntAPOtI3PKvhV1L/WfYwXphANREgrztBB7WU280K44PpLGxKQnEsy8H2MJNqI/nKTDMp1BZT+Hq56NQv3+XlPA3pLWjJ99skUdd+OuZZOZMi+rX+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790805695; c=relaxed/simple;
	bh=4MleFz30j1nyfgAVVLg7pDeAtzcJTg7oFemwWqp5txU=;
	h=Date:To:From:Subject:Message-Id; b=erValFZpOxXpr+oGIvNfORj5sI97SkeA+6JTyCP1uPA5jxI+WehmPSmWaOI2R2t4bp6FnAZb5qmkY/z66nV+zFEiThSIB/Eebsioayc3SoNZ35i50F7Tr/hilLE3bw+tsy23mHj97l1PXH/tEJZy66juqZIxjitx1XK3J2m9AY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y2MFjOge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y2MFjOge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7AE1F00898;
	Wed, 30 Sep 2026 22:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790805693;
	bh=VlIqwNM0y7qEUMs2zRu1ldGhL1CypiHNWsMYN+xYS+I=;
	h=Date:To:From:Subject;
	b=y2MFjOgeie7tALHBMoUtBRkeEcBVpgdDZSO7vGE5QCl7oILLgwh3JjzuT0LDz09UU
	 HIIbmnNsm+QQCp9TNBF5DlSnPWtMZL9k0WbsbO87GC5dWJH/VVxHcD87/UhrK3eoR9
	 5lR4pkKkorK2KYsfos5AXxb+EF0hmQg1ixrvf380=
Date: Wed, 30 Sep 2026 15:01:32 -0700
To: mm-commits@vger.kernel.org,wad@chromium.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rbm@suse.com,mhocko@suse.com,luto@amacapital.net,ljs@kernel.org,liuhangbin@gmail.com,liam@infradead.org,kees@kernel.org,geert@linux-m68k.org,david@kernel.org,daniel@thingy.jp,corbet@lwn.net,broonie@kernel.org,brendan.jackman@linux.dev,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-run-tests-on-nommu-architecture.patch added to mm-new branch
Message-Id: <20260930220133.3D7AE1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: run tests on nommu architecture
has been added to the -mm mm-new branch.  Its filename is
     selftests-run-tests-on-nommu-architecture.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-run-tests-on-nommu-architecture.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

selftests-run-tests-on-nommu-architecture.patch
selftests-nommu-add-nommu-mmap-and-mremap-behavior-tests.patch

