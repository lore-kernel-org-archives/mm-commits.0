From: akpm@linux-foundation.org
Subject: - radio-fix-sf16fmi-section-mismatch.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:42 -0800
Message-ID: <200801290148.m0T1mgbV027369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44325 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663AbYA2B70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mchehab@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     radio: fix sf16fmi section mismatch
has been removed from the -mm tree.  Its filename was
     radio-fix-sf16fmi-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-alsa.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
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
profile-likely-unlikely-macros.patch
