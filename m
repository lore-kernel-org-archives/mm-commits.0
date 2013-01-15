From: akpm@linux-foundation.org
Subject: + debugging-keep-track-of-page-owners-fix-2.patch added to -mm tree
Date: Mon, 14 Jan 2013 16:50:58 -0800
Message-ID: <20130115005058.AFE7282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39913 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab3AOAvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 19:51:00 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so570462ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 16:50:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, dave@linux.vnet.ibm.com, mina86@mina86.com, rdunlap@infradead.org


The patch titled
     Subject: Fix wrong EOF compare
has been added to the -mm tree.  Its filename is
     debugging-keep-track-of-page-owners-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: Fix wrong EOF compare

The C standards allows the character type char to be singed or unsinged,
depending on the platform and compiler. Most of systems uses signed char,
but those based on PowerPC and ARM processors typically use unsigned char.
This can lead to unexpected results when the variable is used to compare
with EOF(-1). It happens my ARM system and this patch fixes it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/page_owner.c~debugging-keep-track-of-page-owners-fix-2 Documentation/page_owner.c
--- a/Documentation/page_owner.c~debugging-keep-track-of-page-owners-fix-2
+++ a/Documentation/page_owner.c
@@ -32,12 +32,13 @@ int read_block(char *buf, FILE *fin)
 {
 	int ret = 0;
 	int hit = 0;
+	int val;
 	char *curr = buf;
 
 	for (;;) {
-		*curr = getc(fin);
-		if (*curr == EOF) return -1;
