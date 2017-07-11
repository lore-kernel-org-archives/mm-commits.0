From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-the-unnecessary-oom-message-test.patch removed from -mm
 tree
Date: Tue, 11 Jul 2017 12:26:50 -0700
Message-ID: <20170711192650.tAldMS2cB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932973AbdGKT0v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the unnecessary OOM message test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-the-unnecessary-oom-message-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the unnecessary OOM message test

Use the context around a patch to avoid missing some candidates.

Link: http://lkml.kernel.org/r/865e874fbae5decc331a849bd8d71c325db6bc80.1496343345.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-unnecessary-oom-message-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-unnecessary-oom-message-test
+++ a/scripts/checkpatch.pl
@@ -5311,7 +5311,7 @@ sub process {
 			my ($s, $c) = ctx_statement_block($linenr - 3, $realcnt, 0);
 #			print("line: <$line>\nprevline: <$prevline>\ns: <$s>\nc: <$c>\n\n\n");
 
-			if ($c =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|(?:dev_)?alloc_skb)/) {
+			if ($s =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|kmemdup|(?:dev_)?alloc_skb)/) {
 				WARN("OOM_MESSAGE",
 				     "Possible unnecessary 'out of memory' message\n" . $hereprev);
 			}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch

