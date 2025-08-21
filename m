Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3641A9F9F
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 00:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755736325; cv=none; b=qkdjkviRE0Jb8V9r80fOTZ02qlxmPY+IamSxgrF+expA7Ed4YXHZ8uoLqnhFqaPbyYK6IlKz7/ae3c9cSgma5yArlaquX05waR5VeObfO1zT2QsdPlJZ6bE6Uz/8xFQZUTW7rgzZjGuV2NN71vsF/hCcTUlr5QfTHbKMhnNktXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755736325; c=relaxed/simple;
	bh=ApPYkpOBri4x+oySenKx9EUdazt7inkwhndXF9FejFo=;
	h=Date:To:From:Subject:Message-Id; b=eCSlc3P1LmjFxPoMJKRvEnbQKP3wLMQGPAlOkAWMrJ2XSvHJBTaVWHCvp+nwgSn9UAYtUI2CO5m1pn75F6iOOcxe/oVZzI8lCUCBg/6hzKE1cj62OOhYNUwQ+o2SSVL1I4SYQzzbw8+IPawYcVWFwTpPspp49stHk3Mw78DpyEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ddI4Ctja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ddI4Ctja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A05C4CEE7;
	Thu, 21 Aug 2025 00:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755736325;
	bh=ApPYkpOBri4x+oySenKx9EUdazt7inkwhndXF9FejFo=;
	h=Date:To:From:Subject:From;
	b=ddI4CtjahhaWTsASe27RQJ9//YpMrUodnKmTQOvCUmPBbOaWK6qOTD8Rcn+6RWUfy
	 +tBE6HibvhkfaRwetW9nF7m+tGrT6tMYXbUuR5KFsk4NrXIN9tuv53S/edok/GkD/Y
	 23KmVpGOUpr0iS7ChUc9FRcVePvLnclRtmDawHkg=
Date: Wed, 20 Aug 2025 17:32:04 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,lkp@intel.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-note-that-panic_print-parameter-is-deprecated-fix-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250821003205.40A05C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: panic: clean up message about deprecated 'panic_print' parameter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-note-that-panic_print-parameter-is-deprecated-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-note-that-panic_print-parameter-is-deprecated-fix-fix.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: fixup: panic: clean up message about deprecated 'panic_print' parameter
Date: Wed, 20 Aug 2025 11:25:31 +0200

fix build

Link: https://lkml.kernel.org/r/aKWWcPOf9qPIoCe4@pathway.suse.cz
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508200907.PsZ3geub-lkp@intel.com/
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/panic.c~panic-add-note-that-panic_print-parameter-is-deprecated-fix-fix
+++ a/kernel/panic.c
@@ -77,6 +77,11 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
 #ifdef CONFIG_SYSCTL
 
 /*
@@ -122,11 +127,6 @@ static int proc_taint(const struct ctl_t
 	return err;
 }
 
-static void panic_print_deprecated(void)
-{
-	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
-}
-
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
_

Patches currently in -mm which might be from lance.yang@linux.dev are

panic-add-note-that-panic_print-parameter-is-deprecated-fix-fix.patch

