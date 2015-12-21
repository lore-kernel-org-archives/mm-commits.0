From: akpm@linux-foundation.org
Subject: [merged]
 proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter.patch removed from -mm tree
Date: Mon, 21 Dec 2015 12:24:57 -0800
Message-ID: <56786019.kO0E3CHY2+3WT+Ty%akpm__20749.478651169$1450729510$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbLUUY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2015 15:24:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, keescook@chromium.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix -ESRCH error when writing to /proc/$pid/coredump_filter
has been removed from the -mm tree.  Its filename was
     proc-fix-esrch-error-when-writing-to-proc-pid-coredump_filter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


