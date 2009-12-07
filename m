From: akpm@linux-foundation.org
Subject: + seq_file-use-proc_create-in-documentation.patch added to -mm tree
Date: Mon, 07 Dec 2009 13:07:09 -0800
Message-ID: <200912072107.nB7L79L1003047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935561AbZLGVH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 16:07:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, corbet@lwn.net, randy.dunlap@oracle.com


The patch titled
     seq_file: use proc_create() in documentation
has been added to the -mm tree.  Its filename is
     seq_file-use-proc_create-in-documentation.patch

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
Subject: seq_file: use proc_create() in documentation
From: Alexey Dobriyan <adobriyan@gmail.com>

Using create_proc_entry() + ->proc_fops assignment is racy because
->proc_fops will be NULL for some time, use proc_create() to avoid race.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/seq_file.txt |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN Documentation/filesystems/seq_file.txt~seq_file-use-proc_create-in-documentation Documentation/filesystems/seq_file.txt
--- a/Documentation/filesystems/seq_file.txt~seq_file-use-proc_create-in-documentation
+++ a/Documentation/filesystems/seq_file.txt
@@ -248,9 +248,7 @@ code, that is done in the initialization
 	{
 	        struct proc_dir_entry *entry;
 
-	        entry = create_proc_entry("sequence", 0, NULL);
-	        if (entry)
-	                entry->proc_fops = &ct_file_ops;
+	        proc_create("sequence", 0, NULL, &ct_file_ops);
 	        return 0;
 	}
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
bsdacct-fix-uid-gid-misreporting.patch
hfs-fix-a-potential-buffer-overflow.patch
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
via-pmu-convert-to-proc_fops-seq_file.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
mpt-fusion-convert-to-seq_file.patch
sysctl_max_map_count-should-be-non-negative.patch
alpha-convert-srm-code-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-convert-to-seq_file-proc_fops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
clps711xfb-convert-to-proc_fops.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
proc-remove-docbook-and-example.patch
seq_file-use-proc_create-in-documentation.patch

