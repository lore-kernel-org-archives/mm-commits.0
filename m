Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4C6156C40;
	Tue,  7 Jan 2025 02:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736216883; cv=none; b=cf6zC3hZpj9p4ytZR5LWy3P2jjvkT5tSNC2qOUifGNHKD7kVm1EUhVa+VRbaN9h6NbknNrmcxbCbf/B2kv2al/k7pyVb8/LeKtlQb+zrI1h5IOVRzIhxUtxiV4SfaLIgdFlUJTVsWuuydqpL7PEyigmSq3FSX5svDvFS+FrF/gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736216883; c=relaxed/simple;
	bh=t5wBGF+XMuBmDVXwbAdb40RjcZfC0/TJhgXtSMbdfUg=;
	h=Date:To:From:Subject:Message-Id; b=aY95drYcdbhGf2EQrAmTFomo7nM7XcHAiD2HQlSt/QMTUQGIZ7wTBF3+qzqcFmc9A5hIz3yeWPJ/oII/qGQxiHZdpYp4bizl5Yx+LN671LbVy6lUSPEyEZIOk4iX6I4EYOoahp8YML7vAJx0/DZSpbi2f0CP2Q19YTjbVf04px0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bXQcuwL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bXQcuwL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C61C4CEDD;
	Tue,  7 Jan 2025 02:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736216883;
	bh=t5wBGF+XMuBmDVXwbAdb40RjcZfC0/TJhgXtSMbdfUg=;
	h=Date:To:From:Subject:From;
	b=bXQcuwL9BrmtrqHc35HJZxIQokpKv89Il/oXBvXk9Ei1/p+J2k+M7xZOZmQen5J/i
	 xQX0iOBt/8yLnPGP/oI2v9oulkBzG6pTH+wRTb6j7HIjR7SMwo3ctHOLkCKTIAzleE
	 /pQ1cR03t6iIoIvu12o/+g/KmIzfO7Nvjm0P/mR0=
Date: Mon, 06 Jan 2025 18:28:02 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,koichiro.den@canonical.com,greg@kroah.com,bp@alien8.de,bigeasy@linutronix.de,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch added to mm-hotfixes-unstable branch
Message-Id: <20250107022802.E7C61C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: revert "vmstat: disable vmstat_work on vmstat_cpu_down_prep()"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "vmstat: disable vmstat_work on vmstat_cpu_down_prep()"
Date: Mon Jan  6 06:24:12 PM PST 2025

Revert adcfb264c3ed ("vmstat: disable vmstat_work on
vmstat_cpu_down_prep()") due to "workqueue: work disable count
underflowed" WARNings.

Fixes: adcfb264c3ed ("vmstat: disable vmstat_work on vmstat_cpu_down_prep()") 
Reported-by: Borislav Petkov <bp@alien8.de>
Reported-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Koichiro Den <koichiro.den@canonical.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmstat.c~revert-vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep
+++ a/mm/vmstat.c
@@ -2148,14 +2148,13 @@ static int vmstat_cpu_online(unsigned in
 	if (!node_state(cpu_to_node(cpu), N_CPU)) {
 		node_set_state(cpu_to_node(cpu), N_CPU);
 	}
-	enable_delayed_work(&per_cpu(vmstat_work, cpu));
 
 	return 0;
 }
 
 static int vmstat_cpu_down_prep(unsigned int cpu)
 {
-	disable_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+	cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

