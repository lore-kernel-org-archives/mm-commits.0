From: akpm@linux-foundation.org
Subject: + kernel-doc-handle-spaces-in-array-size.patch added to -mm tree
Date: Sat, 07 Apr 2007 00:38:09 -0700
Message-ID: <200704070738.l377c9IL030096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965485AbXDGHij (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 03:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, randy.dunlap@oracle.com


The patch titled
     kernel-doc: handle spaces in array size
has been added to the -mm tree.  Its filename is
     kernel-doc-handle-spaces-in-array-size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: handle spaces in array size
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Unfortunately, kernel-doc has problems with a struct field like this:
	uint8_t databuf[NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE];

simply due to the spaces around the "+" sign, so drop all spaces inside
[...] so that parsing is done correctly (in some sense).

Warning(linux-2.6.20-git15/include/linux/mtd/nand.h:304): No description found for parameter 'NAND_MAX_OOBSIZE]'

This needs to sit in -mm for awhile to see if it has any adverse effects.

And yes, this is just a hack until kernel-doc learns to do better
parsing.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/kernel-doc~kernel-doc-handle-spaces-in-array-size scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-handle-spaces-in-array-size
+++ a/scripts/kernel-doc
@@ -1452,6 +1452,11 @@ sub create_parameterlist($$$) {
 	    $arg =~ s/\s*:\s*/:/g;
 	    $arg =~ s/\s*\[/\[/g;
 
+	    # no spaces inside [array size expression];
+	    # messes up split/pop/shift/unshift below;
+	    while ($arg =~ s/\[(.*)\s+(.*)\]/[$1$2]/) {
+	    }
+
 	    my @args = split('\s*,\s*', $arg);
 	    if ($args[0] =~ m/\*/) {
 		$args[0] =~ s/(\*+)\s*/ $1/;
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-kbuild.patch
remove-artificial-software-max_loop-limit.patch
fix-kevents-childs-priority-greediness.patch
kernel-doc-handle-spaces-in-array-size.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
vt-add-color-support-to-the-underline-and-italic-attributes.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
