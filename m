Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E382430AD1A;
	Thu, 25 Jun 2026 18:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782413052; cv=none; b=rreFVVHCq5jgiJCZxCyRoPpiUK9XGxuR5xD+oYWO0YQpZw51keS1fRovxa7Ud1MABxda5cuGNPhuzTfZeNy/pA5dVb8OAl7O4rxAJJwNAjt/wph0TGD0loaZqcxeTcdJEj8LnzfgelV6n3y7Et0oZjLYojSz0UCKSkNzvo371RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782413052; c=relaxed/simple;
	bh=05WJkETWH/PQgd+TZJ1AYnm6QSrIDt4/Y35Pu6HrrgI=;
	h=Date:To:From:Subject:Message-Id; b=XXRbIh2M2zyOxJqvBeRKwHte9ONIbQBpsWB79fCClPzrSccxgrgntKVPTTgF0tVyaVpWy4NWdKrCxKYb1MjUWqJ0ovv2GYN4mMVKY5S9A0uI916bMcIcwxEs+grZLfC6zA5VOI/sqjQ6NdA8prS9pv/VZxTSENoT3Vc6UIc93Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pDoddv2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pDoddv2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDDE1F00A3A;
	Thu, 25 Jun 2026 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782413050;
	bh=BaDxdIDDOs7OONuaSbWochtZemo1KNTJbOrJnX6zUdM=;
	h=Date:To:From:Subject;
	b=pDoddv2GoYn8NTJegK/aL6a2REPIkpanGNT5xQzmPy1r63wQLk5FXUIddeIL3y+ym
	 kxAMyIrIjr1gwHH224t/KuSeGrAUl+Zvy7JaDuV+iDckj+vN44IibCAP77oUD52pUB
	 Msl1sCQ75svJZ0NpISgVTsv6qswm6qiyFWGrr3Mw=
Date: Thu, 25 Jun 2026 11:44:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,dianders@chromium.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625184410.9FDDE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: use sys_info_with_filter() to avoid duplicate backtraces
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch

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
From: Bradley Morgan <include@grrlz.net>
Subject: panic: use sys_info_with_filter() to avoid duplicate backtraces
Date: Thu, 25 Jun 2026 15:25:58 +0000

panic_other_cpus_shutdown() handles SYS_INFO_ALL_BT before stopping the
other CPUs.  Do not ask sys_info() to handle that bit again later in the
panic path.

Use sys_info_with_filter() so panic_print=all_bt does not request more
output after the CPUs are stopped.

Link: https://lore.kernel.org/20260625152558.7450-5-include@grrlz.net
Fixes: a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on system lockup")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/panic.c~panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces
+++ a/kernel/panic.c
@@ -680,7 +680,7 @@ void vpanic(const char *fmt, va_list arg
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
-	sys_info(panic_print);
+	sys_info_with_filter(panic_print, SYS_INFO_ALL_BT);
 
 	kmsg_dump_desc(KMSG_DUMP_PANIC, buf);
 
_

Patches currently in -mm which might be from include@grrlz.net are

sys_info-add-helper-for-callers-that-print-some-sys_info-on-their-own.patch
watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
lib-string-fix-memchr_inv-for-large-ranges.patch

