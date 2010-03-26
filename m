From: akpm@linux-foundation.org
Subject: [merged] scripts-kernel-doc-handle-struct-member-__aligned.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:35:52 -0400
Message-ID: <201003261936.o2QJapij016558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0CZTg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scripts/kernel-doc: handle struct member __aligned
has been removed from the -mm tree.  Its filename was
     scripts-kernel-doc-handle-struct-member-__aligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/kernel-doc: handle struct member __aligned
From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/kernel-doc erroneously says:

Warning(include/linux/skbuff.h:410): Excess struct/union/enum/typedef member 'cb' description in 'sk_buff'

on this line in struct sk_buff:
	char			cb[48] __aligned(8);

due to treating the last field as the struct member name, so teach
kernel-doc to ignore __aligned(x) in structs.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/kernel-doc~scripts-kernel-doc-handle-struct-member-__aligned scripts/kernel-doc
--- a/scripts/kernel-doc~scripts-kernel-doc-handle-struct-member-__aligned
+++ a/scripts/kernel-doc
@@ -1424,6 +1424,8 @@ sub dump_struct($$) {
 	$nested =~ s/\/\*.*?\*\///gos;
 	# strip kmemcheck_bitfield_{begin,end}.*;
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
+	# strip attributes
+	$members =~ s/__aligned\s*\(\d+\)//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

