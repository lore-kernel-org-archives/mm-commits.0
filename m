From: akpm@linux-foundation.org
Subject: - discuss-a-couple-common-errors-in-kernel-doc-usage.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:53:43 -0800
Message-ID: <200702112253.l1BMrhfR016122@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60422 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932841AbXBKWyA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:54:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Discuss a couple common errors in kernel-doc usage.
has been removed from the -mm tree.  Its filename was
     discuss-a-couple-common-errors-in-kernel-doc-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Discuss a couple common errors in kernel-doc usage.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Explain a couple of the most common errors in kernel-doc usage.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |   37 +++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~discuss-a-couple-common-errors-in-kernel-doc-usage Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~discuss-a-couple-common-errors-in-kernel-doc-usage
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -107,10 +107,14 @@ The format of the block comment is like 
  * (section header: (section description)? )*
 (*)?*/
 
-The short function description cannot be multiline, but the other
-descriptions can be (and they can contain blank lines). Avoid putting a
-spurious blank line after the function name, or else the description will
-be repeated!
+The short function description ***cannot be multiline***, but the other
+descriptions can be (and they can contain blank lines).  If you continue
+that initial short description onto a second line, that second line will
+appear further down at the beginning of the description section, which is
+almost certainly not what you had in mind.
+
+Avoid putting a spurious blank line after the function name, or else the
+description will be repeated!
 
 All descriptive text is further processed, scanning for the following special
 patterns, which are highlighted appropriately.
@@ -121,6 +125,31 @@ patterns, which are highlighted appropri
 '@parameter' - name of a parameter
 '%CONST' - name of a constant.
 
+NOTE 1:  The multi-line descriptive text you provide does *not* recognize
+line breaks, so if you try to format some text nicely, as in:
+
+  Return codes
+    0 - cool
+    1 - invalid arg
+    2 - out of memory
+
+this will all run together and produce:
+
+  Return codes 0 - cool 1 - invalid arg 2 - out of memory
+
+NOTE 2:  If the descriptive text you provide has lines that begin with
+some phrase followed by a colon, each of those phrases will be taken as
+a new section heading, which means you should similarly try to avoid text
+like:
+
+  Return codes:
+    0: cool
+    1: invalid arg
+    2: out of memory
+
+every line of which would start a new section.  Again, probably not
+what you were after.
+
 Take a look around the source tree for examples.
 
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
