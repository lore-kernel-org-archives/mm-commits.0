From: akpm@linux-foundation.org
Subject: + fix-code-style-warning.patch added to -mm tree
Date: Mon, 13 Nov 2017 16:24:10 -0800
Message-ID: <5a0a37aa.e+J/K0HxqyhzMcCw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57072 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdKNAYL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2017 19:24:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mail@okal.no, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: code cleanups
has been added to the -mm tree.  Its filename is
     fix-code-style-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-code-style-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-code-style-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3125,14 +3125,12 @@ int proc_do_large_bitmap(struct ctl_tabl
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

Patches currently in -mm which might be from mail@okal.no are

fix-code-style-warning.patch

