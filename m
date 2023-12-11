Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C26B7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fjsQN58i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBE4C433C8;
	Mon, 11 Dec 2023 01:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257788;
	bh=+JHU9MazyyqsXgGpMivoFhvfqOj6K6rFkwh9xwGOqSw=;
	h=Date:To:From:Subject:From;
	b=fjsQN58ivU8Tyg+Kqw9w1kqPNpmvjTkTEcRMoar0jgP3uw/CthEVPALnC/maHVhqm
	 ysOBnYbiG5EUGQ2JgDBi9MjOuMQlczvjvienTY2NMuYmwcbS2rQM+MANfofzSGntee
	 hOsva2EvYJeDs6CzKqOmtX7TvCV4S99WOp4tgqJU=
Date: Sun, 10 Dec 2023 17:23:08 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,bhe@redhat.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-use-atomic_try_cmpxchg-in-crash_kexec.patch removed from -mm tree
Message-Id: <20231211012308.CBBE4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: use atomic_try_cmpxchg in crash_kexec
has been removed from the -mm tree.  Its filename was
     kexec-use-atomic_try_cmpxchg-in-crash_kexec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: kexec: use atomic_try_cmpxchg in crash_kexec
Date: Tue, 14 Nov 2023 17:12:01 +0100

Use atomic_try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
crash_kexec().  x86 CMPXCHG instruction returns success in ZF flag,
so this change saves a compare after cmpxchg.

No functional change intended.

Link: https://lkml.kernel.org/r/20231114161228.108516-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/kexec_core.c~kexec-use-atomic_try_cmpxchg-in-crash_kexec
+++ a/kernel/kexec_core.c
@@ -1063,9 +1063,10 @@ __bpf_kfunc void crash_kexec(struct pt_r
 	 * panic().  Otherwise parallel calls of panic() and crash_kexec()
 	 * may stop each other.  To exclude them, we use panic_cpu here too.
 	 */
+	old_cpu = PANIC_CPU_INVALID;
 	this_cpu = raw_smp_processor_id();
-	old_cpu = atomic_cmpxchg(&panic_cpu, PANIC_CPU_INVALID, this_cpu);
-	if (old_cpu == PANIC_CPU_INVALID) {
+
+	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu)) {
 		/* This is the 1st CPU which comes here, so go ahead. */
 		__crash_kexec(regs);
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are


