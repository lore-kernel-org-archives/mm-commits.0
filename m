Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E0536F915;
	Thu, 27 Aug 2026 04:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787804912; cv=none; b=JJQj2VMbZgf7Uzolghoqt00AdQJNdl4uRXKJEvzBOWfGceUrv+zIGyyzuWrW65s1Y4fxFgVEjn1UXpF6/K23+r/EPfX/buHwXHoCtL61KoBS5YyYSNKnb8xRrRJSOuDClR7RayPsjYLAmE0nJjVkidCzyKKMYe2k5B4bfiyQz/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787804912; c=relaxed/simple;
	bh=xyaJQFMX64NE0fQPeOs6YcPoLcOTNqOsPrTJQ29j1IU=;
	h=Date:To:From:Subject:Message-Id; b=Eudx8F/8Njh7uU5UZMt61H29NC1dbOo5tc9DRDKnfqE16iZCA52DvccUGhdHgsu4GtPCO1mgI0ic3sUKX2YNnL8S0PwUFlJNXBq+zu2p1vTwTf4H8OEr50h3Dhyo1MjiEarizXlWaNWbyKO3SGuVpYNKtyFmrANvAoFHFbHTKgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=clzflJQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="clzflJQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5B21F000E9;
	Thu, 27 Aug 2026 04:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787804910;
	bh=cEmfQx0GIdLmQUNDrS4RoFXHd18+tiRb8JE2ZPVSGuc=;
	h=Date:To:From:Subject;
	b=clzflJQCR4t8O0JC3FFOKsVhGs5guz4vpvus23UMTTCZfYXjG784CPf43/KsZYGBF
	 jDYgoTh6CeLI5Ugv9GV5VMlAsbkZbOaS803X+y4eoo83/NJaW526PgSBhe+aLdAgTf
	 y5th+kKv1vugPiOeJLZlrRkOuCCQ8qmvHT16cof0=
Date: Wed, 26 Aug 2026 21:28:30 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,samitolvanen@google.com,petr.pavlu@suse.com,mcgrof@kernel.org,brads@mainlining.org,atomlin@atomlin.com,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-fix-lost-error-code-from-codetag_load_module.patch added to mm-hotfixes-unstable branch
Message-Id: <20260827042830.7F5B21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: fix lost error code from codetag_load_module()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     module-fix-lost-error-code-from-codetag_load_module.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-fix-lost-error-code-from-codetag_load_module.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hao Ge <hao.ge@linux.dev>
Subject: module: fix lost error code from codetag_load_module()
Date: Thu, 27 Aug 2026 11:05:03 +0800

If codetag_load_module() fails, err is not set to reflect the failure
and load_module() returns 0 after the module has been torn down.

Also, if the module is a livepatch, mod->klp_info allocated by
copy_module_elf() leaks on this error path.  Free it via a new
livepatch_cleanup label.

Link: https://lore.kernel.org/20260827030503.49171-1-hao.ge@linux.dev
Fixes: 044d2aee6c57 ("alloc_tag: handle module codetag load errors as module load failures")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module/main.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/module/main.c~module-fix-lost-error-code-from-codetag_load_module
+++ a/kernel/module/main.c
@@ -3568,8 +3568,9 @@ static int load_module(struct load_info
 			goto sysfs_cleanup;
 	}
 
-	if (codetag_load_module(mod))
-		goto sysfs_cleanup;
+	err = codetag_load_module(mod);
+	if (err)
+		goto livepatch_cleanup;
 
 	/* Get rid of temporary copy. */
 	free_copy(info, flags);
@@ -3579,6 +3580,9 @@ static int load_module(struct load_info
 
 	return do_init_module(mod);
 
+ livepatch_cleanup:
+	if (is_livepatch_module(mod))
+		free_module_elf(mod);
  sysfs_cleanup:
 	mod_sysfs_teardown(mod);
  coming_cleanup:
_

Patches currently in -mm which might be from hao.ge@linux.dev are

module-fix-lost-error-code-from-codetag_load_module.patch
alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch
alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch

