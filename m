From: akpm@linux-foundation.org
Subject: + hfsplus-missing-o_largefile-check.patch added to -mm tree
Date: Tue, 23 Sep 2008 10:42:56 -0700
Message-ID: <200809231742.m8NHgupZ012763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYIWRn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 13:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, did447@gmail.com, zippel@linux-m68k.org


The patch titled
     hfsplus: missing O_LARGEFILE check
has been added to the -mm tree.  Its filename is
     hfsplus-missing-o_largefile-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: missing O_LARGEFILE check
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

hfsplus: O_LARGEFILE checking is missing

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=8490

Reported-by: didier <did447@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hfsplus/inode.c~hfsplus-missing-o_largefile-check fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-missing-o_largefile-check
+++ a/fs/hfsplus/inode.c
@@ -254,6 +254,8 @@ static int hfsplus_file_open(struct inod
 {
 	if (HFSPLUS_IS_RSRC(inode))
 		inode = HFSPLUS_I(inode).rsrc_inode;
+	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
+		return -EOVERFLOW;
 	atomic_inc(&HFSPLUS_I(inode).opencnt);
 	return 0;
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_sil680-convert-config_ppc_merge-to-config_ppc.patch
nec-fix-rmmod-platform-driver-improvements.patch
nec-fix-suspend-and-resume-for-isa-pnp-cards.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
serial-allow-8250-to-be-used-on-sparc.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
hfsplus-missing-o_largefile-check.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
tty-fix-loss-of-echoed-characters.patch
tty-minor-code-efficiency-and-style-cleanup.patch
tty-fix-echo-tab-erase-and-locking.patch
tty-fix-echo-tab-erase-and-locking-fix.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
char-moxac-sparse-annotation.patch

