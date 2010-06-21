From: akpm@linux-foundation.org
Subject: + drivers-media-dvb-frontends-remove-duplicate-structure-field-initialization.patch added to -mm tree
Date: Mon, 21 Jun 2010 15:58:59 -0700
Message-ID: <201006212258.o5LMwxZ8010148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757857Ab0FUW7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 18:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org


The patch titled
     drivers/media/dvb/frontends: remove duplicate structure field initialization
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-frontends-remove-duplicate-structure-field-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/dvb/frontends: remove duplicate structure field initialization
From: Julia Lawall <julia@diku.dk>

The read_status field is initialized twice to the same value.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier I, s, fld;
position p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@s@
identifier I, s, r.fld;
position r.p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@script:python@
p0 << r.p0;
fld << r.fld;
ps << s.p;
pr << r.p;
@@

if int(ps[0].line)<int(pr[0].line) or int(ps[0].column)<int(pr[0].column):
  cocci.print_main(fld,p0)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/mb86a16.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/media/dvb/frontends/mb86a16.c~drivers-media-dvb-frontends-remove-duplicate-structure-field-initialization drivers/media/dvb/frontends/mb86a16.c
--- a/drivers/media/dvb/frontends/mb86a16.c~drivers-media-dvb-frontends-remove-duplicate-structure-field-initialization
+++ a/drivers/media/dvb/frontends/mb86a16.c
@@ -1833,7 +1833,6 @@ static struct dvb_frontend_ops mb86a16_o
 
 	.get_frontend_algo		= mb86a16_frontend_algo,
 	.search				= mb86a16_search,
-	.read_status			= mb86a16_read_status,
 	.init				= mb86a16_init,
 	.sleep				= mb86a16_sleep,
 	.read_status			= mb86a16_read_status,
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-hid-eliminate-a-double-lock.patch
arch-sh-mm-eliminate-a-double-lock.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-gpu-drm-i915-remove-duplicate-structure-field-initialization.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-media-dvb-frontends-remove-duplicate-structure-field-initialization.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch

