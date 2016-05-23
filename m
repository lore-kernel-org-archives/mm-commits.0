From: akpm@linux-foundation.org
Subject: [merged] use-existing-helper-to-convert-on-off-to-boolean.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:46:30 -0700
Message-ID: <57435e16.VxanELr2BJR9IR1q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbcEWTqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnghuan@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use existing helper to convert "on"/"off" to boolean
has been removed from the -mm tree.  Its filename was
     use-existing-helper-to-convert-on-off-to-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
