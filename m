From: akpm@linux-foundation.org
Subject: - lzo-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:09 -0700
Message-ID: <200807252254.m6PMs9pU002788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbYGYWyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     lzo: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     lzo-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lzo: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lzo/lzo1x_decompress.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN lib/lzo/lzo1x_decompress.c~lzo-use-get-put_unaligned_-helpers lib/lzo/lzo1x_decompress.c
--- a/lib/lzo/lzo1x_decompress.c~lzo-use-get-put_unaligned_-helpers
+++ a/lib/lzo/lzo1x_decompress.c
@@ -138,8 +138,7 @@ match:
 					t += 31 + *ip++;
 				}
 				m_pos = op - 1;
-				m_pos -= le16_to_cpu(get_unaligned(
-					(const unsigned short *)ip)) >> 2;
+				m_pos -= get_unaligned_le16(ip) >> 2;
 				ip += 2;
 			} else if (t >= 16) {
 				m_pos = op;
@@ -157,8 +156,7 @@ match:
 					}
 					t += 7 + *ip++;
 				}
-				m_pos -= le16_to_cpu(get_unaligned(
-					(const unsigned short *)ip)) >> 2;
+				m_pos -= get_unaligned_le16(ip) >> 2;
 				ip += 2;
 				if (m_pos == op)
 					goto eof_found;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update.patch

