From: akpm@linux-foundation.org
Subject: + md-dm-log-fix-cn_ulog_callback-declaration.patch added to -mm tree
Date: Mon, 24 Aug 2009 13:59:51 -0700
Message-ID: <200908242059.n7OKxpn8017091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZHXVAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:00:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, agk@redhat.com, davem@davemloft.net, vapier@gentoo.org


The patch titled
     md: dm-log, fix cn_ulog_callback declaration
has been added to the -mm tree.  Its filename is
     md-dm-log-fix-cn_ulog_callback-declaration.patch

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
Subject: md: dm-log, fix cn_ulog_callback declaration
From: Jiri Slaby <jirislaby@gmail.com>

The third parameter of cn_add_callback accepts functions with void
*()(struct cn_msg *) prototype.  Change cn_ulog_callback to match it by
removing void * and adding struct cn_msg * directly.

It's introduced by commit:
connector: make callback argument type explicit

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log-userspace-transfer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/md/dm-log-userspace-transfer.c~md-dm-log-fix-cn_ulog_callback-declaration drivers/md/dm-log-userspace-transfer.c
--- a/drivers/md/dm-log-userspace-transfer.c~md-dm-log-fix-cn_ulog_callback-declaration
+++ a/drivers/md/dm-log-userspace-transfer.c
@@ -129,9 +129,8 @@ static int fill_pkg(struct cn_msg *msg, 
  * This is the connector callback that delivers data
  * that was sent from userspace.
  */
-static void cn_ulog_callback(void *data)
+static void cn_ulog_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg = (struct cn_msg *)data;
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
 	spin_lock(&receiving_list_lock);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

md-dm-log-fix-cn_ulog_callback-declaration.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
usb-make-usb_buffer_map_sg-consistent-with-doc.patch
char-riscom8-fix-shutdown-declaration.patch
kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

