From: akpm@linux-foundation.org
Subject: + fs-ext4-use-bug_on.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:50 -0800
Message-ID: <200802230736.m1N7adPn018458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbYBWHvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     fs/ext4: use BUG_ON
has been added to the -mm tree.  Its filename is
     fs-ext4-use-bug_on.patch

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
Subject: fs/ext4: use BUG_ON
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

 fs/ext4/balloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ext4/balloc.c~fs-ext4-use-bug_on fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~fs-ext4-use-bug_on
+++ a/fs/ext4/balloc.c
@@ -358,8 +358,7 @@ restart:
 		prev = rsv;
 	}
 	printk("Window map complete.\n");
-	if (bad)
-		BUG();
+	BUG_ON(bad);
 }
 #define rsv_window_dump(root, verbose) \
 	__rsv_window_dump((root), (verbose), __FUNCTION__)
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
