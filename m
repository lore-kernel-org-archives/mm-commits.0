From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-fix-interaction-of-kasprintf-and-vsnprintf-when-using-%pv.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:35 -0700
Message-ID: <201105252029.p4PKTwq8014897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379Ab1EYUa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     lib/vsprintf.c: fix interaction of kasprintf() and vsnprintf() when using %pV
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-fix-interaction-of-kasprintf-and-vsnprintf-when-using-%pv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/vsprintf.c: fix interaction of kasprintf() and vsnprintf() when using %pV
From: "Jan Beulich" <JBeulich@novell.com>

Otherwise, the warning at the top of vsnprintf() gets triggered by
kvasprintf()'s first invocation (with NULL buffer and zero size) of
vsnprintf().

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-fix-interaction-of-kasprintf-and-vsnprintf-when-using-%pv lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-fix-interaction-of-kasprintf-and-vsnprintf-when-using-%pv
+++ a/lib/vsprintf.c
@@ -898,7 +898,7 @@ char *pointer(const char *fmt, char *buf
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
 	case 'V':
-		return buf + vsnprintf(buf, end - buf,
+		return buf + vsnprintf(buf, end > buf ? end - buf : 0,
 				       ((struct va_format *)ptr)->fmt,
 				       *(((struct va_format *)ptr)->va));
 	case 'K':
_

Patches currently in -mm which might be from JBeulich@novell.com are

origin.patch
linux-next.patch

