From: akpm@linux-foundation.org
Subject: + iov_iter-fix-out-of-bound-access-in-iov_iter_advance.patch
 tentatively added to -mm tree
Date: Fri, 01 Apr 2016 12:20:15 -0700
Message-ID: <56fec9ef.F1E9ENIt5liJ7Lp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbcDATUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2016 15:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, jslaby@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/iov_iter.c: fix out-of-bound access in iov_iter_advance()
has been added to the -mm tree.  Its filename is
     iov_iter-fix-out-of-bound-access-in-iov_iter_advance.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iov_iter-fix-out-of-bound-access-in-iov_iter_advance.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iov_iter-fix-out-of-bound-access-in-iov_iter_advance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: lib/iov_iter.c: fix out-of-bound access in iov_iter_advance()

Currently, iov_iter_advance() just calls iterate_and_advance() macro as
is, even if size=0 is passed.  Usually it is OK to pass size=0 to the
macro.  However, when the iov_iter has been already advanced to the end of
the array, it may lead to an out-of-bound access, since the macro always
reads the length of the vector at first.  This bug is actually seen via
KASAN with net tun driver, for example.

  BUG: KASAN: stack-out-of-bounds in iov_iter_advance+0x510/0x540 at addr ffff88003d5efd40
  Read of size 8 by task syz-executor/22356
  page:ffffea0000f57bc0 count:0 mapcount:0 mapping:          (null) index:0x0
  flags: 0x1fffff80000000()
  page dumped because: kasan: bad access detected
  CPU: 0 PID: 22356 Comm: syz-executor Tainted: G        W   E      4.4.6-0-default #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20151112_172657-sheep25 04/01/2014
   0000000000000000 ffff88003d5ef9d0 ffffffff819f42c1 ffff88003d5efa68
   ffff88003d5efd40 0000000000000000 ffff88003d5efd38 ffff88003d5efa58
   ffffffff815f7267 000000000000000a ffff88003d5efad8 0000000000000296
  Call Trace:
   [<ffffffff819f42c1>] ? dump_stack+0xb3/0x112
   [<ffffffff815f7267>] ? kasan_report_error+0x507/0x540
   [<ffffffff8157359f>] ? __might_fault+0x3f/0x50
   [<ffffffff815f73d3>] ? __asan_report_load8_noabort+0x43/0x50
   [<ffffffff81a30660>] ? iov_iter_advance+0x510/0x540
   [<ffffffff81a30660>] ? iov_iter_advance+0x510/0x540
   [<ffffffffa0e08c15>] ? tun_get_user+0x745/0x21a0 [tun]
   [<ffffffff812791f0>] ? debug_check_no_locks_freed+0x290/0x290
   [<ffffffffa0e084d0>] ? tun_select_queue+0x370/0x370 [tun]
   [<ffffffff81329559>] ? futex_wake+0x149/0x420
   [<ffffffff812c9027>] ? debug_lockdep_rcu_enabled+0x77/0x90
   [<ffffffffa0e03895>] ? __tun_get+0x5/0x220 [tun]
   [<ffffffffa0e039b1>] ? __tun_get+0x121/0x220 [tun]
   [<ffffffffa0e0a88a>] ? tun_chr_write_iter+0xda/0x190 [tun]
   [<ffffffff8164841a>] ? __vfs_write+0x30a/0x480
   [<ffffffff81648110>] ? vfs_iter_write+0x320/0x320
   [<ffffffff812c9027>] ? debug_lockdep_rcu_enabled+0x77/0x90
   [<ffffffff818c1448>] ? common_file_perm+0x158/0x7a0
   [<ffffffff818c1cb7>] ? apparmor_file_permission+0x27/0x30
   [<ffffffff81648fa5>] ? rw_verify_area+0x105/0x2f0
   [<ffffffff8164960c>] ? vfs_write+0x16c/0x4a0
   [<ffffffff8164c29a>] ? SyS_write+0x11a/0x230

This patch adds the proper check of the size to iov_iter_advance(), like
all other functions calling iterate_and_advance() macro.

We can put these checks in iterate_and_advance(), too.  I chose this patch
since it's smaller, and doing in the macro will be a bit ugly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Jiri Slaby <jslaby@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/iov_iter.c~iov_iter-fix-out-of-bound-access-in-iov_iter_advance lib/iov_iter.c
--- a/lib/iov_iter.c~iov_iter-fix-out-of-bound-access-in-iov_iter_advance
+++ a/lib/iov_iter.c
@@ -508,6 +508,10 @@ EXPORT_SYMBOL(iov_iter_copy_from_user_at
 
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
+	if (unlikely(size > i->count))
+		size = i->count;
+	if (unlikely(!size))
+		return;
 	iterate_and_advance(i, size, v, 0, 0, 0)
 }
 EXPORT_SYMBOL(iov_iter_advance);
_

Patches currently in -mm which might be from tiwai@suse.de are

iov_iter-fix-out-of-bound-access-in-iov_iter_advance.patch

