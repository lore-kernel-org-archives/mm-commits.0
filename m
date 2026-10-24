Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832456;
	b=T86JOH1V8SNsLGd+2sj3ilNn8crK8K6EOpodRzKJ6mpOSsApWhqWtarwKT6fZz40raku
	 kFMn2qy6QgzWUrJ5IYfmpWYR/EaKoJ5wXcTK3sO261xeqYDSzPlMGh+F5u+YF1XuIpayW
	 SizFnRuq/hiBE3Keg7NBAxmkJl2N1OdBbM+CcMDasd+TYmdVz7bxC7QhWS5avu6iu+LJo
	 ldKGXSEF3NR/UyQsQ6dk4jiKlXNivj4F9EWeyZ8V5LYhJzuXaOY3N4/rCSo8OXzofCxzp
	 w1IMHk00CTEsgyRqU5J+nM9Papta59H/l3ubN1Mbym4NRkE+WZwrMvpSUKpcDAFAAlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832456;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RKnKlgPfwoak+fnD7liS2Gr2p6lywYyYI4zhZQygbPY=;
	b=eTqCed8ea++TyHWGTJwTmKnmnXpF4ZAGoOzQpXtsENLrTstcMqywSqyFytZdujgJ90xn
	 4tImyj7Pscea5u1me8oCECZWC+ebEpj1cSTbH6YYp9ppYSk8kCRvxPUZYgOstz9Y/z36Z
	 IaKzmcRvbuyIcBjP6zWNeoFKpaG7g8+ghlq7DWpNH/laLgZABXlg4TEE/pHYezntwVcf1
	 fig01FqMwn9PBcXtMVFdzg+YWtgF9JemJtYNtpabzxSYfrCyf/OLtELU8IdO+Fio0JJPt
	 yxWXU52ujCvQ6bD13cWgRaTazj/lW9Rf8DxdjLET2jpdy4SBJ/uhYkK2TLlJiW9S8qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OBxcHNQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D74606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OBxcHNQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AA11F01825;
	Sat, 24 Oct 2026 09:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832455;
	bh=RKnKlgPfwoak+fnD7liS2Gr2p6lywYyYI4zhZQygbPY=;
	h=Date:To:From:Subject;
	b=OBxcHNQwqE6s5LivG8EQ0+K7YG68xF4ENQwSKszDlaC1UDNvdZG3XnpJjjKF7bhSG
	 Sa995KNbxJz4ZmfEh7ESxscInA+60/bvZ73UlkiPXivDDxbE2PEnnfdujrXt7FnKdx
	 NVaTlet+BE7semwxtbsr76l4RyK4zdM6+0XNLdqk=
Date: Sat, 24 Oct 2026 02:00:55 -0700
To: mm-commits@vger.kernel.org,wad@chromium.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rbm@suse.com,mhocko@suse.com,luto@amacapital.net,ljs@kernel.org,liuhangbin@gmail.com,liam@infradead.org,kees@kernel.org,geert@linux-m68k.org,david@kernel.org,daniel@thingy.jp,corbet@lwn.net,broonie@kernel.org,brendan.jackman@linux.dev,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-run-tests-on-nommu-architecture.patch removed from -mm tree
Message-Id: <20261024090055.A5AA11F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests: run tests on nommu architecture
has been removed from the -mm tree.  Its filename was
     selftests-run-tests-on-nommu-architecture.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


