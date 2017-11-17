From: akpm@linux-foundation.org
Subject: [patch 72/94] kernel/sysctl.c: code cleanups
Date: Fri, 17 Nov 2017 15:30:26 -0800
Message-ID: <20171117233026.liQ8rJEd0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966147AbdKQXa2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:30:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, mail@okal.no, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: "Ola N. Kaldestad" <mail@okal.no>
Subject: kernel/sysctl.c: code cleanups

Remove unnecessary else block, remove redundant return and call to kfree
in if block.

Link: http://lkml.kernel.org/r/1510238435-1655-1-git-send-email-mail@okal.no
Signed-off-by: Ola N. Kaldestad <mail@okal.no>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN kernel/sysctl.c~fix-code-style-warning kernel/sysctl.c
--- a/kernel/sysctl.c~fix-code-style-warning
+++ a/kernel/sysctl.c
@@ -3127,14 +3127,12 @@ int proc_do_large_bitmap(struct ctl_tabl
 			else
 				bitmap_copy(bitmap, tmp_bitmap, bitmap_len);
 		}
-		kfree(tmp_bitmap);
 		*lenp -= left;
 		*ppos += *lenp;
-		return 0;
-	} else {
-		kfree(tmp_bitmap);
-		return err;
 	}
+
+	kfree(tmp_bitmap);
+	return err;
 }
 
 #else /* CONFIG_PROC_SYSCTL */
_
