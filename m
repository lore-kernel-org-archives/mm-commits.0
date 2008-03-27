From: akpm@linux-foundation.org
Subject: + give-futex-init-a-proper-name.patch added to -mm tree
Date: Wed, 26 Mar 2008 21:01:01 -0700
Message-ID: <200803270401.m2R411gV016686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYC0EBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 00:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@ozlabs.org, benh@kernel.crashing.org


The patch titled
     Give futex init a proper name
has been added to the -mm tree.  Its filename is
     give-futex-init-a-proper-name.patch

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
Subject: Give futex init a proper name
From: Benjamin Herrenschmidt <benh@ozlabs.org>

The futex init function is called init(). This is a pain in the neck
when debugging when you code dies in ... init :-)

This renames it to futex_init().

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/futex.c~give-futex-init-a-proper-name kernel/futex.c
--- a/kernel/futex.c~give-futex-init-a-proper-name
+++ a/kernel/futex.c
@@ -2158,7 +2158,7 @@ static struct file_system_type futex_fs_
 	.kill_sb	= kill_anon_super,
 };
 
-static int __init init(void)
+static int __init futex_init(void)
 {
 	u32 curval;
 	int i;
@@ -2194,4 +2194,4 @@ static int __init init(void)
 
 	return 0;
 }
-__initcall(init);
+__initcall(futex_init);
_

Patches currently in -mm which might be from benh@ozlabs.org are

pata_sil680-only-enable-mmio-on-cell-blades.patch
give-futex-init-a-proper-name.patch

