From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-sscanf-without-return-use-v2.patch
 added to -mm tree
Date: Mon, 07 Oct 2013 17:21:17 -0700
Message-ID: <52534ffd.mI+coGdymQDVx4Q3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3JHAVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 20:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-add-check-for-sscanf-without-return-use-v2.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 17:21:17 -0700


The patch titled
     Subject: checkpatch-add-check-for-sscanf-without-return-use-v2
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-sscanf-without-return-use-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-check-for-sscanf-without-return-use-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-check-for-sscanf-without-return-use-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4029,8 +4029,8 @@ sub process {
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

kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
printk-mark-printk_once-test-variable-__read_mostly.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch

