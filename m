From: akpm@linux-foundation.org
Subject: + get_maintainerpl-find-maintainers-for-removed-files.patch added to -mm tree
Date: Wed, 02 Jan 2013 15:31:19 -0800
Message-ID: <20130102233120.09E0120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:34438 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3ABXbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 18:31:22 -0500
Received: by mail-la0-f73.google.com with SMTP id fq13so319926lab.0
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 15:31:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, joe@perches.com


The patch titled
     Subject: get_maintainer.pl: find maintainers for removed files
has been added to the -mm tree.  Its filename is
     get_maintainerpl-find-maintainers-for-removed-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: get_maintainer.pl: find maintainers for removed files

For removed files, get_maintainer.pl doesn't find any maintainers (besides
the default linux-kernel@vger.kernel.org), as it only looks at the "+++"
lines, which are "/dev/null" for removals.  Fix this by extending the
parsing to the "---" lines.

E.g. for the two line test patch below the real score maintainers will now
be found:

    --- a/arch/score/include/asm/dma-mapping.h
    +++ /dev/null

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-find-maintainers-for-removed-files scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-find-maintainers-for-removed-files
+++ a/scripts/get_maintainer.pl
@@ -433,7 +433,7 @@ foreach my $file (@ARGV) {
 
 	while (<$patch>) {
 	    my $patch_line = $_;
-	    if (m/^\+\+\+\s+(\S+)/) {
+	    if (m/^\+\+\+\s+(\S+)/ or m/^---\s+(\S+)/) {
 		my $filename = $1;
 		$filename =~ s@^[^/]*/@@;
 		$filename =~ s@\n@@;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
cris-use-int-for-ssize_t-to-match-size_t.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
get_maintainerpl-find-maintainers-for-removed-files.patch

