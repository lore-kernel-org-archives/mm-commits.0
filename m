From: akpm@linux-foundation.org
Subject: +
 checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch added to -mm tree
Date: Thu, 01 Sep 2016 15:04:41 -0700
Message-ID: <57c8a5f9.EBPU/j9TqozPJPFM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59497 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753409AbcIAWEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 18:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: speed up checking for filenames in sections marked obsolete
has been added to the -mm tree.  Its filename is
     checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch

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
Subject: checkpatch: speed up checking for filenames in sections marked obsolete

Adding -f to the get_maintainer.pl invocation means git isn't invoked
by get_maintainer.pl for known filenames.

This reduces the overall time to run checkpatch.

Link: http://lkml.kernel.org/r/22991e3a295aeb399b43af0478b6e5809106ccee.1472684066.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete
+++ a/scripts/checkpatch.pl
@@ -759,7 +759,7 @@ sub is_maintained_obsolete {
 
 	return 0 if (!(-e "$root/scripts/get_maintainer.pl"));
 
-	my $status = `perl $root/scripts/get_maintainer.pl --status --nom --nol --nogit --nogit-fallback $filename 2>&1`;
+	my $status = `perl $root/scripts/get_maintainer.pl --status --nom --nol --nogit --nogit-fallback -f $filename 2>&1`;
 
 	return $status =~ /obsolete/i;
 }
_

Patches currently in -mm which might be from joe@perches.com are

wd719x-remove-last-declaration-using-define_pci_device_table.patch
treewide-remove-references-to-the-now-unnecessary-define_pci_device_table.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
spellingtxt-modeled-is-spelt-correctly.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead.patch
checkpatch-test-multiple-line-block-comment-alignment.patch
checkpatch-dont-test-for-prefer-ether_addr_foo.patch
checkpatch-externalize-the-structs-that-should-be-const.patch
const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch
checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch

