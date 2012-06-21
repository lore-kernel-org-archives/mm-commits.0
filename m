From: akpm@linux-foundation.org
Subject: + hfsplus-remove-useless-check.patch added to -mm tree
Date: Thu, 21 Jun 2012 12:42:33 -0700
Message-ID: <20120621194233.C2961A0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55115 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab2FUTme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:42:34 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so99167qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:42:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: remove useless check
has been added to the -mm tree.  Its filename is
     hfsplus-remove-useless-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfsplus: remove useless check

This check is useless because we always have 'sb->s_fs_info' to be non-NULL.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-remove-useless-check fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-remove-useless-check
+++ a/fs/hfsplus/super.c
@@ -240,9 +240,6 @@ static void hfsplus_put_super(struct sup
 
 	dprint(DBG_SUPER, "hfsplus_put_super\n");
 
-	if (!sb->s_fs_info)
-		return;
