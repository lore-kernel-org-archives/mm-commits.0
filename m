From: akpm@linux-foundation.org
Subject: - checkpatch-macros-which-define-structure-members-are-not-complex.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:02 -0700
Message-ID: <200810182314.m9INE2t8028315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbYJRXOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: macros which define structure members are not complex
has been removed from the -mm tree.  Its filename was
     checkpatch-macros-which-define-structure-members-are-not-complex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: macros which define structure members are not complex
From: Andy Whitcroft <apw@shadowen.org>

We often see macros which define structure members, these are not complex
and necessarily do not have braces or brackets.  For example:

    #define _PLIST_HEAD_INIT(head)                      \
        .prio_list = LIST_HEAD_INIT((head).prio_list),  \
        .node_list = LIST_HEAD_INIT((head).node_list)

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-macros-which-define-structure-members-are-not-complex scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-macros-which-define-structure-members-are-not-complex
+++ a/scripts/checkpatch.pl
@@ -2155,6 +2155,7 @@ sub process {
 				if ($dstat ne '' &&
 				    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&
 				    $dstat !~ /$exceptions/ &&
+				    $dstat !~ /^\.$Ident\s*=/ &&
 				    $dstat =~ /$Operators/)
 				{
 					ERROR("Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

