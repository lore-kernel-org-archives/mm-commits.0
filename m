From: akpm@linux-foundation.org
Subject: [merged] fs-fscache-statsc-fix-memory-leak.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:51 -0700
Message-ID: <20130430184351.8A0745A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39975 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3D3Snw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:52 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so84513yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anurup.m@huawei.com, dhowells@redhat.com, lizefan@huawei.com, nataraj.m@huawei.com, sanil.kumar@huawei.com, shyju.pv@huawei.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fscache/stats.c: fix memory leak
has been removed from the -mm tree.  Its filename was
     fs-fscache-statsc-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anurup m <anurup.m@huawei.com>
Subject: fs/fscache/stats.c: fix memory leak

There is a kernel memory leak observed when the proc file
/proc/fs/fscache/stats is read.

The reason is that in fscache_stats_open, single_open is called and the
respective release function is not called during release.  Hence fix with
correct release function - single_release().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=57101

Signed-off-by: Anurup m <anurup.m@huawei.com>
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

origin.patch

