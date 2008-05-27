From: akpm@linux-foundation.org
Subject: - ntfs-le_add_cpu-conversion.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:44 -0700
Message-ID: <200805270726.m4R7Qinp014695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466AbYE0H1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     ntfs: le*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     ntfs-le_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/upcase.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ntfs/upcase.c~ntfs-le_add_cpu-conversion fs/ntfs/upcase.c
--- a/fs/ntfs/upcase.c~ntfs-le_add_cpu-conversion
+++ a/fs/ntfs/upcase.c
@@ -77,11 +77,10 @@ ntfschar *generate_default_upcase(void)
 		uc[i] = cpu_to_le16(i);
 	for (r = 0; uc_run_table[r][0]; r++)
 		for (i = uc_run_table[r][0]; i < uc_run_table[r][1]; i++)
-			uc[i] = cpu_to_le16(le16_to_cpu(uc[i]) +
-					uc_run_table[r][2]);
+			le16_add_cpu(&uc[i], uc_run_table[r][2]);
 	for (r = 0; uc_dup_table[r][0]; r++)
 		for (i = uc_dup_table[r][0]; i < uc_dup_table[r][1]; i += 2)
-			uc[i + 1] = cpu_to_le16(le16_to_cpu(uc[i + 1]) - 1);
+			le16_add_cpu(&uc[i + 1], -1);
 	for (r = 0; uc_word_table[r][0]; r++)
 		uc[uc_word_table[r][0]] = cpu_to_le16(uc_word_table[r][1]);
 	return uc;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

linux-next.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
vfs-fix-err_ptr-abuse-in-generic_readlink.patch

