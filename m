From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-externalize-the-structs-that-should-be-const.patch removed from
 -mm tree
Date: Wed, 12 Oct 2016 12:23:10 -0700
Message-ID: <57fe8d9e.Kg8BS43Xlmt30tCR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33191 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755915AbcJLTYa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, julia.lawall@lip6.fr, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: externalize the structs that should be const
has been removed from the -mm tree.  Its filename was
     checkpatch-externalize-the-structs-that-should-be-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: externalize the structs that should be const

Make it easier to add new structs that should be const.

Link: http://lkml.kernel.org/r/e5a8da43e7c11525bafbda1ca69a8323614dd942.1472664220.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl            |   64 ++++++++++-------------------
 scripts/const_structs.checkpatch |   39 +++++++++++++++++
 2 files changed, 63 insertions(+), 40 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-externalize-the-structs-that-should-be-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-externalize-the-structs-that-should-be-const
+++ a/scripts/checkpatch.pl
@@ -54,6 +54,7 @@ my $min_conf_desc_length = 4;
 my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
+my $conststructsfile = "$D/const_structs.checkpatch";
 my $color = 1;
 my $allow_c99_comments = 1;
 
@@ -624,6 +625,29 @@ if ($codespell) {
 
 $misspellings = join("|", sort keys %spelling_fix) if keys %spelling_fix;
 
+my $const_structs = "";
+if (open(my $conststructs, '<', $conststructsfile)) {
+	while (<$conststructs>) {
+		my $line = $_;
+
+		$line =~ s/\s*\n?$//g;
+		$line =~ s/^\s*//g;
+
+		next if ($line =~ m/^\s*#/);
+		next if ($line =~ m/^\s*$/);
+		if ($line =~ /\s/) {
+			print("$conststructsfile: '$line' invalid - ignored\n");
+			next;
+		}
+
+		$const_structs .= '|' if ($const_structs ne "");
+		$const_structs .= $line;
+	}
+	close($conststructsfile);
+} else {
+	warn "No structs that should be const will be found - file '$conststructsfile': $!\n";
+}
+
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", (@modifierList, @modifierListFile)) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", (@typeList, @typeListFile)) . "\n)";
@@ -5912,46 +5936,6 @@ sub process {
 		}
 
 # check for various structs that are normally const (ops, kgdb, device_tree)
-		my $const_structs = qr{
-				acpi_dock_ops|
-				address_space_operations|
-				backlight_ops|
-				block_device_operations|
-				dentry_operations|
-				dev_pm_ops|
-				dma_map_ops|
-				extent_io_ops|
-				file_lock_operations|
-				file_operations|
-				hv_ops|
-				ide_dma_ops|
-				intel_dvo_dev_ops|
-				item_operations|
-				iwl_ops|
-				kgdb_arch|
-				kgdb_io|
-				kset_uevent_ops|
-				lock_manager_operations|
-				microcode_ops|
-				mtrr_ops|
-				neigh_ops|
-				nlmsvc_binding|
-				of_device_id|
-				pci_raw_ops|
-				pipe_buf_operations|
-				platform_hibernation_ops|
-				platform_suspend_ops|
-				proto_ops|
-				rpc_pipe_ops|
-				seq_operations|
-				snd_ac97_build_ops|
-				soc_pcmcia_socket_ops|
-				stacktrace_ops|
-				sysfs_ops|
-				tty_operations|
-				uart_ops|
-				usb_mon_operations|
-				wd_ops}x;
 		if ($line !~ /\bconst\b/ &&
 		    $line =~ /\bstruct\s+($const_structs)\b/) {
 			WARN("CONST_STRUCT",
diff -puN /dev/null scripts/const_structs.checkpatch
--- /dev/null
+++ a/scripts/const_structs.checkpatch
@@ -0,0 +1,39 @@
+acpi_dock_ops
+address_space_operations
+backlight_ops
+block_device_operations
+dentry_operations
+dev_pm_ops
+dma_map_ops
+extent_io_ops
+file_lock_operations
+file_operations
+hv_ops
+ide_dma_ops
+intel_dvo_dev_ops
+item_operations
+iwl_ops
+kgdb_arch
+kgdb_io
+kset_uevent_ops
+lock_manager_operations
+microcode_ops
+mtrr_ops
+neigh_ops
+nlmsvc_binding
+of_device_id
+pci_raw_ops
+pipe_buf_operations
+platform_hibernation_ops
+platform_suspend_ops
+proto_ops
+rpc_pipe_ops
+seq_operations
+snd_ac97_build_ops
+soc_pcmcia_socket_ops
+stacktrace_ops
+sysfs_ops
+tty_operations
+uart_ops
+usb_mon_operations
+wd_ops
_

Patches currently in -mm which might be from joe@perches.com are


