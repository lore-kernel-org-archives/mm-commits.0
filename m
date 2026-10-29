Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793300939;
	b=y2jZMHaahldZ0npmOddOmr3bsRlJA+PF1usbvo7Coz2reZZNih3hYqz5qNxtUPZ5b/Qn
	 GCCdussuFcoqWMGLMuECViqkAxBMIMHcHpDh1ee5R65apVw+fTU7JwUReQTUvo4qdD2NO
	 FQsLHAka+gcVkf2qRfnd9O8sasXDwfnm5pwJqIu8Nt+mPn08C5Tuvp35Ef8wDbCgg1XY5
	 wFcV6TBoqxWBFLgZ8FMhB+E1LooryhDgsYgpSKe1526M/VuraaeoGgZjKF5AtOVtXj3ZB
	 Uf2/odEo/fO3ErpnqZkbB3Nw+tPmK17BQB9YS2wcJNr/olgFrPHupZN82zbnAGFdcoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793300939;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jnuFM4I9t24WWmaMqnTyfTZvfVyfpytlUmPqFGZb+rk=;
	b=LRMKvgjtJeNSpguLTjpNJZKmw+f3MBf/l2hxI8javRo/GlJeDFg0gUz5Q84jl7GplCnm
	 W7r/S3JhlLkNrh+oBMJJW6zt7lnLzaM9M/NtJpUpOfG5LPj/qg+oK1cVXsqpY+nCXovFs
	 6eW/T8Ij2DdQaI+h5mvBundubbtbHsEw/JhgxjKcqMbLaDAwK4q57nTpG1EmMVanBJ4yj
	 CUwKdYKqAY19NT2NE3sXSnbo0Ev7uXMbQCS9vyLO+OfxD5/k4SGcP5vRs+GjzUB0ghsCM
	 /bQBr39h2dhTB0Bk4PBYwafgNv6j8Tt9khsYnXqZIcvUv8hKxNAMDFJE3BWsQK1IUnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GqFEz5vM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233B1606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GqFEz5vM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929911F01824;
	Thu, 29 Oct 2026 19:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793300938;
	bh=jnuFM4I9t24WWmaMqnTyfTZvfVyfpytlUmPqFGZb+rk=;
	h=Date:To:From:Subject;
	b=GqFEz5vMiEPHXZsev46HF+lD0E2mN7yfqEjdlN5H7/TScbEYkMEaCtrVgPhPQYKA4
	 eQ5POGBr0774+PKyjlRHCDi2oO75KHzAxHWy8bMbd8nfsNEmMXK8Z3g7nyvCAHwxpA
	 wIDRGmLvD4e8asXBKLy4kRGb6hPPMnS8pdQ9Qxdg=
Date: Thu, 29 Oct 2026 12:08:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-track-the-modules-run_vmtestssh-loads.patch added to mm-new branch
Message-Id: <20261029190858.929911F01824@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: track the modules run_vmtests.sh loads
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-track-the-modules-run_vmtestssh-loads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-track-the-modules-run_vmtestssh-loads.patch

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
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: selftests/mm: track the modules run_vmtests.sh loads
Date: Thu, 29 Oct 2026 02:24:35 -0400

Patch series "selftests/mm: run the XFS-backed THP tests when xfs is a
module", v3.

run_vmtests.sh only creates the XFS that "khugepaged all:file" and the
pagecache folio split cases of split_huge_page_test need when xfs is
already registered, so with xfs built as a module and not loaded yet
those tests are all skipped.

Patch 1 adds load_module(), which records the modules the script loads
and unloads them again before it exits, and moves hwpoison_inject over
to it. Patch 2 loads xfs through it.


This patch (of 2):

run_vmtests.sh loads hwpoison_inject for the memory-failure test when it
is not there yet, remembers that in a variable local to run_test() and
unloads the module right after the test.

The thp tests need xfs loaded in the same way, and repeating the load,
the bookkeeping and the unload for every module that some test needs
does not scale.

Add load_module(), which loads a module unless it is already present
and records it, and unload every recorded module, in reverse order,
before the script exits. Use it for hwpoison_inject.

Link: https://lore.kernel.org/20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com
Link: https://lore.kernel.org/20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-1-16ad772850ee@gmail.com
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/run_vmtests.sh |   31 ++++++++++++++------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-track-the-modules-run_vmtestssh-loads
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -171,11 +171,30 @@ pretty_name() {
 	echo "$*" | sed -e 's/^\(bash \)\?\.\///'
 }
 
+# Modules this script loaded, unloaded again before it exits
+LOADED_MODULES=()
+
+# Usage: load_module [module]
+load_module() {
+	if [ -d "/sys/module/$1" ]; then
+		return 0
+	fi
+	modprobe -q "$1" || return 1
+	LOADED_MODULES+=("$1")
+}
+
+unload_modules() {
+	local i
+
+	for (( i = ${#LOADED_MODULES[@]} - 1; i >= 0; i-- )); do
+		modprobe -r -q "${LOADED_MODULES[i]}"
+	done
+}
+
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
 		local skip=0
-		local LOADED_HWPOISON_INJECT_MOD=0
 
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
@@ -201,8 +220,7 @@ run_test() {
 						| tap_prefix
 					skip=1
 				else
-					modprobe hwpoison_inject > /dev/null 2>&1
-					LOADED_HWPOISON_INJECT_MOD=1
+					load_module hwpoison_inject
 					if [ ! -d "$HWPOISON_DIR" ]; then
 						echo "hwpoison debugfs interface not present" \
 							| tap_prefix
@@ -225,11 +243,6 @@ run_test() {
 			local ret=${PIPESTATUS[0]}
 		fi
 
-		# Unload hwpoison_inject if we loaded it
-		if [ "${LOADED_HWPOISON_INJECT_MOD}" = "1" ]; then
-			modprobe -r hwpoison_inject > /dev/null 2>&1
-		fi
-
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
@@ -453,4 +466,6 @@ CATEGORY="memory-failure" run_test ./mem
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
+unload_modules
+
 exit $exitcode
_

Patches currently in -mm which might be from odys.yuan@gmail.com are

selftests-mm-track-the-modules-run_vmtestssh-loads.patch
selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch

