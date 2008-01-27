From: akpm@linux-foundation.org
Subject: + hamradio-fix-dmascc-section-mismatch.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:10:01 -0800
Message-ID: <200801270509.m0R59wrI030785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbYA0FKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:10:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, klaus.kudielka@gmx.net, sam@ravnborg.org


The patch titled
     hamradio: fix dmascc section mismatch
has been added to the -mm tree.  Its filename is
     hamradio-fix-dmascc-section-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hamradio: fix dmascc section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

hw[] is used in both init and exit functions so it cannot be initdata (section
mismatch is when CONFIG_MODULES=n and CONFIG_DMASCC=y).

WARNING: vmlinux.o(.exit.text+0xba7): Section mismatch: reference to .init.data: (between 'dmascc_exit' and 'sixpack_exit_driver')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Klaus Kudielka <klaus.kudielka@gmx.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/dmascc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/hamradio/dmascc.c~hamradio-fix-dmascc-section-mismatch drivers/net/hamradio/dmascc.c
--- a/drivers/net/hamradio/dmascc.c~hamradio-fix-dmascc-section-mismatch
+++ a/drivers/net/hamradio/dmascc.c
@@ -262,8 +262,8 @@ static void tm_isr(struct scc_priv *priv
 
 static int io[MAX_NUM_DEVS] __initdata = { 0, };
 
-/* Beware! hw[] is also used in cleanup_module(). */
-static struct scc_hardware hw[NUM_TYPES] __initdata_or_module = HARDWARE;
+/* Beware! hw[] is also used in dmascc_exit(). */
+static struct scc_hardware hw[NUM_TYPES] = HARDWARE;
 
 
 /* Global variables */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
hrtimer-fix-section-mismatch.patch
timer-fix-section-mismatch.patch
rcu-fix-section-mismatch.patch
git-alsa.patch
sound-fix-cs5535-section-mismatch.patch
git-dvb.patch
radio-fix-sf16fmi-section-mismatch.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
scsi-fix-ncr5380-section-mismatch.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
sound-fix-opti9xx-miro-section-mismatch.patch
profile-likely-unlikely-macros.patch
