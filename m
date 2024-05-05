Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EE77580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942876; cv=none; b=PTGBZgBLjZqXsjuN/QS74IZpfEQWyOsKVR/XEJgeGla5MXjF5fkJnXCFfNT475Y5L2pdBLUCRp+NB7kRLsKtNf3gb6RfOAwFueriy+s616jmz5eJfCVzEj189RVBf8ziOx9AiynkwZJ12Tg7VGtSFfLI6UXOZkX669CAhb9MrzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942876; c=relaxed/simple;
	bh=CZrzlEot8xjPx4/O1isRzGnPInsuG06bjRdRDn3SiEE=;
	h=Date:To:From:Subject:Message-Id; b=AZ1J2lRDrRH2JEiarUUyL5Ge9/aoAv3TxG/qyPRAxKOOLaALu6jR0kmNBkzSLtJwq9GZHC4PLwVSX9unn6Rhf+LWcIJRQOyit+xqpOi0iIiZ6VGBde+hdeLXRMl4M9Gave7W8Ib7epn9eCAUJCxXX8zrAFmFdm9Wk/EbiO8qSJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vJhMeRuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vJhMeRuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427D8C113CC;
	Sun,  5 May 2024 21:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942876;
	bh=CZrzlEot8xjPx4/O1isRzGnPInsuG06bjRdRDn3SiEE=;
	h=Date:To:From:Subject:From;
	b=vJhMeRuzi2J681yQCLgXq4dSWGZiVxs/XBzmOeIuTofGIu+7K56aRFY+ulkZ5Jjyq
	 800TkA0ID+hpSB44AEzfCX07Tm3KutQIoEDGl7mIX4MyKEGn565VtWlPNkOtbRp8NC
	 MZkRZPs+wyKmtDXuhxu2hdXAjA9AkWzumiJVcACs=
Date: Sun, 05 May 2024 14:01:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,song@kernel.org,peterz@infradead.org,lkp@intel.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240505210116.427D8C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix
Date: Sat May  4 03:39:48 PM PDT 2024

fix kerneldoc

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405040851.2EgypmL1-lkp@intel.com/ 
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/watchdog_perf.c~watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix
+++ a/kernel/watchdog_perf.c
@@ -277,6 +277,8 @@ int __init watchdog_hardlockup_probe(voi
 
 /**
  * hardlockup_config_perf_event - Overwrite config of wd_hw_attr.
+ *
+ * @str: number which identifies the raw perf event to use
  */
 void __init hardlockup_config_perf_event(const char *str)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch
kernel-watchdog_perfc-tidy-up-kerneldoc.patch

