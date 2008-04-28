From: akpm@linux-foundation.org
Subject: - kernel-doc-detect-trailing-kernel-doc-line-trash.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:56 -0700
Message-ID: <200804282201.m3SM1u0M018909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965822AbYD1WCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: detect trailing kernel-doc line trash
has been removed from the -mm tree.  Its filename was
     kernel-doc-detect-trailing-kernel-doc-line-trash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: detect trailing kernel-doc line trash
From: Randy Dunlap <randy.dunlap@oracle.com>

Print a warning when a kernel-doc comment block ends with text on the same
line as the ending comment characters, e.g.:

 * this text is lost. */

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/kernel-doc~kernel-doc-detect-trailing-kernel-doc-line-trash scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-detect-trailing-kernel-doc-line-trash
+++ a/scripts/kernel-doc
@@ -1950,6 +1950,11 @@ sub process_file($) {
 		    $section = $section_default;
 		    $contents = "";
 		}
+		# look for doc_com + <text> + doc_end:
+		if ($_ =~ m'\s*\*\s*[a-zA-Z_0-9:\.]+\*/') {
+		    print STDERR "Warning(${file}:$.): suspicious ending line: $_";
+		    ++$warnings;
+		}
 
 		$prototype = "";
 		$state = 3;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
doc-fix-dma-api-function-parameters.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

