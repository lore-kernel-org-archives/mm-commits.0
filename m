From: akpm@linux-foundation.org
Subject: [alternative-merged]
 scripts-extract-certc-fix-err-call-in-write_cert.patch removed from -mm
 tree
Date: Fri, 11 Sep 2015 11:25:03 -0700
Message-ID: <55f31c7f.R/ylW7kh6cI4LHKu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbbIKSZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/extract-cert.c: fix ERR() call in write_cert()
has been removed from the -mm tree.  Its filename was
     scripts-extract-certc-fix-err-call-in-write_cert.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/extract-cert.c: fix ERR() call in write_cert()

scripts/extract-cert.c: In function 'write_cert':
scripts/extract-cert.c:89:2: warning: format not a string literal and no format arguments [-Wformat-security]

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/extract-cert.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/extract-cert.c~scripts-extract-certc-fix-err-call-in-write_cert scripts/extract-cert.c
--- a/scripts/extract-cert.c~scripts-extract-certc-fix-err-call-in-write_cert
+++ a/scripts/extract-cert.c
@@ -86,7 +86,7 @@ static void write_cert(X509 *x509)
 		ERR(!wb, "%s", cert_dst);
 	}
 	X509_NAME_oneline(X509_get_subject_name(x509), buf, sizeof(buf));
-	ERR(!i2d_X509_bio(wb, x509), cert_dst);
+	ERR(!i2d_X509_bio(wb, x509), "%s", cert_dst);
 	if (kbuild_verbose)
 		fprintf(stderr, "Extracted cert: %s\n", buf);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
revert-ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch
mm.patch
mm-srcu-ify-shrinkers-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

