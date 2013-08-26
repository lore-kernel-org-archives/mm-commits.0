From: akpm@linux-foundation.org
Subject: + aoe-suppress-compiler-warnings.patch added to -mm tree
Date: Mon, 26 Aug 2013 13:49:51 -0700
Message-ID: <521bbf6f.0dGE4NSKb0mwsqJ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3HZUtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 16:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com, andriy.shevchenko@linux.intel.com

Subject: + aoe-suppress-compiler-warnings.patch added to -mm tree
To: andriy.shevchenko@linux.intel.com,ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 13:49:51 -0700


The patch titled
     Subject: aoe: suppress compiler warnings
has been added to the -mm tree.  Its filename is
     aoe-suppress-compiler-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-suppress-compiler-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-suppress-compiler-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: aoe: suppress compiler warnings

This patch fixes following compiler warnings:

drivers/block/aoe/aoecmd.c: In function `aoecmd_ata_rw':
drivers/block/aoe/aoecmd.c:383:17: warning: variable `t' set but not used [-Wunused-but-set-variable]
  struct aoetgt *t;
                 ^
drivers/block/aoe/aoecmd.c: In function `resend':
drivers/block/aoe/aoecmd.c:488:21: warning: variable `ah' set but not used [-Wunused-but-set-variable]
  struct aoe_atahdr *ah;
                     ^
drivers/block/aoe/aoedev.c: In function 'user_req':
drivers/block/aoe/aoedev.c:252:174: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  lim = min(sizeof(d->gd->disk_name) - (p - d->gd->disk_name), slen);
                                                               ^

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    4 ----
 drivers/block/aoe/aoedev.c |    3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-suppress-compiler-warnings drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-suppress-compiler-warnings
+++ a/drivers/block/aoe/aoecmd.c
@@ -380,7 +380,6 @@ aoecmd_ata_rw(struct aoedev *d)
 {
 	struct frame *f;
 	struct buf *buf;
-	struct aoetgt *t;
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
 	ulong bcnt, fbcnt;
@@ -391,7 +390,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	f = newframe(d);
 	if (f == NULL)
 		return 0;
-	t = *d->tgt;
 	bcnt = d->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
@@ -485,7 +483,6 @@ resend(struct aoedev *d, struct frame *f
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
 	struct aoe_hdr *h;
-	struct aoe_atahdr *ah;
 	struct aoetgt *t;
 	char buf[128];
 	u32 n;
@@ -500,7 +497,6 @@ resend(struct aoedev *d, struct frame *f
 		return;
 	}
 	h = (struct aoe_hdr *) skb_mac_header(skb);
-	ah = (struct aoe_atahdr *) (h+1);
 
 	if (!(f->flags & FFL_PROBE)) {
 		snprintf(buf, sizeof(buf),
diff -puN drivers/block/aoe/aoedev.c~aoe-suppress-compiler-warnings drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-suppress-compiler-warnings
+++ a/drivers/block/aoe/aoedev.c
@@ -249,7 +249,8 @@ user_req(char *s, size_t slen, struct ao
 	if (!d->gd)
 		return 0;
 	p = kbasename(d->gd->disk_name);
-	lim = min(sizeof(d->gd->disk_name) - (p - d->gd->disk_name), slen);
+	lim = min_t(size_t, sizeof(d->gd->disk_name) - (p - d->gd->disk_name),
+		slen);
 
 	return !strncmp(s, p, lim);
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

aoe-remove-custom-implementation-of-kbasename.patch
aoe-use-min-to-simplify-the-code.patch
aoe-suppress-compiler-warnings.patch
linux-next.patch

