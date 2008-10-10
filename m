From: akpm@linux-foundation.org
Subject: + taint-fix-kernel-doc.patch added to -mm tree
Date: Fri, 10 Oct 2008 14:13:22 -0700
Message-ID: <200810102113.m9ALDMI6002949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761063AbYJJVNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 17:13:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, andi@firstfloor.org


The patch titled
     taint: fix kernel-doc
has been added to the -mm tree.  Its filename is
     taint-fix-kernel-doc.patch

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
Subject: taint: fix kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Move print_tainted() kernel-doc to avoid the following error:

Error(/var/linsrc/mmotm-2008-1002-1617//kernel/panic.c:155): cannot understand prototype: 'struct tnt '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN kernel/panic.c~taint-fix-kernel-doc kernel/panic.c
--- a/kernel/panic.c~taint-fix-kernel-doc
+++ a/kernel/panic.c
@@ -139,21 +139,6 @@ NORET_TYPE void panic(const char * fmt, 
 
 EXPORT_SYMBOL(panic);
 
-/**
- *	print_tainted - return a string to represent the kernel taint state.
- *
- *  'P' - Proprietary module has been loaded.
- *  'F' - Module has been forcibly loaded.
- *  'S' - SMP with CPUs not designed for SMP.
- *  'R' - User forced a module unload.
- *  'M' - System experienced a machine check exception.
- *  'B' - System has hit bad_page.
- *  'U' - Userspace-defined naughtiness.
- *  'A' - ACPI table overridden.
- *  'W' - Taint on warning.
- *
- *	The string is overwritten by the next call to print_taint().
- */
 
 struct tnt {
 	u8 bit;
@@ -174,6 +159,21 @@ static const struct tnt tnts[] = {
 	{ TAINT_WARN, 'W', ' ' },
 };
 
+/**
+ *	print_tainted - return a string to represent the kernel taint state.
+ *
+ *  'P' - Proprietary module has been loaded.
+ *  'F' - Module has been forcibly loaded.
+ *  'S' - SMP with CPUs not designed for SMP.
+ *  'R' - User forced a module unload.
+ *  'M' - System experienced a machine check exception.
+ *  'B' - System has hit bad_page.
+ *  'U' - Userspace-defined naughtiness.
+ *  'A' - ACPI table overridden.
+ *  'W' - Taint on warning.
+ *
+ *	The string is overwritten by the next call to print_taint().
+ */
 const char *print_tainted(void)
 {
 	static char buf[ARRAY_SIZE(tnts) + sizeof("Tainted: ") + 1];
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-tip.patch
git-hid.patch
git-net.patch
git-sound.patch
git-block.patch
git-drm.patch
git-security-testing.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
documentation-explain-memory-barriers.patch
taint-fix-kernel-doc.patch
framebuffer-fix-carminefb-section-mismatch.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

