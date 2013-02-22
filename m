From: akpm@linux-foundation.org
Subject: [merged] get_maintainerpl-find-maintainers-for-removed-files.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:02 -0800
Message-ID: <20130222204002.EDD2131C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39012 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab3BVUkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:04 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103825vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer.pl: find maintainers for removed files
has been removed from the -mm tree.  Its filename was
     get_maintainerpl-find-maintainers-for-removed-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

