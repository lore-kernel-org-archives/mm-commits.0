Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9156C3FFD
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183073; cv=none; b=dl0zP6Z6w9jb3t1MMxxJTy5eRzJHZSeNjVVvxv6l1Bbgr1o0H9863cv/0Es0YEMzVUenfhDzm+9/VYtfF3WjnBMwfRt2bhPc7rAHojcHGjzsM3evlbkGr+dUUnFB/xyrBX7TtIXL738xBDYz6jQu+epQK84QtdegXOkFVqbcRMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183073; c=relaxed/simple;
	bh=nrGMS/cf2k1V7/pRFgPRfMvyX/dxbIe4UatGgrjzfb0=;
	h=Date:To:From:Subject:Message-Id; b=q9AHh5qaOz8o3b1q0viUCDqenpgpBRWHo0t5h6cPiiUUdWi0j9vaKlCDUK6HNFseV2Iulc7QGXRNBgo6wAGxEDEXeDD0vGJRzXaEMTADbItOG6o1mVTOoayNgTggPIgbKyGgkAt1kIIQLPLe1Duz8wBRiVzS/yWuJQrcvJKxIPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C6na/Kkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C6na/Kkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEB3C4CED6;
	Sat, 22 Feb 2025 00:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183073;
	bh=nrGMS/cf2k1V7/pRFgPRfMvyX/dxbIe4UatGgrjzfb0=;
	h=Date:To:From:Subject:From;
	b=C6na/Kkffhj5s+Q7DYhPrhtf4bY+uhQuEL3O9Ac63t0+Ko+t+quUBrtJjVKpPX4qC
	 poo+oul2Lt/5EG2MO0e7VyrJ+m8fDS2y37P9jl/29BI5eqqoN3x3THbDEG2wpZoMHA
	 xbDRfDO8oIx/Shudl6py8nXqmyA/vS3X5VtVtjwM=
Date: Fri, 21 Feb 2025 16:11:12 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch added to mm-unstable branch
Message-Id: <20250222001113.5FEB3C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: don't fail uffd-stress if too many CPUs
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch

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
Subject: selftests/mm: don't fail uffd-stress if too many CPUs
Date: Fri, 21 Feb 2025 18:25:46 +0000

This calculation divides a fixed parameter by an environment-dependent
parameter i.e.  the number of CPUs.

The simple way to avoid machine-specific failures here is to just put a
cap on the max value of the latter.

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-7-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-dont-fail-uffd-stress-if-too-many-cpus
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -435,6 +435,7 @@ static void sigalrm(int sig)
 
 int main(int argc, char **argv)
 {
+	unsigned long nr_cpus;
 	size_t bytes;
 
 	if (argc < 4)
@@ -453,7 +454,15 @@ int main(int argc, char **argv)
 		return KSFT_SKIP;
 	}
 
-	nr_threads = sysconf(_SC_NPROCESSORS_ONLN);
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	if (nr_cpus > 32) {
+		/* Don't let calculation below go to zero. */
+		ksft_print_msg("_SC_NPROCESSORS_ONLN (%lu) too large, capping nr_threads to 32\n",
+			       nr_cpus);
+		nr_threads = 32;
+	} else {
+		nr_cpus = nr_threads;
+	}
 
 	nr_pages_per_cpu = bytes / page_size / nr_threads;
 	if (!nr_pages_per_cpu) {
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

