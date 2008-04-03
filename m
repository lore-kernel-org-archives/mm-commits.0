From: akpm@linux-foundation.org
Subject: + kernel-doc-detect-trailing-kernel-doc-line-trash.patch added to -mm tree
Date: Thu, 03 Apr 2008 15:11:15 -0700
Message-ID: <200804032211.m33MBFp1025147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756487AbYDCWL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 18:11:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: detect trailing kernel-doc line trash
has been added to the -mm tree.  Its filename is
     kernel-doc-detect-trailing-kernel-doc-line-trash.patch

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

docbook-some-kernel-locking-fixes.patch
x86_32-fix-visualws-and-voyager-kexec-build-failures.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
git-kvm.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
kernel-doc-detect-prevent-duplicate-doc-section-names.patch
kernel-doc-detect-trailing-kernel-doc-line-trash.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

