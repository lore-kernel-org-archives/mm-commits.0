Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6E240803D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525491; cv=none; b=r19oXLWddLNjGnM+ZCHqNYUqO07QmCahwGSWXL67lvnY3u3IS05xF7tHRhaf0gJPfollIQ3wXxjbXeIYPUw8RBUNuc8h9WSktCyRvFc6mgh1vCGPSGcGVy43uY3I5I/G84rOisWjaU7Lj3d2fTXy6mNRKNEePF+QbjT/QOdQXbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525491; c=relaxed/simple;
	bh=lL7Qbb28h4SIONQwkaMqwh6rpQvSH0vsgM5ULk62NP0=;
	h=Date:To:From:Subject:Message-Id; b=uP63qmU6XcpFVgC/gPV7gyN55Ksk6NMmp8GcLTPjlVfkvsA4anEEgxzdqZ5lyp7oplBl7KIpifZkONCvyOTW6K8jkd3R5Aa62/R6swfLtUU4d0dC1tqlaqOdgnAuMoJlAA6K/RUOkpsJxJdTImcGVF4qtZ3czxfkiTy6tdUFNcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bkKrAky+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bkKrAky+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BEF1F00893;
	Fri,  9 Oct 2026 05:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525489;
	bh=3rhybKk5CWNnspfMC7wakbIE+tXxwWpN4ATykwTUols=;
	h=Date:To:From:Subject;
	b=bkKrAky+c8J3KQTtxZrrjLWoK/TyM/jBWA/bZw/Mkrh6QXlDPd+K1MIRUHcbSyHBO
	 uxmm/iJuNN+vm046oXruFMyjaK9OLwhwUKrhEJ29dRf3oDfREuRcAnzAU+Y3GNJxtb
	 7Mh29ntlXkyZ5Si+/Og9+ILAa2UXjtPFinRqINMo=
Date: Thu, 08 Oct 2026 22:58:09 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jsavitz@redhat.com,david@kernel.org,hi@tychen.cc,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected.patch removed from -mm tree
Message-Id: <20261009055809.B0BEF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: only prepare ptrace_scope when memfd_secret is selected
has been removed from the -mm tree.  Its filename was
     selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tianyi Chen <hi@tychen.cc>
Subject: selftests/mm: only prepare ptrace_scope when memfd_secret is selected
Date: Thu, 10 Sep 2026 20:56:45 +0800

The memfd_secret setup clears ptrace_scope whenever its test binary is
executable, even when a different category was selected.  run_test()
filters the test invocation, but it does not protect the preceding setup.

Check the category selection before entering the memfd_secret block so
running unrelated categories does not change ptrace_scope.  Keep the
existing executable check and the behavior when memfd_secret is selected.

Link: https://lore.kernel.org/20260910125645.285866-3-diannaaav@gmail.com
Signed-off-by: Tianyi Chen <hi@tychen.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -370,7 +370,7 @@ CATEGORY="process_madv" run_test ./proce
 
 CATEGORY="vma_merge" run_test ./merge
 
-if [ -x ./memfd_secret ]
+if test_selected "memfd_secret" && [ -x ./memfd_secret ]
 then
 if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
 	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
_

Patches currently in -mm which might be from hi@tychen.cc are


