From: akpm@linux-foundation.org
Subject: + configure-out-aio-support-fix.patch added to -mm tree
Date: Wed, 17 Sep 2008 14:30:48 -0700
Message-ID: <200809172130.m8HLUmSk031430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225AbYIQVbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:31:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mpm@selenic.com, thomas.petazzoni@free-electrons.com


The patch titled
     aio: fix sysctl build error
has been added to the -mm tree.  Its filename is
     configure-out-aio-support-fix.patch

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
Subject: aio: fix sysctl build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Put aio_nr sysctl inside ifdef CONFIG_AIO block to fix this build error:

kernel/built-in.o:(.data+0x2a2c): undefined reference to `aio_nr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~configure-out-aio-support-fix kernel/sysctl.c
--- a/kernel/sysctl.c~configure-out-aio-support-fix
+++ a/kernel/sysctl.c
@@ -1336,6 +1336,7 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &two,
 	},
 #endif
+#ifdef CONFIG_AIO
 	{
 		.procname	= "aio-nr",
 		.data		= &aio_nr,
@@ -1343,7 +1344,6 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0444,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
-#ifdef CONFIG_AIO
 	{
 		.procname	= "aio-max-nr",
 		.data		= &aio_max_nr,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-allow-structs-whose-members-are-all-private.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
drivers-net-hp-plusc-fix-build-error.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

