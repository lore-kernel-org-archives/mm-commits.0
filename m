From: akpm@linux-foundation.org
Subject: + scripts-kernel-doc-handle-struct-member-__aligned.patch added to -mm tree
Date: Thu, 18 Mar 2010 12:05:52 -0700
Message-ID: <201003181905.o2IJ5qNV010152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143Ab0CRTG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 15:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     scripts/kernel-doc: handle struct member __aligned
has been added to the -mm tree.  Its filename is
     scripts-kernel-doc-handle-struct-member-__aligned.patch

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
scripts-kernel-doc-handle-struct-member-__aligned.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

