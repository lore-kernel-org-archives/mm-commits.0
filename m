From: akpm@linux-foundation.org
Subject: + drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch added to -mm tree
Date: Wed, 13 Jan 2010 12:54:31 -0800
Message-ID: <201001132054.o0DKsVJ4027871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524Ab0AMUym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 15:54:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, gregkh@suse.de, zbr@ioremap.net


The patch titled
     drivers/staging/pohmelfs/inode.c: remove uses of NIPQUAD, use %pI4
has been added to the -mm tree.  Its filename is
     drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch

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
Subject: drivers/staging/pohmelfs/inode.c: remove uses of NIPQUAD, use %pI4
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/pohmelfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/staging/pohmelfs/inode.c~drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4 drivers/staging/pohmelfs/inode.c
--- a/drivers/staging/pohmelfs/inode.c~drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4
+++ a/drivers/staging/pohmelfs/inode.c
@@ -1767,8 +1767,7 @@ static int pohmelfs_show_stats(struct se
 		seq_printf(m, "%u ", ctl->idx);
 		if (ctl->addr.sa_family == AF_INET) {
 			struct sockaddr_in *sin = (struct sockaddr_in *)&st->ctl.addr;
-			/* seq_printf(m, "%pi4:%u", &sin->sin_addr.s_addr, ntohs(sin->sin_port)); */
-			seq_printf(m, "%u.%u.%u.%u:%u", NIPQUAD(sin->sin_addr.s_addr), ntohs(sin->sin_port));
+			seq_printf(m, "%pI4:%u", &sin->sin_addr.s_addr, ntohs(sin->sin_port));
 		} else if (ctl->addr.sa_family == AF_INET6) {
 			struct sockaddr_in6 *sin = (struct sockaddr_in6 *)&st->ctl.addr;
 			seq_printf(m, "%pi6:%u", &sin->sin6_addr, ntohs(sin->sin6_port));
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch

