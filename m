From: akpm@linux-foundation.org
Subject: [merged] audit-always-follow-va_copy-with-va_end.patch removed from -mm tree
Date: Mon, 09 Jan 2012 13:31:24 -0800
Message-ID: <20120109213125.8E5531E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:46283 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2AIVb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2012 16:31:27 -0500
Received: by ggnv2 with SMTP id v2so457307ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jan 2012 13:31:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: audit: always follow va_copy() with va_end()
has been removed from the -mm tree.  Its filename was
     audit-always-follow-va_copy-with-va_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jesper Juhl <jj@chaosbits.net>
Subject: audit: always follow va_copy() with va_end()

A call to va_copy() should always be followed by a call to va_end() in the
same function.  In kernel/autit.c::audit_log_vformat() this is not always
done.  This patch makes sure va_end() is always called.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/audit.c~audit-always-follow-va_copy-with-va_end kernel/audit.c
--- a/kernel/audit.c~audit-always-follow-va_copy-with-va_end
+++ a/kernel/audit.c
@@ -1260,12 +1260,13 @@ static void audit_log_vformat(struct aud
 		avail = audit_expand(ab,
 			max_t(unsigned, AUDIT_BUFSIZ, 1+len-avail));
 		if (!avail)
-			goto out;
+			goto out_va_end;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
 	}
-	va_end(args2);
 	if (len > 0)
 		skb_put(skb, len);
+out_va_end:
+	va_end(args2);
 out:
 	return;
 }
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
linux-next.patch
drivers-scsi-aacraid-commctrlc-fix-mem-leak-in-aac_send_raw_srb.patch

