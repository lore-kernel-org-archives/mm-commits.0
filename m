From: akpm@linux-foundation.org
Subject: + gru-fix-preprocessor-symbol-for-sparse.patch added to -mm tree
Date: Thu, 07 Aug 2008 16:31:47 -0700
Message-ID: <200808072331.m77NVluJ011487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYHGXdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 19:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, steiner@sgi.com


The patch titled
     GRU: fix preprocessor symbol for sparse
has been added to the -mm tree.  Its filename is
     gru-fix-preprocessor-symbol-for-sparse.patch

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

gru-fix-preprocessor-symbol-for-sparse.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
git-kbuild-fixes.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
bnx2x-fix-logical-op.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

