From: akpm@osdl.org
Subject: + kernel-doc-allow-a-little-whitespace.patch added to -mm tree
Date: Mon, 08 Jan 2007 13:44:52 -0800
Message-ID: <200701082144.l08Liq5x019852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785AbXAHVpK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:45:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: allow a little whitespace
has been added to the -mm tree.  Its filename is
     kernel-doc-allow-a-little-whitespace.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: allow a little whitespace
From: Randy Dunlap <randy.dunlap@oracle.com>

In kernel-doc syntax, be a little flexible:  allow whitespace between
a function parameter name and the colon that must follow it, such as:
	@pdev : PCI device to unplug

(This allows lots of megaraid kernel-doc to work without tons of
editing.)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |    2 +-
 scripts/kernel-doc                      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~kernel-doc-allow-a-little-whitespace Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~kernel-doc-allow-a-little-whitespace
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -101,7 +101,7 @@ The format of the block comment is like 
 
 /**
  * function_name(:)? (- short description)?
-(* @parameterx: (description of parameter x)?)*
+(* @parameterx(space)*: (description of parameter x)?)*
 (* a blank line)?
  * (Description:)? (Description of function)?
  * (section header: (section description)? )*
diff -puN scripts/kernel-doc~kernel-doc-allow-a-little-whitespace scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-allow-a-little-whitespace
+++ a/scripts/kernel-doc
@@ -83,7 +83,7 @@ use strict;
 #  * my_function
 #  **/
 #
-# If the Description: header tag is ommitted, then there must be a blank line
+# If the Description: header tag is omitted, then there must be a blank line
 # after the last parameter specification.
 # e.g.
 # /**
@@ -265,7 +265,7 @@ my $doc_start = '^/\*\*\s*$'; # Allow wh
 my $doc_end = '\*/';
 my $doc_com = '\s*\*\s*';
 my $doc_decl = $doc_com.'(\w+)';
-my $doc_sect = $doc_com.'(['.$doc_special.']?[\w ]+):(.*)';
+my $doc_sect = $doc_com.'(['.$doc_special.']?[\w\s]+):(.*)';
 my $doc_content = $doc_com.'(.*)';
 my $doc_block = $doc_com.'DOC:\s*(.*)?';
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-rc-fixes.patch
kernel-doc-allow-a-little-whitespace.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch
