From: akpm@linux-foundation.org
Subject: [merged] ucount-mark-user_header-with-kmemleak_ignore.patch
 removed from -mm tree
Date: Tue, 14 Feb 2017 13:44:34 -0800
Message-ID: <58a37a42.GIHv3QNM/D63nOs+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755849AbdBNVog (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 16:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, ebiederm@xmission.com, jack@suse.cz, keescook@chromium.org, n.borisov.lkml@gmail.com, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/ucount.c: mark user_header with kmemleak_ignore()
has been removed from the -mm tree.  Its filename was
     ucount-mark-user_header-with-kmemleak_ignore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kernel/ucount.c: mark user_header with kmemleak_ignore()

The user_header gets caught by kmemleak with the following splat as
missing a free:

unreferenced object 0xffff99667a733d80 (size 96):
  comm "swapper/0", pid 1, jiffies 4294892317 (age 62191.468s)
  hex dump (first 32 bytes):
    a0 b6 92 b4 ff ff ff ff 00 00 00 00 01 00 00 00  ................
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffffb3a5f7ea>] kmemleak_alloc+0x4a/0xa0
    [<ffffffffb36050d4>] __kmalloc+0x144/0x260
    [<ffffffffb36a7144>] __register_sysctl_table+0x54/0x5e0
    [<ffffffffb36a76eb>] register_sysctl+0x1b/0x20
    [<ffffffffb416fe17>] user_namespace_sysctl_init+0x17/0x34
    [<ffffffffb3402192>] do_one_initcall+0x52/0x1a0
    [<ffffffffb414d1bd>] kernel_init_freeable+0x173/0x200
    [<ffffffffb3a5c23e>] kernel_init+0xe/0x100
    [<ffffffffb3a6b57c>] ret_from_fork+0x2c/0x40
    [<ffffffffffffffff>] 0xffffffffffffffff

The BUG_ON()s are intended to crash so no need to clean up after ourselves
on error there.  This is also a kernel/ subsys_init() we don't need a
respective exit call here as this is never modular, so just white list it.

Link: http://lkml.kernel.org/r/20170203211404.31458-1-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/ucount.c~ucount-mark-user_header-with-kmemleak_ignore kernel/ucount.c
--- a/kernel/ucount.c~ucount-mark-user_header-with-kmemleak_ignore
+++ a/kernel/ucount.c
@@ -227,11 +227,10 @@ static __init int user_namespace_sysctl_
 	 * properly.
 	 */
 	user_header = register_sysctl("user", empty);
+	kmemleak_ignore(user_header);
 	BUG_ON(!user_header);
 	BUG_ON(!setup_userns_sysctls(&init_user_ns));
 #endif
 	return 0;
 }
 subsys_initcall(user_namespace_sysctl_init);
-
