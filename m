From: akpm@linux-foundation.org
Subject: + page_fault-retry-with-nopage_retry-fix.patch added to -mm tree
Date: Mon, 26 Jan 2009 11:38:24 -0800
Message-ID: <200901261938.n0QJcOWN006234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbZAZTjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:39:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, edwintorok@gmail.com, hpa@zytor.com, hugh@veritas.com, lee.schermerhorn@hp.com, mikew@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com, rohitseth@google.com, yinghan@google.com


The patch titled
     page_fault-retry-with-nopage_retry-fix
has been added to the -mm tree.  Its filename is
     page_fault-retry-with-nopage_retry-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: page_fault-retry-with-nopage_retry-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

Untangle the `write' boolean from the FAULT_FLAG_foo non-boolean field.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: T=F6r=F6k Edwin <edwintorok@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix ar=
ch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix
+++ a/arch/x86/mm/fault.c
@@ -799,7 +799,7 @@ void __kprobes do_page_fault(struct pt_r
 	struct vm_area_struct *vma;
 	int write;
 	int fault;
-	unsigned int retry_flag =3D FAULT_FLAG_RETRY;
+	int retry_flag =3D 1;
=20
 	tsk =3D current;
 	mm =3D tsk->mm;
@@ -951,6 +951,7 @@ good_area:
 	}
=20
 	write |=3D retry_flag;
+
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -969,8 +970,8 @@ good_area:
 	 * be removed or changed after the retry.
 	 */
 	if (fault & VM_FAULT_RETRY) {
-		if (write & FAULT_FLAG_RETRY) {
-			retry_flag &=3D ~FAULT_FLAG_RETRY;
+		if (retry_flag) {
+			retry_flag =3D 0;
 			goto retry;
 		}
 		BUG();
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=3Dn.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.p=
atch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-f=
ixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-f=
ix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkp=
atch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patc=
h
w1-build-fix.patch
a.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
