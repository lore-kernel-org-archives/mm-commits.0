From: akpm@linux-foundation.org
Subject: + fs-9p-convc-error-path-fix.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:27:44 -0700
Message-ID: <200707200027.l6K0RihF030679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757451AbXGTA15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:27:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, akpm@linux-foundation.org, ericvh@ericvh.myip.org, lucho@ionkov.net


The patch titled
     fs: 9p/conv.c error path fix
has been added to the -mm tree.  Its filename is
     fs-9p-convc-error-path-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: 9p/conv.c error path fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err)) and
it will not be happy about it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Eric Van Hensbergen <ericvh@ericvh.myip.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/conv.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN net/9p/conv.c~fs-9p-convc-error-path-fix net/9p/conv.c
--- a/net/9p/conv.c~fs-9p-convc-error-path-fix
+++ a/net/9p/conv.c
@@ -763,6 +763,7 @@ struct p9_fcall *p9_create_twrite(u32 fi
 	if (err) {
 		kfree(fc);
 		fc = ERR_PTR(err);
+		goto error;
 	}
 
 	if (buf_check_overflow(bufp)) {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
powerpc-tlb_32c-build-fix.patch
mtd-add-module-license-to-mtdbdi.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
fs-9p-convc-error-path-fix.patch
