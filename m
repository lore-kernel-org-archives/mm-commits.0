From: akpm@linux-foundation.org
Subject: - kernel-doc-skip-nested-struct-union-cleanly.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:57:06 -0700
Message-ID: <200808062057.m76Kv6dW014739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422861AbYHFU5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: skip nested struct/union cleanly
has been removed from the -mm tree.  Its filename was
     kernel-doc-skip-nested-struct-union-cleanly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
git-kbuild-fixes.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

