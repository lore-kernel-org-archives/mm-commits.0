From: akpm@linux-foundation.org
Subject: - tpm_biosc-make-2-structs-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:54 -0700
Message-ID: <200807262113.m6QLDsqu019636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757524AbYGZVOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm_bios.c: make 2 structs static
has been removed from the -mm tree.  Its filename was
     tpm_biosc-make-2-structs-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm_bios.c: make 2 structs static
From: Adrian Bunk <bunk@kernel.org>

This patch makes two needlessly global structs static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_bios.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/tpm/tpm_bios.c~tpm_biosc-make-2-structs-static drivers/char/tpm/tpm_bios.c
--- a/drivers/char/tpm/tpm_bios.c~tpm_biosc-make-2-structs-static
+++ a/drivers/char/tpm/tpm_bios.c
@@ -448,7 +448,7 @@ out_free:
 	goto out;
 }
 
-const struct file_operations tpm_ascii_bios_measurements_ops = {
+static const struct file_operations tpm_ascii_bios_measurements_ops = {
 	.open = tpm_ascii_bios_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -486,7 +486,7 @@ out_free:
 	goto out;
 }
 
-const struct file_operations tpm_binary_bios_measurements_ops = {
+static const struct file_operations tpm_binary_bios_measurements_ops = {
 	.open = tpm_binary_bios_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

