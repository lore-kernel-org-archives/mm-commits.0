From: akpm@linux-foundation.org
Subject: + kexec-return-efault-on-copy_to_user-failures.patch added to -mm tree
Date: Thu, 29 Jul 2010 12:25:48 -0700
Message-ID: <201007291925.o6TJPm3f028977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078Ab0G2T0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 15:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com, seto.hidetoshi@jp.fujitsu.com, simon.kagstrom@netinsight.net, xiyou.wangcong@gmail.com


The patch titled
     kexec: return -EFAULT on copy_to_user() failures
has been added to the -mm tree.  Its filename is
     kexec-return-efault-on-copy_to_user-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: return -EFAULT on copy_to_user() failures
From: Dan Carpenter <error27@gmail.com>

copy_to/from_user() returns the number of bytes remaining to be copied. 
It never returns a negative value.  The correct return code is -EFAULT and
not -EIO.

All the callers check for non-zero returns so that's Ok, but the return
code is passed to the user so we should fix this.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/kexec.c~kexec-return-efault-on-copy_to_user-failures kernel/kexec.c
--- a/kernel/kexec.c~kexec-return-efault-on-copy_to_user-failures
+++ a/kernel/kexec.c
@@ -151,8 +151,10 @@ static int do_kimage_alloc(struct kimage
 	image->nr_segments = nr_segments;
 	segment_bytes = nr_segments * sizeof(*segments);
 	result = copy_from_user(image->segment, segments, segment_bytes);
-	if (result)
+	if (result) {
+		result = -EFAULT;
 		goto out;
+	}
 
 	/*
 	 * Verify we have good destination addresses.  The caller is
@@ -827,7 +829,7 @@ static int kimage_load_normal_segment(st
 		result = copy_from_user(ptr, buf, uchunk);
 		kunmap(page);
 		if (result) {
-			result = (result < 0) ? result : -EIO;
+			result = -EFAULT;
 			goto out;
 		}
 		ubytes -= uchunk;
@@ -882,7 +884,7 @@ static int kimage_load_crash_segment(str
 		kexec_flush_icache_page(page);
 		kunmap(page);
 		if (result) {
-			result = (result < 0) ? result : -EIO;
+			result = -EFAULT;
 			goto out;
 		}
 		ubytes -= uchunk;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
autofs4-remove-unneeded-null-check-in-try_to_fill_dentry.patch
cgroups-save-space-for-the-terminator.patch
kexec-return-efault-on-copy_to_user-failures.patch

