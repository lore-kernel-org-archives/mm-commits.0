From: akpm@linux-foundation.org
Subject: [nacked]
 ubsan-dont-handle-misaligned-address-when-support-unaligned-access.patch
 removed from -mm tree
Date: Thu, 04 Jan 2018 16:12:55 -0800
Message-ID: <5a4ec307.UFyPPU3pMUDcXCU/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEAM5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jan 2018 19:12:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingtianhong@huawei.com, aryabinin@virtuozzo.com, David.Laight@ACULAB.COM, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ubsan.c: don't handle misaligned address when kernel supports unaligned access
has been removed from the -mm tree.  Its filename was
     ubsan-dont-handle-misaligned-address-when-support-unaligned-access.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Ding Tianhong <dingtianhong@huawei.com>
Subject: lib/ubsan.c: don't handle misaligned address when kernel supports unaligned access

ubsan reports a warning like:

UBSAN: Undefined behaviour in ../include/linux/etherdevice.h:386:9
load of misaligned address ffffffc069ba0482 for type 'long unsigned int'
which requires 8 byte alignment
CPU: 0 PID: 901 Comm: sshd Not tainted 4.xx+ #1
Hardware name: linux,dummy-virt (DT)
Call trace:
[<ffffffc000093600>] dump_backtrace+0x0/0x348
[<ffffffc000093968>] show_stack+0x20/0x30
[<ffffffc001651664>] dump_stack+0x144/0x1b4
[<ffffffc0016519b0>] ubsan_epilogue+0x18/0x74
[<ffffffc001651bac>] __ubsan_handle_type_mismatch+0x1a0/0x25c
[<ffffffc00125d8a0>] dev_gro_receive+0x17d8/0x1830
[<ffffffc00125d928>] napi_gro_receive+0x30/0x158
[<ffffffc000f4f93c>] virtnet_receive+0xad4/0x1fa8

The reason is that when enabling the CONFIG_UBSAN_ALIGNMENT, ubsan will
report the unaligned access even if the system supports it
(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y).  This produces a lot of noise
in the log and causes confusion.

Prevent the detection of unaligned access when the system support
unaligned access.

[dingtianhong@huawei.com: add braces around if block]
Link: http://lkml.kernel.org/r/5b905d56-609e-3822-096a-3b93b3eb7675@huawei.com
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN lib/ubsan.c~ubsan-dont-handle-misaligned-address-when-support-unaligned-access lib/ubsan.c
--- a/lib/ubsan.c~ubsan-dont-handle-misaligned-address-when-support-unaligned-access
+++ a/lib/ubsan.c
@@ -321,9 +321,10 @@ void __ubsan_handle_type_mismatch(struct
 
 	if (!ptr)
 		handle_null_ptr_deref(data);
-	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment))
-		handle_missaligned_access(data, ptr);
-	else
+	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment)) {
+		if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
+			handle_missaligned_access(data, ptr);
+	} else
 		handle_object_size_mismatch(data, ptr);
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch);
_

Patches currently in -mm which might be from dingtianhong@huawei.com are


