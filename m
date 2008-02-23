From: akpm@linux-foundation.org
Subject: + fs-ext2-use-bug_on.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:04 -0800
Message-ID: <200802230735.m1N7Zrml018384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbYBWHwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:52:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     fs/ext2: use BUG_ON
has been added to the -mm tree.  Its filename is
     fs-ext2-use-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sound-use-bug_on.patch
git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
fs-ocfs2-use-bug_on.patch
s390-use-div_round_up.patch
drivers-block-viodasdc-use-field_sizeof.patch
usb-use-div_round_up.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
