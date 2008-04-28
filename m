From: akpm@linux-foundation.org
Subject: - fs-ext2-use-bug_on.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:22 -0700
Message-ID: <200804282200.m3SM0MT6018688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965583AbYD1WAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     fs/ext2: use BUG_ON
has been removed from the -mm tree.  Its filename was
     fs-ext2-use-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ext2: use BUG_ON
From: Julia Lawall <julia@diku.dk>

if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
side-effects to allow a definition of BUG_ON that drops the code completely.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ disable unlikely @ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (unlikely(E)) { BUG(); }
+ BUG_ON(E);
)

@@ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |    3 +--
 fs/ext2/dir.c    |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/ext2/balloc.c~fs-ext2-use-bug_on fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~fs-ext2-use-bug_on
+++ a/fs/ext2/balloc.c
@@ -245,8 +245,7 @@ restart:
 		prev = rsv;
 	}
 	printk("Window map complete.\n");
-	if (bad)
-		BUG();
+	BUG_ON(bad);
 }
 #define rsv_window_dump(root, verbose) \
 	__rsv_window_dump((root), (verbose), __FUNCTION__)
diff -puN fs/ext2/dir.c~fs-ext2-use-bug_on fs/ext2/dir.c
--- a/fs/ext2/dir.c~fs-ext2-use-bug_on
+++ a/fs/ext2/dir.c
@@ -41,8 +41,8 @@ static inline __le16 ext2_rec_len_to_dis
 {
 	if (len == (1 << 16))
 		return cpu_to_le16(EXT2_MAX_REC_LEN);
-	else if (len > (1 << 16))
-		BUG();
+	else
+		BUG_ON(len > (1 << 16));
 	return cpu_to_le16(len);
 }
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

