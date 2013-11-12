From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-add-check-for-sscanf-without-return-use-v2.patch removed from
 -mm tree
Date: Tue, 12 Nov 2013 14:41:19 -0800
Message-ID: <5282ae8f.DkdCgO2+EhrMYNjY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3KLWlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:41:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [folded-merged] checkpatch-add-check-for-sscanf-without-return-use-v2.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:41:19 -0800


The patch titled
     Subject: checkpatch-add-check-for-sscanf-without-return-use-v2
has been removed from the -mm tree.  Its filename was
     checkpatch-add-check-for-sscanf-without-return-use-v2.patch

This patch was dropped because it was folded into checkpatch-add-check-for-sscanf-without-return-use.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch-add-check-for-sscanf-without-return-use-v2

V2: Use the $Compare variable instead of just == or !=
    There are some tests that use < and >

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-sscanf-without-return-use-v2 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-sscanf-without-return-use-v2
+++ a/scripts/checkpatch.pl
@@ -4019,8 +4019,8 @@ sub process {
 		    defined $stat &&
 		    $stat =~ /\bsscanf\b/ &&
 		    ($stat !~ /$Ident\s*=\s*sscanf\s*$balanced_parens/ &&
-		     $stat !~ /\bsscanf\s*$balanced_parens\s*(?:==|\!=)/ &&
-		     $stat !~ /(?:==|\!=)\s*\bsscanf\s*$balanced_parens/)) {
+		     $stat !~ /\bsscanf\s*$balanced_parens\s*(?:$Compare)/ &&
+		     $stat !~ /(?:$Compare)\s*\bsscanf\s*$balanced_parens/)) {
 			my $lc = $stat =~ tr@\n@@;
 			$lc = $lc + $linenr;
 			my $stat_real = raw_line($linenr, 0);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
vsprintf-check-real-user-group-id-for-%pk.patch
printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-improve-return-is-not-a-function-test.patch
checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch

