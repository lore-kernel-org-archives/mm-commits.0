From: akpm@linux-foundation.org
Subject: + drivers-isdn-correct-use-of-and.patch added to -mm tree
Date: Wed, 27 Feb 2008 23:57:01 -0800
Message-ID: <200802280757.m1S7v1x5022637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbYB1H5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 02:57:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, kkeil@suse.de


The patch titled
     drivers/isdn: correct use of ! and &
has been added to the -mm tree.  Its filename is
     drivers-isdn-correct-use-of-and.patch

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
Subject: drivers/isdn: correct use of ! and &
From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_ttyfax.c   |    3 ++-
 drivers/isdn/isdnloop/isdnloop.c |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/i4l/isdn_ttyfax.c~drivers-isdn-correct-use-of-and drivers/isdn/i4l/isdn_ttyfax.c
--- a/drivers/isdn/i4l/isdn_ttyfax.c~drivers-isdn-correct-use-of-and
+++ a/drivers/isdn/i4l/isdn_ttyfax.c
@@ -906,7 +906,8 @@ isdn_tty_cmd_FCLASS2(char **p, modem_inf
 			sprintf(rs, "\r\n0-2");
 			isdn_tty_at_cout(rs, info);
 		} else {
-			if ((f->phase != ISDN_FAX_PHASE_D) || (!info->faxonline & 1))
+			if ((f->phase != ISDN_FAX_PHASE_D) ||
+			    (!(info->faxonline & 1)))
 				PARSE_ERROR1;
 			par = isdn_getnum(p);
 			if ((par < 0) || (par > 2))
diff -puN drivers/isdn/isdnloop/isdnloop.c~drivers-isdn-correct-use-of-and drivers/isdn/isdnloop/isdnloop.c
--- a/drivers/isdn/isdnloop/isdnloop.c~drivers-isdn-correct-use-of-and
+++ a/drivers/isdn/isdnloop/isdnloop.c
@@ -1289,7 +1289,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 				}
 				break;
 		case ISDN_CMD_CLREAZ:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if (card->leased)
 					break;
@@ -1333,7 +1333,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 				}
 				break;
 		case ISDN_CMD_SETL3:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				return 0;
 		default:
@@ -1380,7 +1380,7 @@ if_writecmd(const u_char __user *buf, in
 	isdnloop_card *card = isdnloop_findcard(id);
 
 	if (card) {
-		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+		if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 			return -ENODEV;
 		return (isdnloop_writecmd(buf, len, 1, card));
 	}
_

Patches currently in -mm which might be from julia@diku.dk are

sound-use-bug_on.patch
git-powerpc.patch
git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
git-ocfs2.patch
fs-ocfs2-use-bug_on.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-sh.patch
usb-use-div_round_up.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
drivers-char-isicomc-correct-use-of-and.patch
drivers-isdn-correct-use-of-and.patch
drivers-media-video-em28xx-correct-use-of-and.patch
drivers-media-video-em28xx-correct-use-of-and-fix.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
drivers-serial-m32r_sioc-correct-use-of-and.patch
fs-reiserfs-superc-correct-use-of-and.patch
