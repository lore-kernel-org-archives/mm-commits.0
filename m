From: akpm@linux-foundation.org
Subject: + kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch added to -mm tree
Date: Fri, 17 Dec 2010 16:54:24 -0800
Message-ID: <201012180054.oBI0sP29006353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756582Ab0LRAy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:54:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, davem@davemloft.net, drosenberg@vsecurity.com, eric.dumazet@gmail.com, eugeneteo@kernel.org, jmorris@namei.org, kees.cook@canonical.com, mingo@elte.hu, tgraf@infradead.org


The patch titled
     kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix
has been added to the -mm tree.  Its filename is
     kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch

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
Subject: kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix
From: Andrew Morton <akpm@linux-foundation.org>

- check for IRQ context when !kptr_restrict

- save an indent level

- s/WARN/WARN_ONCE/

Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eugene Teo <eugeneteo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Thomas Graf <tgraf@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix lib/vsprintf.c
--- a/lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix
+++ a/lib/vsprintf.c
@@ -1039,20 +1039,24 @@ char *pointer(const char *fmt, char *buf
 				       ((struct va_format *)ptr)->fmt,
 				       *(((struct va_format *)ptr)->va));
 	case 'K':
-		if (kptr_restrict) {
-			if (in_irq() || in_serving_softirq() || in_nmi())
-				WARN(1, "%%pK used in interrupt context.\n");
+		/*
+		 * %pK cannot be used in IRQ context because it tests
+		 * CAP_SYSLOG.
+		 */
+		if (in_irq() || in_serving_softirq() || in_nmi())
+			WARN_ONCE(1, "%%pK used in interrupt context.\n");
 
-			else if (capable(CAP_SYSLOG))
-				break;
+		if (!kptr_restrict)
+			break;		/* %pK does not obscure pointers */
 
-			if (spec.field_width == -1) {
-				spec.field_width = 2 * sizeof(void *);
-				spec.flags |= ZEROPAD;
-			}
-			return number(buf, end, 0, spec);
+		if (capable(CAP_SYSLOG))
+			break;		/* privileged apps expose pointers */
+
+		if (spec.field_width == -1) {
+			spec.field_width = 2 * sizeof(void *);
+			spec.flags |= ZEROPAD;
 		}
-		break;
+		return number(buf, end, 0, spec);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
delayacct-fix-iotop-on-x86_64-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

