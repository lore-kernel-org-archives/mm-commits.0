From: akpm@linux-foundation.org
Subject: +
 proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter.patch added
 to -mm tree
Date: Fri, 11 Dec 2015 14:40:16 -0800
Message-ID: <566b50d0.UUkzICwXTtRPgLvK%akpm__38778.1117963188$1449873637$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbbLKWkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 17:40:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, keescook@chromium.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix -ESRCH error when writing to /proc/$pid/coredump_filter
has been added to the -mm tree.  Its filename is
     proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: proc: fix -ESRCH error when writing to /proc/$pid/coredump_filter

echo 0 > /proc/self/coredump_filter
bash: echo: write error: No such process

Writing to /proc/$pid/coredump_filter always returns -ESRCH because commit
774636e19ed51 ("proc: convert to kstrto*()/kstrto*_from_user()") removed
the setting of ret after the get_proc_task call and incorrectly left it as
-ESRCH.  Instead, return 0 when successful.

Fixes: 774636e19ed51 ("proc: convert to kstrto*()/kstrto*_from_user()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org> [4.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/base.c~proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter
+++ a/fs/proc/base.c
@@ -2494,6 +2494,7 @@ static ssize_t proc_coredump_filter_writ
 	mm = get_task_mm(task);
 	if (!mm)
 		goto out_no_mm;
+	ret = 0;
 
 	for (i = 0, mask = 1; i < MMF_DUMP_FILTER_BITS; i++, mask <<= 1) {
 		if (val & mask)
_

Patches currently in -mm which might be from colin.king@canonical.com are

proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter.patch

