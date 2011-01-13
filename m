From: akpm@linux-foundation.org
Subject: [folded] kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:19:58 -0800
Message-ID: <201101130019.p0D0JwVg012108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892Ab1AMAU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, davem@davemloft.net, drosenberg@vsecurity.com, eric.dumazet@gmail.com, eugeneteo@kernel.org, jmorris@namei.org, kees.cook@canonical.


The patch titled
     kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix
has been removed from the -mm tree.  Its filename was
     kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch

This patch was dropped because it was folded into kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch

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

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch
drivers-telephony-ixjc-fix-warning.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

