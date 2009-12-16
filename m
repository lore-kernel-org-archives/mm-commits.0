From: akpm@linux-foundation.org
Subject: [merged] seq_file-use-proc_create-in-documentation.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:23 -0800
Message-ID: <200912162037.nBGKbNTY013332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964825AbZLPUhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, corbet@lwn.net, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     seq_file: use proc_create() in documentation
has been removed from the -mm tree.  Its filename was
     seq_file-use-proc_create-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch

