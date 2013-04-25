From: akpm@linux-foundation.org
Subject: + fs-fscache-statsc-fix-memory-leak.patch added to -mm tree
Date: Thu, 25 Apr 2013 13:27:52 -0700
Message-ID: <20130425202752.DD12C5A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:34611 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3DYU1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Apr 2013 16:27:55 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so363046yen.2
        for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2013 13:27:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anurup.m@huawei.com, dhowells@redhat.com, lizefan@huawei.com, nataraj.m@huawei.com, sanil.kumar@huawei.com, shyju.pv@huawei.com, stable@vger.kernel.org


The patch titled
     Subject: fs/fscache/stats.c: fix memory leak
has been added to the -mm tree.  Its filename is
     fs-fscache-statsc-fix-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anurup m <anurup.m@huawei.com>
Subject: fs/fscache/stats.c: fix memory leak

There is a kernel memory leak observed when the proc file
/proc/fs/fscache/stats is read.

The reason is that in fscache_stats_open, single_open is called and the
respective release function is not called during release.  Hence fix with
correct release function - single_release().

Cc: shyju pv <shyju.pv@huawei.com>
Cc: Sanil kumar <sanil.kumar@huawei.com>
Cc: Nataraj m <nataraj.m@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fscache/stats.c~fs-fscache-statsc-fix-memory-leak fs/fscache/stats.c
--- a/fs/fscache/stats.c~fs-fscache-statsc-fix-memory-leak
+++ a/fs/fscache/stats.c
@@ -287,5 +287,5 @@ const struct file_operations fscache_sta
 	.open		= fscache_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release        = single_release,
 };
_

Patches currently in -mm which might be from anurup.m@huawei.com are

fs-fscache-statsc-fix-memory-leak.patch

