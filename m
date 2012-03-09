From: akpm@linux-foundation.org
Subject: + get_maintainerpl-add-support-for-moderated-lists.patch added to -mm tree
Date: Thu, 08 Mar 2012 16:35:52 -0800
Message-ID: <20120309003552.A6C29A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60511 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab2CIAfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 19:35:53 -0500
Received: by ghbz15 with SMTP id z15so144883ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 16:35:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, joe@perches.com


The patch titled
     Subject: get_maintainer.pl: add support for moderated lists
has been added to the -mm tree.  Its filename is
     get_maintainerpl-add-support-for-moderated-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: get_maintainer.pl: add support for moderated lists

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
get_maintainerpl-add-support-for-moderated-lists.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch

