Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC9217736
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188446; cv=none; b=k8moRBPNBZsOtQKDSFwD6ROKCMS3mBPMhwfHhB0IRDIzuRr/AXYzo8+P8yojeQdf2eAHYTPtZhlsAlOL0Xko4GAn2FF8IqcoZfFs5fyq9xJXPczkkvvtBgmON60/52TlvUPFzowJIIMsB1NKBW0cZSmZJrqDYlztSCgRU1hE7I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188446; c=relaxed/simple;
	bh=gKM7uokklr35OGd01Dj8xQfk5Kih7mN8XReBONGKJfg=;
	h=Date:To:From:Subject:Message-Id; b=IlcvwbUTVMokuxYJyEVmBeT1tWe4FgqdboCiGszdLbpo9N2LL0gZ2MFjPpl99u72SuszBlagvEUqJTW8hHGB6eyGde66Qou53s0mPS2B2yyKLyGsjEvR4To5+QSJyv1LY+i8q9CoWtcQYVZ344Lm9I61+aFryf/1Gh7AUa4prt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SuGJdTXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SuGJdTXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED3BC4CEEC;
	Mon, 17 Mar 2025 05:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188446;
	bh=gKM7uokklr35OGd01Dj8xQfk5Kih7mN8XReBONGKJfg=;
	h=Date:To:From:Subject:From;
	b=SuGJdTXST8vR8fn3a7Znce/nfVOFgYl0ZNpa6XE4pUQjlo3eXVmjyzofFFteJP4br
	 c8lhHJ1TySKOO0HD88bvmjk+RGwzDESlLMYEFEGvI42kWoe5yA6zbio461BStRtPMJ
	 MDdG8tINFfSVpNVvOtLbV/iUNjQ5uSOJknU/3Ijw=
Date: Sun, 16 Mar 2025 22:14:06 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-drop-unnecessary-sudo-usage.patch removed from -mm tree
Message-Id: <20250317051406.AED3BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: drop unnecessary sudo usage
has been removed from the -mm tree.  Its filename was
     selftests-mm-drop-unnecessary-sudo-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: drop unnecessary sudo usage
Date: Tue, 11 Mar 2025 13:18:20 +0000

This script must be run as root anyway (see all the writing to privileged
files in /proc etc).

Remove the unnecessary use of sudo to avoid breaking on single-user
systems that don't have sudo.  This also avoids confusing readers.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-9-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-drop-unnecessary-sudo-usage
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -402,7 +402,7 @@ CATEGORY="madv_populate" run_test ./madv
 
 if [ -x ./memfd_secret ]
 then
-(echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
 CATEGORY="memfd_secret" run_test ./memfd_secret
 fi
 
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

