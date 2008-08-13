From: akpm@linux-foundation.org
Subject: - docsrc-fix-crc32hash-type.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:29 -0700
Message-ID: <200808130853.m7D8rTve008330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486AbYHMJDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:03:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, linux@dominikbrodowski.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     docsrc: fix crc32hash type
has been removed from the -mm tree.  Its filename was
     docsrc-fix-crc32hash-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docsrc: fix crc32hash type
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix differing signedness warning:

Documentation/pcmcia/crc32hash.c:29: warning: pointer targets in passing argument 1 of 'crc32' differ in signedness

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pcmcia/crc32hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/pcmcia/crc32hash.c~docsrc-fix-crc32hash-type Documentation/pcmcia/crc32hash.c
--- a/Documentation/pcmcia/crc32hash.c~docsrc-fix-crc32hash-type
+++ a/Documentation/pcmcia/crc32hash.c
@@ -26,7 +26,7 @@ int main(int argc, char **argv) {
 		printf("no string passed as argument\n");
 		return -1;
 	}
-	result = crc32(argv[1], strlen(argv[1]));
+	result = crc32((unsigned char const *)argv[1], strlen(argv[1]));
 	printf("0x%x\n", result);
 	return 0;
 }
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

