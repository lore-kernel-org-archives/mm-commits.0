From: akpm@linux-foundation.org
Subject: [merged]
 documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:33:17 -0700
Message-ID: <53960bfd.DVAZN/fn1ko2ujIs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:33:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, corbet@lwn.net, fabf@skynet.be

Subject: [merged] documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch removed from -mm tree
To: fabf@skynet.be,corbet@lwn.net,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:33:17 -0700


The patch titled
     Subject: Documentation/filesystems/seq_file.txt: create_proc_entry deprecated
has been removed from the -mm tree.  Its filename was
     documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: Documentation/filesystems/seq_file.txt: create_proc_entry deprecated

Linked article in seq_file.txt still uses create_proc_entry which was
removed in 80e928f7ebb958 ("proc: Kill create_proc_entry()").

This patch adds information for kernel 3.10 and above

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/seq_file.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN Documentation/filesystems/seq_file.txt~documentation-filesystems-seq_filetxt-create_proc_entry-deprecated Documentation/filesystems/seq_file.txt
--- a/Documentation/filesystems/seq_file.txt~documentation-filesystems-seq_filetxt-create_proc_entry-deprecated
+++ a/Documentation/filesystems/seq_file.txt
@@ -54,6 +54,15 @@ how the mechanism works without getting
 wanting to see the full source for this module can find it at
 http://lwn.net/Articles/22359/).
 
+Deprecated create_proc_entry
+
+Note that the above article uses create_proc_entry which was removed in
+kernel 3.10. Current versions require the following update
+
+-	entry = create_proc_entry("sequence", 0, NULL);
+-	if (entry)
+-		entry->proc_fops = &ct_file_ops;
++	entry = proc_create("sequence", 0, NULL, &ct_file_ops);
 
 The iterator interface
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

