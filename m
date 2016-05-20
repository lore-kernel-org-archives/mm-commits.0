From: akpm@linux-foundation.org
Subject: [patch 037/162] mm: use existing helper to convert "on"/"off" to
 boolean
Date: Fri, 20 May 2016 16:58:13 -0700
Message-ID: <573fa495.xyiFENTNcQ95gQRf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbcETX6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mnghuan@gmail.com, mhocko@suse.com

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
