From: akpm@linux-foundation.org
Subject: +
 treewide-remove-references-to-the-now-unnecessary-define_pci_device_table.patch added to -mm tree
Date: Wed, 31 Aug 2016 13:11:41 -0700
Message-ID: <57c739fd.Ntw1lZnnrE12kVFE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48741 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932200AbcHaULo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 16:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, bhelgaas@google.com, corbet@lwn.net, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: remove references to the now unnecessary DEFINE_PCI_DEVICE_TABLE
has been added to the -mm tree.  Its filename is
     treewide-remove-references-to-the-now-unnecessary-define_pci_device_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-remove-references-to-the-now-unnecessary-define_pci_device_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-remove-references-to-the-now-unnecessary-define_pci_device_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: treewide: remove references to the now unnecessary DEFINE_PCI_DEVICE_TABLE

It's been eliminated from the sources, remove it from everywhere else.

Link: http://lkml.kernel.org/r/076eff466fd7edb550c25c8b25d76924ca0eba62.1472660229.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/PCI/pci.txt |    1 -
 include/linux/pci.h       |    9 ---------
 scripts/checkpatch.pl     |    9 ---------
 scripts/tags.sh           |    1 -
 4 files changed, 20 deletions(-)

diff -puN Documentation/PCI/pci.txt~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table Documentation/PCI/pci.txt
--- a/Documentation/PCI/pci.txt~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table
+++ a/Documentation/PCI/pci.txt
@@ -124,7 +124,6 @@ initialization with a pointer to a struc
 
 The ID table is an array of struct pci_device_id entries ending with an
 all-zero entry.  Definitions with static const are generally preferred.
-Use of the deprecated macro DEFINE_PCI_DEVICE_TABLE should be avoided.
 
 Each entry consists of:
 
diff -puN include/linux/pci.h~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table include/linux/pci.h
--- a/include/linux/pci.h~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table
+++ a/include/linux/pci.h
@@ -683,15 +683,6 @@ struct pci_driver {
 #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
 
 /**
- * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
- * @_table: device table name
- *
- * This macro is deprecated and should not be used in new code.
- */
-#define DEFINE_PCI_DEVICE_TABLE(_table) \
-	const struct pci_device_id _table[]
-
-/**
  * PCI_DEVICE - macro used to describe a specific pci device
  * @vend: the 16 bit PCI Vendor ID
  * @dev: the 16 bit PCI Device ID
diff -puN scripts/checkpatch.pl~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table
+++ a/scripts/checkpatch.pl
@@ -3570,15 +3570,6 @@ sub process {
 			}
 		}
 
-# check for uses of DEFINE_PCI_DEVICE_TABLE
-		if ($line =~ /\bDEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=/) {
-			if (WARN("DEFINE_PCI_DEVICE_TABLE",
-				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" . $herecurr) &&
-			    $fix) {
-				$fixed[$fixlinenr] =~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id $1\[\] = /;
-			}
-		}
-
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
diff -puN scripts/tags.sh~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table scripts/tags.sh
--- a/scripts/tags.sh~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table
+++ a/scripts/tags.sh
@@ -206,7 +206,6 @@ regex_c=(
 	'/\<DEFINE_PER_CPU_SHARED_ALIGNED([^,]*, *\([[:alnum:]_]*\)/\1/v/'
 	'/\<DECLARE_WAIT_QUEUE_HEAD(\([[:alnum:]_]*\)/\1/v/'
 	'/\<DECLARE_\(TASKLET\|WORK\|DELAYED_WORK\)(\([[:alnum:]_]*\)/\2/v/'
-	'/\<DEFINE_PCI_DEVICE_TABLE(\([[:alnum:]_]*\)/\1/v/'
 	'/\(^\s\)OFFSET(\([[:alnum:]_]*\)/\2/v/'
 	'/\(^\s\)DEFINE(\([[:alnum:]_]*\)/\2/v/'
 	'/\<DEFINE_HASHTABLE(\([[:alnum:]_]*\)/\1/v/'
_

Patches currently in -mm which might be from joe@perches.com are

wd719x-remove-last-declaration-using-define_pci_device_table.patch
treewide-remove-references-to-the-now-unnecessary-define_pci_device_table.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
spellingtxt-modeled-is-spelt-correctly.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead.patch
checkpatch-test-multiple-line-block-comment-alignment.patch

