From: akpm@linux-foundation.org
Subject: + aoe-describe-the-behavior-of-the-err-character-device.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:10:31 -0700
Message-ID: <20121017221032.37D87100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:53639 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2JQWKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:10:33 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so907448vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:10:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: describe the behavior of the "err" character device
has been added to the -mm tree.  Its filename is
     aoe-describe-the-behavior-of-the-err-character-device.patch

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
Subject: aoe: describe the behavior of the "err" character device

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoechr.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/block/aoe/aoechr.c~aoe-describe-the-behavior-of-the-err-character-device drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-describe-the-behavior-of-the-err-character-device
+++ a/drivers/block/aoe/aoechr.c
@@ -39,6 +39,11 @@ struct ErrMsg {
 };
 
 static DEFINE_MUTEX(aoechr_mutex);
+
+/* A ring buffer of error messages, to be read through
+ * "/dev/etherd/err".  When no messages are present,
+ * readers will block waiting for messages to appear.
+ */
 static struct ErrMsg emsgs[NMSG];
 static int emsgs_head_idx, emsgs_tail_idx;
 static struct completion emsgs_comp;
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

