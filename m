From: akpm@linux-foundation.org
Subject: [merged] md-fix-strchr-undefined.patch removed from -mm tree
Date: Tue, 15 Sep 2009 14:05:44 -0700
Message-ID: <200909152105.n8FL5iUJ000378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753761AbZIOVHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Sep 2009 17:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, agk@redhat.com, jbrassow@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: fix "strchr" [drivers/md/dm-log-userspace.ko] undefined!
has been removed from the -mm tree.  Its filename was
     md-fix-strchr-undefined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix "strchr" [drivers/md/dm-log-userspace.ko] undefined!
From: Geert Uytterhoeven <geert@linux-m68k.org>

Commit b8313b6da7e2e7c7f47d93d8561969a3ff9ba0ea ("dm log: remove incorrect
field from userspace table output") added a call to strstr() with a
single-character "needle" string parameter.

Unfortunately some versions of gcc replace such calls to strstr() by calls
to strchr() behind our back.  This causes linking errors if strchr() is
defined as an inline function in <asm/string.h> (e.g.  on m68k):

| WARNING: "strchr" [drivers/md/dm-log-userspace.ko] undefined!

Avoid this by explicitly calling strchr() instead.

This fixes a regression introduced in 2.6.31-rc9, and detected by m68k
allmodconfig, cfr. http://kisskb.ellerman.id.au/kisskb/config/164/

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Brassow <jbrassow@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log-userspace-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-log-userspace-base.c~md-fix-strchr-undefined drivers/md/dm-log-userspace-base.c
--- a/drivers/md/dm-log-userspace-base.c~md-fix-strchr-undefined
+++ a/drivers/md/dm-log-userspace-base.c
@@ -582,7 +582,7 @@ static int userspace_status(struct dm_di
 		break;
 	case STATUSTYPE_TABLE:
 		sz = 0;
-		table_args = strstr(lc->usr_argv_str, " ");
+		table_args = strchr(lc->usr_argv_str, ' ');
 		BUG_ON(!table_args); /* There will always be a ' ' */
 		table_args++;
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
m68k-convert-to-use-arch_gettimeoffset.patch
m68k-convert-to-asm-generic-hardirqh.patch
platinumfb-misplaced-parenthesis.patch

