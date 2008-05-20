From: akpm@linux-foundation.org
Subject: - kernel-doc-allow-unnamed-bit-fields.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:41 -0700
Message-ID: <200805202114.m4KLEfHk011490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765082AbYETVVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:21:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: allow unnamed bit-fields
has been removed from the -mm tree.  Its filename was
     kernel-doc-allow-unnamed-bit-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: allow unnamed bit-fields
From: Randy Dunlap <randy.dunlap@oracle.com>

Allow for unnamed bit-fields and skip them instead of printing an
erroneous warning message for them, such as:

Warning(include/asm-s390/cio.h:103): No description found for parameter 'u32'

which contains:

struct tm_scsw {
	u32 :1;

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-allow-unnamed-bit-fields scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-allow-unnamed-bit-fields
+++ a/scripts/kernel-doc
@@ -1556,7 +1556,9 @@ sub create_parameterlist($$$) {
 		    push_parameter($2, "$type $1", $file);
 		}
 		elsif ($param =~ m/(.*?):(\d+)/) {
-		    push_parameter($1, "$type:$2", $file)
+		    if ($type ne "") { # skip unnamed bit-fields
+			push_parameter($1, "$type:$2", $file)
+		    }
 		}
 		else {
 		    push_parameter($param, $type, $file);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
audit-fix-kernel-doc-parameter-notation.patch
scsi-do-not-automatically-select-scsi_dh-for-dm-multipath.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch

