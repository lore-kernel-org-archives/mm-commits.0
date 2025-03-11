Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DF71D514A
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714625; cv=none; b=Thi6DVuK46s7aM8WoNPENvaq1NQFszh8+yPnokYoAXBYnyb8I4lwfy1A44xN1O4ctAHjLgugDjkUI+4qgnSYB0NrQiOdNjh1I0Dns6Mo9BGqIOWpocRlpx0At4VUsrzoW4ND/rAF8YejNZWeWJJ5DhkFYgRARoOQEa+s97irS5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714625; c=relaxed/simple;
	bh=4mo4hXszwimTYPdFL53VBhmA1X62dFD7OnUiZGBRuUM=;
	h=Date:To:From:Subject:Message-Id; b=hG4kdvRmxzA5epQCw+A+Q1JDkF/vhYBis41jSxnzffK3xbGozG/macJOj88PmuceHAV4YlKndVRUUA1oIIkRNXGcXfe9Bma/fuRuSuDPRPKrdte3/NayZxBBYKcX8sos1zLy2AS6+DDLaJgzYBUGmIb77vFs+PHudehPao9s5z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XKcMLlJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XKcMLlJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CC7C4CEE9;
	Tue, 11 Mar 2025 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714624;
	bh=4mo4hXszwimTYPdFL53VBhmA1X62dFD7OnUiZGBRuUM=;
	h=Date:To:From:Subject:From;
	b=XKcMLlJJWKCbOE2F6MySyrHjAzIVQOcVogU6KI93vgLx6Jt4BoMBsgOugkZFN1V3d
	 C+Tq31PNdqsxv/udA22q7RM7yWQ7tx6X12euYuyf4e0pZIl2VAyckhWDWXg3i3a/Ox
	 DpAlRGR/TRWnBiIXUgZzHk96GpK4AokUNx9pWwXI=
Date: Tue, 11 Mar 2025 10:37:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch added to mm-unstable branch
Message-Id: <20250311173704.A0CC7C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip mlock tests if nobody user can't read it
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch

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
Subject: selftests/mm: skip mlock tests if nobody user can't read it
Date: Tue, 11 Mar 2025 13:18:22 +0000

If running from a directory that can't be read by unprivileged users,
executing on-fault-test via the nobody user will fail.

The kselftest build does give the file the correct permissions, but after
being installed it might be in a directory without global execute
permissions.

Since the script can't safely fix that, just skip if it happens.  Note
that the stderr of the `ls` command is unfiltered meaning the user sees a
"permission denied" error that can help inform them why the test was
skipped.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-11-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -353,7 +353,7 @@ echo "$nr_hugepgs" > /proc/sys/vm/nr_hug
 
 CATEGORY="compaction" run_test ./compaction_test
 
-if command -v sudo &> /dev/null;
+if command -v sudo &> /dev/null && sudo -u nobody ls ./on-fault-limit >/dev/null;
 then
 	CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
 else
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch
selftests-mm-drop-unnecessary-sudo-usage.patch
selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch
selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch
selftests-mm-mlock-print-error-on-failure.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

