From: akpm@linux-foundation.org
Subject: + revert-kbuild-reenable-section-mismatch-analysis.patch added to -mm tree
Date: Thu, 10 Mar 2011 16:07:54 -0800
Message-ID: <201103110042.p2B0golp006425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660Ab1CKAnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Mar 2011 19:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mmarek@suse.cz, rdunlap@xenotime.net, u.kleine-koenig@pengutronix.de, vapier@gentoo.org


The patch titled
     revert "kbuild: reenable section mismatch analysis"
has been added to the -mm tree.  Its filename is
     revert-kbuild-reenable-section-mismatch-analysis.patch

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
Subject: revert "kbuild: reenable section mismatch analysis"
=46rom: Andrew Morton <akpm@linux-foundation.org>

Revert

: commit de933bd833be1a53bd361c9a327afd3c65413351
: Author:     Uwe Kleine-K=F6nig  <u.kleine-koenig@pengutronix.de>
: AuthorDate: Fri Feb 18 21:47:20 2011 +0100
: Commit:     Michal Marek <mmarek@suse.cz>
: CommitDate: Thu Feb 24 15:26:43 2011 +0100
:=20
:     kbuild: reenable section mismatch analysis

due to excessive output crappage.

Cc: Uwe Kleine-K=F6nig  <u.kleine-koenig@pengutronix.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/Kconfig.debug~revert-kbuild-reenable-section-mismatch-ana=
lysis lib/Kconfig.debug
--- a/lib/Kconfig.debug~revert-kbuild-reenable-section-mismatch-analysi=
s
+++ a/lib/Kconfig.debug
@@ -102,7 +102,11 @@ config HEADERS_CHECK
=20
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
+	depends on UNDEFINED || (BLACKFIN)
 	default y
+	# This option is on purpose disabled for now.
+	# It will be enabled when we are down to a reasonable number
+	# of section mismatch warnings (< 10 for an allyesconfig build)
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

linux-next.patch
next-remove-localversion.patch
revert-kbuild-reenable-section-mismatch-analysis.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages=
-for-migration-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-f=
ix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-f=
ix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-f=
ix-fix-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.pat=
ch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_re=
cv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breaka=
ge-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.pa=
tch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fi=
x.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.p=
atch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks=
-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_add=
r-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_add=
r-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_add=
r-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
