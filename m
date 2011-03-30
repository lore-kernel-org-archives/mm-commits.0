From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-fix-interaction-of-kasprintf-and-vsnprintf-when-using-%pv.patch added to -mm tree
Date: Wed, 30 Mar 2011 16:44:37 -0700
Message-ID: <201103302344.p2UNib3i021444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887Ab1C3XpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 19:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, jbeulich@novell.com


The patch titled
     lib/vsprintf.c: fix interaction of kasprintf() and vsnprintf() when using %pV
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-fix-interaction-of-kasprintf-and-vsnprintf-when-using-%pv.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
lib-vsprintfc-fix-interaction-of-kasprintf-and-vsnprintf-when-using-%pv.patch

