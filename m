From: akpm@linux-foundation.org
Subject: [merged] get_maintainerpl-add-support-for-moderated-lists.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:38 -0700
Message-ID: <20120326192838.601CBA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63654 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CZT2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:40 -0400
Received: by eekc41 with SMTP id c41so293886eek.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer.pl: add support for moderated lists
has been removed from the -mm tree.  Its filename was
     get_maintainerpl-add-support-for-moderated-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: get_maintainer.pl: add support for moderated lists

Currently get_maintainer.pl reports moderated lists as open, which is just
wrong.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-add-support-for-moderated-lists scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-add-support-for-moderated-lists
+++ a/scripts/get_maintainer.pl
@@ -1027,8 +1027,13 @@ sub add_categories {
 		    if ($email_list) {
 			if (!$hash_list_to{lc($list_address)}) {
 			    $hash_list_to{lc($list_address)} = 1;
-			    push(@list_to, [$list_address,
-					    "open list${list_role}"]);
+			    if ($list_additional =~ m/moderated/) {
+				push(@list_to, [$list_address,
+						"moderated list${list_role}"]);
+			    } else {
+				push(@list_to, [$list_address,
+						"open list${list_role}"]);
+			    }
 			}
 		    }
 		}
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
linux-next.patch
um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch

