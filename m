From: akpm@linux-foundation.org
Subject: - hex_dump-add-missing-const-qualifiers.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:33 -0700
Message-ID: <200708140503.l7E53XPF032067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35361 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765773AbXHNFLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, Artem.Bityutskiy@nokia.com, mm-commits@vger.kernel.org


The patch titled
     hex_dump: add missing "const" qualifiers
has been removed from the -mm tree.  Its filename was
     hex_dump-add-missing-const-qualifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hex_dump: add missing "const" qualifiers
From: Alan Stern <stern@rowland.harvard.edu>

Add missing "const" qualifiers to the print_hex_dump_bytes() library routines.

(akpm: rumoured to fix some compile warning somewhere)

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 lib/hexdump.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~hex_dump-add-missing-const-qualifiers include/linux/kernel.h
--- a/include/linux/kernel.h~hex_dump-add-missing-const-qualifiers
+++ a/include/linux/kernel.h
@@ -226,7 +226,7 @@ extern void print_hex_dump(const char *l
 				int prefix_type, int rowsize, int groupsize,
 				const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			void *buf, size_t len);
+			const void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
 
 #ifdef DEBUG
diff -puN lib/hexdump.c~hex_dump-add-missing-const-qualifiers lib/hexdump.c
--- a/lib/hexdump.c~hex_dump-add-missing-const-qualifiers
+++ a/lib/hexdump.c
@@ -189,7 +189,7 @@ EXPORT_SYMBOL(print_hex_dump);
  * rowsize of 16, groupsize of 1, and ASCII output included.
  */
 void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			void *buf, size_t len)
+			const void *buf, size_t len)
 {
 	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
 			buf, len, 1);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

git-avr32.patch
usb-enable-hcd-support-on-sh-unconditionally.patch
usb-r8a66597-hcd-clean-up-error-path.patch
