From: akpm@linux-foundation.org
Subject: + aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch added to -mm tree
Date: Thu, 18 Oct 2012 14:46:00 -0700
Message-ID: <20121018214601.03DF75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:55055 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab2JRVqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 17:46:04 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so551808lah.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 14:46:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2
has been added to the -mm tree.  Its filename is
     aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2

Dropped transmits are not common, but when they do occur, increasing
the transmit queue length often helps.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoenet.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2 drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2
+++ a/drivers/block/aoe/aoenet.c
@@ -50,13 +50,9 @@ __setup("aoe_iflist=", aoe_iflist_setup)
 static spinlock_t txlock;
 static struct sk_buff_head skbtxq;
 
-/* enters with txlock held
- *
- * Use __must_hold(&txlock) for sparse when upcoming patch adds it to
- * compiler.h.
- */
+/* enters with txlock held */
 static int
-tx(void)
+tx(void) __must_hold(&txlock)
 {
 	struct sk_buff *skb;
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
documentation-sparsetxt-document-context-annotations-for-lock-checking.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

