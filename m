From: akpm@linux-foundation.org
Subject: - gru-fix-preprocessor-symbol-for-sparse.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:43 -0700
Message-ID: <200808130852.m7D8qh2V008250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbYHMJDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     GRU: fix preprocessor symbol for sparse
has been removed from the -mm tree.  Its filename was
     gru-fix-preprocessor-symbol-for-sparse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU: fix preprocessor symbol for sparse
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix preprocessor symbol so that sparse sees it and does not generate
errors:

linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutlbpurge.c:185:11: error: undefined identifier 'GRUREGION'
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grutables.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grutables.h~gru-fix-preprocessor-symbol-for-sparse drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-fix-preprocessor-symbol-for-sparse
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -279,7 +279,7 @@ struct gru_stats_s {
 #if defined CONFIG_IA64
 #define VADDR_HI_BIT		64
 #define GRUREGION(addr)		((addr) >> (VADDR_HI_BIT - 3) & 3)
-#elif defined __x86_64
+#elif defined CONFIG_X86_64
 #define VADDR_HI_BIT		48
 #define GRUREGION(addr)		(0)		/* ZZZ could do better */
 #else
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
ftrace-printk-formatting-infrastructure-fix-fix.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

