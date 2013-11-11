From: akpm@linux-foundation.org
Subject: +
 lib-decompress_unlz4c-always-set-an-error-return-code-on-failures.patch
 added to -mm tree
Date: Mon, 11 Nov 2013 13:50:50 -0800
Message-ID: <5281513a.CV63x/jbJqFPc+mE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3KKVuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 16:50:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mattjd@gmail.com, kyungsik.lee@lge.com, jbeulich@suse.com, JBeulich@suse.com

Subject: + lib-decompress_unlz4c-always-set-an-error-return-code-on-failures.patch added to -mm tree
To: JBeulich@suse.com,jbeulich@suse.com,kyungsik.lee@lge.com,mattjd@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 13:50:50 -0800


The patch titled
     Subject: lib/decompress_unlz4.c: always set an error return code on failures
has been added to the -mm tree.  Its filename is
     lib-decompress_unlz4c-always-set-an-error-return-code-on-failures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-decompress_unlz4c-always-set-an-error-return-code-on-failures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-decompress_unlz4c-always-set-an-error-return-code-on-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: lib/decompress_unlz4.c: always set an error return code on failures

"ret", being set to -1 early on, gets cleared by the first invocation of
lz4_decompress()/lz4_decompress_unknownoutputsize(), and hence subsequent
failures wouldn't be noticed by the caller without setting it back to -1
right after those calls.

Reported-by: Matthew Daley <mattjd@gmail.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlz4.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/decompress_unlz4.c~lib-decompress_unlz4c-always-set-an-error-return-code-on-failures lib/decompress_unlz4.c
--- a/lib/decompress_unlz4.c~lib-decompress_unlz4c-always-set-an-error-return-code-on-failures
+++ a/lib/decompress_unlz4.c
@@ -141,6 +141,7 @@ STATIC inline int INIT unlz4(u8 *input,
 			goto exit_2;
 		}
 
+		ret = -1;
 		if (flush && flush(outp, dest_len) != dest_len)
 			goto exit_2;
 		if (output)
_

Patches currently in -mm which might be from JBeulich@suse.com are

lib-decompress_unlz4c-always-set-an-error-return-code-on-failures.patch
linux-next.patch

