From: akpm@linux-foundation.org
Subject: + kernel-doc-skip-nested-struct-union-cleanly.patch added to -mm tree
Date: Mon, 04 Aug 2008 15:35:21 -0700
Message-ID: <200808042235.m74MZLoV003093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbYHDWju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 18:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: skip nested struct/union cleanly
has been added to the -mm tree.  Its filename is
     kernel-doc-skip-nested-struct-union-cleanly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: skip nested struct/union cleanly
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix handling of nested structs or unions.  The regex to strip (eliminate)
nested structs or unions was limited to only 0 or 1 matches.  This can
cause an uneven number of left/right braces to be stripped, which causes
this:

Warning(linux-2.6.27-rc1-git2//include/net/mac80211.h:336): No description found for parameter '}'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-skip-nested-struct-union-cleanly scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-skip-nested-struct-union-cleanly
+++ a/scripts/kernel-doc
@@ -1403,7 +1403,7 @@ sub dump_struct($$) {
 	my $members = $3;
 
 	# ignore embedded structs or unions
-	$members =~ s/{.*?}//g;
+	$members =~ s/{.*}//g;
 
 	# ignore members marked private:
 	$members =~ s/\/\*.*?private:.*?public:.*?\*\///gos;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
tracehook-kerneldoc-fix.patch
kernel-doc-skip-nested-struct-union-cleanly.patch
linux-next.patch
v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
kbuild-extend-menuconfig-for-modules-to-simplify-kconfig-file.patch
bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

