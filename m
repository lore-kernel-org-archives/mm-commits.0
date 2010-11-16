From: akpm@linux-foundation.org
Subject: + scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch added to -mm tree
Date: Tue, 16 Nov 2010 14:12:09 -0800
Message-ID: <201011162212.oAGMC9Pc010857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932321Ab0KPWMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 17:12:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@shadowen.org


The patch titled
     scripts/checkpatch.pl: add check for multiple terminating semicolons and casts of vmalloc
has been added to the -mm tree.  Its filename is
     scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/checkpatch.pl: add check for multiple terminating semicolons and casts of vmalloc
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc
+++ a/scripts/checkpatch.pl
@@ -2785,10 +2785,15 @@ sub process {
 		}
 
 # check for pointless casting of kmalloc return
-		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
+		if ($line =~ /\*\s*\)\s*[kv][czm]alloc(_node){0,1}\b/) {
 			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# check for multiple semicolons
+		if ($line =~ /;\s*;\s*$/) {
+		    WARN("Statements terminations use 1 semicolon\n" . $herecurr);
+		}
+
 # check for gcc specific __FUNCTION__
 		if ($line =~ /__FUNCTION__/) {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

kernel-sysctlc-fix-build-failure-with-config_printk.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
maintainers-intel-gfx-is-a-subscribers-only-mailing-list.patch
scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

