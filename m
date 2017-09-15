From: akpm@linux-foundation.org
Subject: [merged]
 fscache-fix-fscache_objlist_show-format-processing.patch removed from -mm
 tree
Date: Fri, 15 Sep 2017 10:51:22 -0700
Message-ID: <20170915175122.JLf-dOdFF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdIORvX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 13:51:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fscache: fix fscache_objlist_show format processing
has been removed from the -mm tree.  Its filename was
     fscache-fix-fscache_objlist_show-format-processing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fscache: fix fscache_objlist_show format processing

gcc points out a minor bug in the handling of unknown
cookie types, which could result in a string overflow
when the integer is copied into a 3-byte string:

fs/fscache/object-list.c: In function 'fscache_objlist_show':
fs/fscache/object-list.c:265:19: error: 'sprintf' may write a terminating nul past the end of the destination [-Werror=format-overflow=]
 sprintf(_type, "%02u", cookie->def->type);
                ^~~~~~
fs/fscache/object-list.c:265:4: note: 'sprintf' output between 3 and 4 bytes into a destination of size 3

This is currently harmless as no code sets a type other
than 0 or 1, but it makes sense to use snprintf() here
to avoid overflowing the array if that changes.

Link: http://lkml.kernel.org/r/20170714120720.906842-22-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/object-list.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/fscache/object-list.c~fscache-fix-fscache_objlist_show-format-processing fs/fscache/object-list.c
--- a/fs/fscache/object-list.c~fscache-fix-fscache_objlist_show-format-processing
+++ a/fs/fscache/object-list.c
@@ -262,7 +262,8 @@ static int fscache_objlist_show(struct s
 			type = "DT";
 			break;
 		default:
-			sprintf(_type, "%02u", cookie->def->type);
+			snprintf(_type, sizeof(_type), "%02u",
+				 cookie->def->type);
 			type = _type;
 			break;
 		}
_

Patches currently in -mm which might be from arnd@arndb.de are

iopoll-avoid-wint-in-bool-context-warning.patch

