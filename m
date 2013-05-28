From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
 added to -mm tree
Date: Tue, 28 May 2013 13:42:06 -0700
Message-ID: <51a5169e.SHXvc2D583MRVF3e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab3E1UmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 16:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 13:42:06 -0700


The patch titled
     Subject: checkpatch: add --strict preference for p = kmalloc(sizeof(*p)...
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch

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
Subject: checkpatch: add --strict preference for p = kmalloc(sizeof(*p)...

Add another test for memory allocation style to follow
Documentation/CodingStyle:

		Chapter 14: Allocating memory

The preferred form for passing a size of a struct is the following:

	p = kmalloc(sizeof(*p), ...);

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-preference-for-p-=-kmallocsizeofp scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-preference-for-p-=-kmallocsizeofp
+++ a/scripts/checkpatch.pl
@@ -3507,6 +3507,14 @@ sub process {
 			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# alloc style
+# p = alloc(sizeof(struct foo), ...) should be p = alloc(sizeof(*p), ...)
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*([kv][mz]alloc(?:_node)?)\s*\(\s*(sizeof\s*\(\s*struct\s+$Lval\s*\))/) {
+			CHK("ALLOC_SIZEOF_STRUCT",
+			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
+		}
+
 # check for krealloc arg reuse
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
lib-bitmapc-speed-up-bitmap_find_free_region.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch

