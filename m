From: akpm@linux-foundation.org
Subject: [merged] checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:53 -0800
Message-ID: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34625 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3BVUmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:54 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so103966vcd.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't emit the CamelCase warning for PageFoo
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: don't emit the CamelCase warning for PageFoo

I'm getting a ton of these:

WARNING: Avoid CamelCase: <PageTransHuge>
#140: FILE: mm/migrate.c:1576:
+       if (PageTransHuge(page) && page_count(page) != 3) {

So exclude anything which starts with "Page".

Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-dont-emit-the-camelcase-warning-for-pagefoo scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-emit-the-camelcase-warning-for-pagefoo
+++ a/scripts/checkpatch.pl
@@ -2930,6 +2930,7 @@ sub process {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
+			    $var !~ /^Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
get_maintainer-allow-keywords-to-match-filenames.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch

