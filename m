Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360AC305E19
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 21:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783458688; cv=none; b=hBwb7//kOqzAFcdNoinKhDz7DZAFNr8DPpUmYcOyiOUmhGuldxlrZ3StPhNYG1ivzyVQTyiWc8jcYvJc9WBnCsAzCdLCwcMf/2TG2Lx21DM0KHSOeQMAtiGjL6pSI6ZpngMUn92h66wI7Y7so+EwAQA+twcMEXaaM89onSQrrnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783458688; c=relaxed/simple;
	bh=kFp4AH1jbwhIuEP6Ig8l1Db0LK+G+OpMQ21blGmIjxc=;
	h=Date:To:From:Subject:Message-Id; b=GZepX2wn9O405F+x/0WnlegziP8p3hSncqakGT3mFwPhSiJ+iFo+IWxvwbHVEv3URY4NxnSJIzR4FHwUTZcjIkpfgg71p1UeImvEkLPeZ/jgHMd0kSgZnjV+sIy6052UhCV0Cbv5R7dBwDz7aMKT1TYrdTZM4pfT2zK73LOaSIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T978x4Ru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T978x4Ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDAE1F000E9;
	Tue,  7 Jul 2026 21:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783458686;
	bh=esnEuxpHj4sSs2t/OocLg1tgrPkI1FYSHz19YYhx8r4=;
	h=Date:To:From:Subject;
	b=T978x4RuiE2vlwaoR4J7rgDHGiJurhCakJQmpD8pklyAMRK1TWC+jRZIS1SmaJSm9
	 BnrN+eFt8EYFR+BzDaL1/vg5EY9g1Pk/e7mHR7AZMDcz8OtN9bw8g28q153g0/wkZL
	 4aliDRwS3bNo7F3KT73xF555991J4yCm40ezbDEI=
Date: Tue, 07 Jul 2026 14:11:26 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-make-force_cpu-redirect-work-from-an-nmi.patch added to mm-nonmm-unstable branch
Message-Id: <20260707211126.9DDAE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: make force_cpu redirect work from an NMI
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-make-force_cpu-redirect-work-from-an-nmi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-make-force_cpu-redirect-work-from-an-nmi.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Bradley Morgan <include@grrlz.net>
Subject: panic: make force_cpu redirect work from an NMI
Date: Tue, 7 Jul 2026 20:59:21 +0000

nmi_panic sets panic_cpu first.  Bail only on a different owner, and hand
panic_cpu to the target after the IPI.

Found by sashiko [1].

Link: https://lore.kernel.org/20260707205921.15247-1-include@grrlz.net
Link: https://sashiko.dev/#/patchset/20260707183253.9793-1-include@grrlz.net [1]
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/panic.c~panic-make-force_cpu-redirect-work-from-an-nmi
+++ a/kernel/panic.c
@@ -396,8 +396,8 @@ static bool panic_try_force_cpu(const ch
 		return false;
 	}
 
-	/* Another panic already in progress */
-	if (panic_in_progress())
+	/* Bail only if a different CPU is already handling it. */
+	if (panic_in_progress() && atomic_read(&panic_cpu) != this_cpu)
 		return false;
 
 	/* Which CPU won the race? */
@@ -440,6 +440,9 @@ static bool panic_try_force_cpu(const ch
 		return false;
 	}
 
+	/* Hand panic_cpu to the target so it wins its own panic_try_start. */
+	atomic_set(&panic_cpu, panic_force_cpu);
+
 	/* IPI/NMI sent, this CPU should stop */
 	return true;
 }
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch
reboot-use-a-lookup-table-for-hw_protection_action-strings.patch
panic-stop-cpus-that-lose-the-panic_redirect_cpu-race.patch
panic-make-force_cpu-redirect-work-from-an-nmi.patch

