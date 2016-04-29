From: akpm@linux-foundation.org
Subject: + use-existing-helper-to-convert-on-off-to-boolean.patch added to -mm tree
Date: Fri, 29 Apr 2016 14:25:48 -0700
Message-ID: <5723d15c.zGn6HDHfe4yKCXaK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbcD2VZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 17:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnghuan@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use existing helper to convert "on"/"off" to boolean
has been added to the -mm tree.  Its filename is
     use-existing-helper-to-convert-on-off-to-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/use-existing-helper-to-convert-on-off-to-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/use-existing-helper-to-convert-on-off-to-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minfei Huang <mnghuan@gmail.com>
Subject: mm: use existing helper to convert "on"/"off" to boolean

It's more convenient to use existing function helper to convert string
"on/off" to boolean.

Link: http://lkml.kernel.org/r/1461908824-16129-1-git-send-email-mnghuan@gmail.com
Signed-off-by: Minfei Huang <mnghuan@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c  |    9 +--------
 mm/page_poison.c |    8 +-------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff -puN mm/page_alloc.c~use-existing-helper-to-convert-on-off-to-boolean mm/page_alloc.c
--- a/mm/page_alloc.c~use-existing-helper-to-convert-on-off-to-boolean
+++ a/mm/page_alloc.c
@@ -613,14 +613,7 @@ static int __init early_debug_pagealloc(
 {
 	if (!buf)
 		return -EINVAL;
-
-	if (strcmp(buf, "on") == 0)
-		_debug_pagealloc_enabled = true;
-
-	if (strcmp(buf, "off") == 0)
-		_debug_pagealloc_enabled = false;
-
-	return 0;
+	return kstrtobool(buf, &_debug_pagealloc_enabled);
 }
 early_param("debug_pagealloc", early_debug_pagealloc);
 
diff -puN mm/page_poison.c~use-existing-helper-to-convert-on-off-to-boolean mm/page_poison.c
--- a/mm/page_poison.c~use-existing-helper-to-convert-on-off-to-boolean
+++ a/mm/page_poison.c
@@ -13,13 +13,7 @@ static int early_page_poison_param(char
 {
 	if (!buf)
 		return -EINVAL;
-
-	if (strcmp(buf, "on") == 0)
-		want_page_poisoning = true;
-	else if (strcmp(buf, "off") == 0)
-		want_page_poisoning = false;
