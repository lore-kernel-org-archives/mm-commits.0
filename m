From: akpm@linux-foundation.org
Subject: [merged] ocfs2-replace-strnicmp-with-strncasecmp.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:22:14 -0700
Message-ID: <543d69d6.CskLp0LpS7kvCqyS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaJNSWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: ocfs2: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    2 +-
 fs/ocfs2/cluster/masklog.c   |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-replace-strnicmp-with-strncasecmp fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-replace-strnicmp-with-strncasecmp
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2244,7 +2244,7 @@ ssize_t o2hb_heartbeat_group_mode_store(
 		return -EINVAL;
 
 	for (i = 0; i < O2HB_HEARTBEAT_NUM_MODES; ++i) {
-		if (strnicmp(page, o2hb_heartbeat_mode_desc[i], len))
+		if (strncasecmp(page, o2hb_heartbeat_mode_desc[i], len))
 			continue;
 
 		ret = o2hb_global_heartbeat_mode_set(i);
diff -puN fs/ocfs2/cluster/masklog.c~ocfs2-replace-strnicmp-with-strncasecmp fs/ocfs2/cluster/masklog.c
--- a/fs/ocfs2/cluster/masklog.c~ocfs2-replace-strnicmp-with-strncasecmp
+++ a/fs/ocfs2/cluster/masklog.c
@@ -49,13 +49,13 @@ static ssize_t mlog_mask_show(u64 mask,
 
 static ssize_t mlog_mask_store(u64 mask, const char *buf, size_t count)
 {
-	if (!strnicmp(buf, "allow", 5)) {
+	if (!strncasecmp(buf, "allow", 5)) {
 		__mlog_set_u64(mask, mlog_and_bits);
 		__mlog_clear_u64(mask, mlog_not_bits);
-	} else if (!strnicmp(buf, "deny", 4)) {
+	} else if (!strncasecmp(buf, "deny", 4)) {
 		__mlog_set_u64(mask, mlog_not_bits);
 		__mlog_clear_u64(mask, mlog_and_bits);
-	} else if (!strnicmp(buf, "off", 3)) {
+	} else if (!strncasecmp(buf, "off", 3)) {
 		__mlog_clear_u64(mask, mlog_not_bits);
 		__mlog_clear_u64(mask, mlog_and_bits);
 	} else
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

