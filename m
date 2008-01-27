From: akpm@linux-foundation.org
Subject: + radio-fix-sf16fmi-section-mismatch.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:08:24 -0800
Message-ID: <200801270508.m0R58Lo4030750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbYA0FIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:08:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mchehab@infradead.org, sam@ravnborg.org


The patch titled
     radio: fix sf16fmi section mismatch
has been added to the -mm tree.  Its filename is
     radio-fix-sf16fmi-section-mismatch.patch

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
Subject: radio: fix sf16fmi section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

isapnp_fmi_probe() is only called by fmi_init(), which is __init,
so isapnp_fmi_probe() can also be __init.

media/radio/radio-sf16fmi.c:
WARNING: vmlinux.o(.text+0x994e19): Section mismatch: reference to .init.data: (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')
WARNING: vmlinux.o(.text+0x994e22): Section mismatch: reference to .init.data: (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')
WARNING: vmlinux.o(.text+0x994e3a): Section mismatch: reference to .init.data:id_table (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-sf16fmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/radio/radio-sf16fmi.c~radio-fix-sf16fmi-section-mismatch drivers/media/radio/radio-sf16fmi.c
--- a/drivers/media/radio/radio-sf16fmi.c~radio-fix-sf16fmi-section-mismatch
+++ a/drivers/media/radio/radio-sf16fmi.c
@@ -321,7 +321,7 @@ static struct isapnp_device_id id_table[
 
 MODULE_DEVICE_TABLE(isapnp, id_table);
 
-static int isapnp_fmi_probe(void)
+static int __init isapnp_fmi_probe(void)
 {
 	int i = 0;
 
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
