From: akpm@linux-foundation.org
Subject: + kernel-compliment-va_copy-with-va_end.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:17:56 -0800
Message-ID: <200711270717.lAR7Hu3e000316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979AbXK0HSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, viro@zeniv.linux.org.uk


The patch titled
     audit: complement va_copy with va_end()
has been added to the -mm tree.  Its filename is
     kernel-compliment-va_copy-with-va_end.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: audit: complement va_copy with va_end()
From: Richard Knutsson <ricknu-0@student.ltu.se>

Complement va_copy() with va_end().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/audit.c~kernel-compliment-va_copy-with-va_end kernel/audit.c
--- a/kernel/audit.c~kernel-compliment-va_copy-with-va_end
+++ a/kernel/audit.c
@@ -1245,6 +1245,7 @@ static void audit_log_vformat(struct aud
 			goto out;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
 	}
+	va_end(args2);
 	if (len > 0)
 		skb_put(skb, len);
 out:
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

kernel-compliment-va_copy-with-va_end.patch
net-irda-parametersc-trivial-fixes.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
