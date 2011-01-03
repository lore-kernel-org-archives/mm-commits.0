From: akpm@linux-foundation.org
Subject: + audit-always-follow-va_copy-with-va_end.patch added to -mm tree
Date: Mon, 03 Jan 2011 13:14:32 -0800
Message-ID: <201101032114.p03LEWxt028850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab1ACVOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 16:14:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     audit: always follow va_copy() with va_end()
has been added to the -mm tree.  Its filename is
     audit-always-follow-va_copy-with-va_end.patch

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
Subject: audit: always follow va_copy() with va_end()
From: Jesper Juhl <jj@chaosbits.net>

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
@@ -1255,12 +1255,13 @@ static void audit_log_vformat(struct aud
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

linux-next.patch
audit-always-follow-va_copy-with-va_end.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes.patch
befs-dont-pass-huge-structs-by-value.patch
reiserfs-make-sure-va_end-is-always-called-after-va_start.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

