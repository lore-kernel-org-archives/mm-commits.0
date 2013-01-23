From: akpm@linux-foundation.org
Subject: + seq-file-use-seek_-macros-instead-of-hardcoded-numbers.patch added to -mm tree
Date: Wed, 23 Jan 2013 14:06:17 -0800
Message-ID: <20130123220617.900F95A41D6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:55994 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3AWWGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 17:06:18 -0500
Received: by mail-qa0-f73.google.com with SMTP id bv4so13997qab.4
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 14:06:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org


The patch titled
     Subject: seq-file: use SEEK_ macros instead of hardcoded numbers
has been added to the -mm tree.  Its filename is
     seq-file-use-seek_-macros-instead-of-hardcoded-numbers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: seq-file: use SEEK_ macros instead of hardcoded numbers

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/seq_file.c~seq-file-use-seek_-macros-instead-of-hardcoded-numbers fs/seq_file.c
--- a/fs/seq_file.c~seq-file-use-seek_-macros-instead-of-hardcoded-numbers
+++ a/fs/seq_file.c
@@ -308,9 +308,9 @@ loff_t seq_lseek(struct file *file, loff
 	mutex_lock(&m->lock);
 	m->version = file->f_version;
 	switch (whence) {
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
-		case 0:
+		case SEEK_SET:
 			if (offset < 0)
 				break;
 			retval = offset;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
signal-allow-to-send-any-siginfo-to-itself.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
signalfd-add-ability-to-read-siginfo-s-without-dequeuing-signals-v4.patch
seq-file-use-seek_-macros-instead-of-hardcoded-numbers.patch

