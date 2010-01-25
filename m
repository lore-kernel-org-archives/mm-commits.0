From: akpm@linux-foundation.org
Subject: + checkpatchpl-extend-list-of-expected-to-be-const-structures.patch added to -mm tree
Date: Mon, 25 Jan 2010 14:46:07 -0800
Message-ID: <201001252246.o0PMk7nZ015604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab0AYWq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 17:46:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: re.emese@gmail.com, apw@shadowen.org, arjan@infradead.org


The patch titled
     checkpatch.pl: extend list of expected-to-be-const structures
has been added to the -mm tree.  Its filename is
     checkpatchpl-extend-list-of-expected-to-be-const-structures.patch

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
Subject: checkpatch.pl: extend list of expected-to-be-const structures
From: Emese Revfy <re.emese@gmail.com>

Based on Arjan's suggestion, extend the list of ops structures that should
be const.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   41 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-extend-list-of-expected-to-be-const-structures scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-extend-list-of-expected-to-be-const-structures
+++ a/scripts/checkpatch.pl
@@ -2654,9 +2654,46 @@ sub process {
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
-# check for struct file_operations, ensure they are const.
+# check for various ops structs, ensure they are const.
+		my $struct_ops = qr{acpi_dock_ops|
+				address_space_operations|
+				backlight_ops|
+				block_device_operations|
+				dentry_operations|
+				dev_pm_ops|
+				dma_map_ops|
+				extent_io_ops|
+				file_lock_operations|
+				file_operations|
+				hv_ops|
+				ide_dma_ops|
+				intel_dvo_dev_ops|
+				item_operations|
+				iwl_ops|
+				kgdb_arch|
+				kgdb_io|
+				kset_uevent_ops|
+				lock_manager_operations|
+				microcode_ops|
+				mtrr_ops|
+				neigh_ops|
+				nlmsvc_binding|
+				pci_raw_ops|
+				pipe_buf_operations|
+				platform_hibernation_ops|
+				platform_suspend_ops|
+				proto_ops|
+				rpc_pipe_ops|
+				seq_operations|
+				snd_ac97_build_ops|
+				soc_pcmcia_socket_ops|
+				stacktrace_ops|
+				sysfs_ops|
+				tty_operations|
+				usb_mon_operations|
+				wd_ops}x;
 		if ($line !~ /\bconst\b/ &&
-		    $line =~ /\bstruct\s+(file_operations|seq_operations)\b/) {
+		    $line =~ /\bstruct\s+($struct_ops)\b/) {
 			WARN("struct $1 should normally be const\n" .
 				$herecurr);
 		}
_

Patches currently in -mm which might be from re.emese@gmail.com are

linux-next.patch
checkpatchpl-extend-list-of-expected-to-be-const-structures.patch

