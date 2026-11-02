Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640271;
	b=nkei6zO66KYbxLRgbn/eu8NRKNaayGcE+m1Hg2wy/88kbXVFgD8Rg/HTHwtivAFJbnSr
	 WvFX44IeA2NTF8UXhvTMoEoWqeEEDQWfWW8WH8i6d7vRBkUpYiCdgobIrQRFLSr6GRgaq
	 Ou3biXgOCOcD6pJGaLU1DFBgHsfRnxkCb8+Y9x8css7G9Cw4D4SB2cRi6t5fQfHhCVqtu
	 WWRLkPpZKbCcQLPUCd00UzUNt+37yDPn6RSeWoKddAkdV0lVwVYEvoKjqWq0OsUhCZTQq
	 Zq46G0k70Sqm1rd5qXaPG93Ypk72pg1mdQGMxNbhsWXzlGotkfE3KCQoTJ81EIhIbEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640271;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cxQtCNFLdIiK3VtUcFTKrbGMrRN0XIJr0EPQi4+k3JI=;
	b=Lq0YtIXHM9TrMXwBOCLFZ9rYUsqqsy8wfUJy4s9YBOY2rqVsUd8bVXfun3vdRBB+t/al
	 zhVABd5RLiG4SvViPgoGFmDDdn7LDjOh9uzCRE108+FG7fvxidEmzfIca0LxiGCFs7Mly
	 vbWED8EDqtLuxpeO0LKzQi7zcq1kjIZzqsOFDHFcL3ssB5xHv9j0ZEdRCXSPFEN+dGS2k
	 r76TW3K9N9uiHxmW0DjYo9jtFnAaawtzjRI0TJ5eiTMJ94N7Lyi6vG4bksMheMeLt1NlE
	 zDI/irgBJFh0vZiEPGSGxKcs9IZX95ZO0Wdp7HJhyUiYk2SsBe71kIp0AgNtayFP3Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0R6Blbe+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD8A606B922
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0R6Blbe+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BED1F00A17;
	Mon,  2 Nov 2026 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640270;
	bh=cxQtCNFLdIiK3VtUcFTKrbGMrRN0XIJr0EPQi4+k3JI=;
	h=Date:To:From:Subject;
	b=0R6Blbe+XZcCx1i7YKKkI1ovC6u24K6nz8FFs5yIq/EFQ+CHZNomdfoDQBMg0p0mE
	 I7ZtyYCxqVctGnLv7NOsm9xPZoJ7Xp9nV1/X9I9vXOrcgX0kMF+7LdV5YQ1M7nDa2D
	 qKar07eTMJQwZll5KiMzMcPX0biMz+bnhBGutgbc=
Date: Mon, 02 Nov 2026 09:24:30 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,sh@gentwo.org,
	ruanjinjie@huawei.com,manuelebnerli@mailbox.org,lienze@kylinos.cn,
	jm5905938@gmail.com,adrianhuang0701@gmail.com,jaeyeon.lee.dev@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-stop-obsolete_target-shells-hanging-the-test.patch added to mm-new branch
Message-Id: <20261102172430.70BED1F00A17@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/damon/sysfs.py: stop obsolete_target shells hanging the test
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-stop-obsolete_target-shells-hanging-the-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-stop-obsolete_target-shells-hanging-the-test.patch

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
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: selftests/damon/sysfs.py: stop obsolete_target shells hanging the test
Date: Mon, 02 Nov 2026 07:07:53 -0800

The obsolete_target test spawns three 'sh' processes as monitoring
targets.  The processes inherit stdin from the test.  When the test is
run via 'make run_tests' from an interactive terminal, the kselftest
runner executes it under 'timeout', which puts it in a background
process group.  The 'sh' processes then try to read the terminal, so
the kernel sends SIGTTIN to the whole process group.  This stops the
'sh' processes, and also the child the test has just forked to spawn
the next 'sh', before it can run 'sh'.  The test then waits on that
child forever, until the kselftest runner kills it after 45 seconds.
The test passes when run directly.

Fix this by passing stdin=subprocess.PIPE when spawning the processes.
The processes then read from a pipe that never receives input, so they
stay alive and idle as the test expects.

Link: https://lore.kernel.org/20261102150757.93058-7-sj@kernel.org
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
---

 tools/testing/selftests/damon/sysfs.py |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-stop-obsolete_target-shells-hanging-the-test
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -390,12 +390,12 @@ def main():
     kdamonds.stop()
 
     # test obsolete_target.
-    proc1 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
-    proc2 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
-    proc3 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
+    proc1 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
+    proc2 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
+    proc3 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
                 contexts=[_damon_sysfs.DamonCtx(
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

selftests-damon-sysfspy-stop-obsolete_target-shells-hanging-the-test.patch

