Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194CE320F
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 05:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336993; cv=none; b=uLdBNfcgd6HPql4zE/3AgDBSrPDSxkgIvyTVJRtleEPeWnHgR44C8XjCoxjIToPOcIHGxh7ywTVCbw+U/o8SDYul4JfXP1+twB29JnA2RJXbrCZzb4YFP6xxJIwZRnENM0BPZ8gQsSlyL9SgQ59XcWYZFzdSk0Gj6NKQp8ZE6Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336993; c=relaxed/simple;
	bh=+VhxTpMQRdMHMccPUgIEN9qsw+fTi1qXcG99lFCrrn4=;
	h=Date:To:From:Subject:Message-Id; b=sX7LE0B62oUAcEpGFLiL71mzollLRDexSi1ASTFjN5GJP6768Yv/76E9fod6ZsNy6i1CRO9QXRsgkgRqpJcEXBzDdLyE/mc7ghOnP60EokCAMmQx366uJ6NdAwChgGYhzkb+QaMEat1tSEYusovBtF7GTvJKxNmoHqqXB0hXMRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zFg2al2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zFg2al2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7246DC4CEE9;
	Sun,  4 May 2025 05:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746336992;
	bh=+VhxTpMQRdMHMccPUgIEN9qsw+fTi1qXcG99lFCrrn4=;
	h=Date:To:From:Subject:From;
	b=zFg2al2Ha4ZMQezDDHBmxTB+Sp1fa93vJxYhfpozya1LVlvxPxjcE2smhbiMwRnwG
	 d9+Z6jFMfiVkFjR07URA3MhlKOkFaKEwAAjnkqzHAK6b/iqFGLfU4P8cui5unvJQnm
	 +m8XdNJQtm2ZO4oGWa8JuiO9zGX4sTc8d7P/tY2k=
Date: Sat, 03 May 2025 22:36:31 -0700
To: mm-commits@vger.kernel.org,si.yanteng@linux.dev,mail@florommel.de,kbingham@kernel.org,jan.kiszka@siemens.com,jackmanb@google.com,dzm91@hust.edu.cn,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-kgdb-probing-on-single-core-systems.patch added to mm-nonmm-unstable branch
Message-Id: <20250504053632.7246DC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix kgdb probing on single-core systems
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-kgdb-probing-on-single-core-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-kgdb-probing-on-single-core-systems.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Illia Ostapyshyn <illia@yshyn.com>
Subject: scripts/gdb: fix kgdb probing on single-core systems
Date: Sat, 3 May 2025 14:32:31 +0200

Patch series "scripts/gdb: Fixes related to lx_per_cpu()".

These patches (1) fix kgdb detection on systems featuring a single CPU and
(2) update the documentation to reflect the current usage of lx_per_cpu()
and update an outdated example of its usage.


This patch (of 2):

When requested the list of threads via qfThreadInfo, gdb_cmd_query in
kernel/debug/gdbstub.c first returns "shadow" threads for CPUs followed by
the actual tasks in the system.  Extended qThreadExtraInfo queries yield
"shadowCPU%d" as the name for the CPU core threads.

This behavior is used by get_gdbserver_type() to probe for KGDB by
matching the name for the thread 2 against "shadowCPU".  This breaks down
on single-core systems, where thread 2 is the first nonshadow thread. 
Request the name for thread 1 instead.

As GDB assigns thread IDs in the order of their appearance, it is safe to
assume shadowCPU0 at ID 1 as long as CPU0 is not hotplugged.

Before:

(gdb) info threads
  Id   Target Id                      Frame
  1    Thread 4294967294 (shadowCPU0) kgdb_breakpoint ()
* 2    Thread 1 (swapper/0)           kgdb_breakpoint ()
  3    Thread 2 (kthreadd)            0x0000000000000000 in ?? ()
  ...
(gdb) p $lx_current().comm
Sorry, obtaining the current CPU is not yet supported with this gdb server.

After:

(gdb) info threads
  Id   Target Id                      Frame
  1    Thread 4294967294 (shadowCPU0) kgdb_breakpoint ()
* 2    Thread 1 (swapper/0)           kgdb_breakpoint ()
  3    Thread 2 (kthreadd)            0x0000000000000000 in ?? ()
  ...
(gdb) p $lx_current().comm
$1 = "swapper/0\000\000\000\000\000\000"

Link: https://lkml.kernel.org/r/20250503123234.2407184-1-illia@yshyn.com
Link: https://lkml.kernel.org/r/20250503123234.2407184-2-illia@yshyn.com
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Florian Rommel <mail@florommel.de>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/utils.py~scripts-gdb-fix-kgdb-probing-on-single-core-systems
+++ a/scripts/gdb/linux/utils.py
@@ -200,7 +200,7 @@ def get_gdbserver_type():
 
     def probe_kgdb():
         try:
-            thread_info = gdb.execute("info thread 2", to_string=True)
+            thread_info = gdb.execute("info thread 1", to_string=True)
             return "shadowCPU" in thread_info
         except gdb.error:
             return False
_

Patches currently in -mm which might be from illia@yshyn.com are

scripts-gdb-fix-kgdb-probing-on-single-core-systems.patch
scripts-gdb-update-documentation-for-lx_per_cpu.patch

