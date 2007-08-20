From: akpm@linux-foundation.org
Subject: + i386-optimize-memset-of-6-and-8-bytes.patch added to -mm tree
Date: Mon, 20 Aug 2007 12:51:31 -0700
Message-ID: <200708201951.l7KJpVmM019969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbXHTT5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, ak@suse.de, davem@davemloft.net


The patch titled
     i386: optimize memset of 6 and 8 bytes
has been added to the -mm tree.  Its filename is
     i386-optimize-memset-of-6-and-8-bytes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: optimize memset of 6 and 8 bytes
From: Stephen Hemminger <shemminger@linux-foundation.org>

Tne network code does memset for 6 and 8 byte values, that can easily
be optimized into simple assignments without string instructions.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/string.h |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN include/asm-i386/string.h~i386-optimize-memset-of-6-and-8-bytes include/asm-i386/string.h
--- a/include/asm-i386/string.h~i386-optimize-memset-of-6-and-8-bytes
+++ a/include/asm-i386/string.h
@@ -228,6 +228,14 @@ static __always_inline void * __constant
 		case 4:
 			*(unsigned long *)s = pattern;
 			return s;
+		case 6:
+			*(unsigned long *)s = pattern;
+			*(2+(unsigned short *)s) = pattern;
+			return s;
+		case 8:
+			*(unsigned long *)s = pattern;
+			*(1+(unsigned long *)s) = pattern;
+			return s;
 	}
 #define COMMON(x) \
 __asm__  __volatile__( \
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch
