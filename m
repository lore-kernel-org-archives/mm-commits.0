From: akpm@linux-foundation.org
Subject: + document-hadling-of-bad-memory.patch added to -mm tree
Date: Wed, 26 Nov 2008 16:35:53 -0800
Message-ID: <200811270035.mAR0ZrSh003128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYK0AgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 19:36:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, dl9pf@gmx.de, mtk.manpages@gmail.com, randy.dunlap@oracle.com


The patch titled
     Document handling of bad memory
has been added to the -mm tree.  Its filename is
     document-hadling-of-bad-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Document handling of bad memory
=46rom: Pavel Machek <pavel@suse.cz>

Document how to deal with bad memory reported with memtest.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Jan-Simon M=F6ller <dl9pf@gmx.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/bad_memory.txt |   45 +++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff -puN /dev/null Documentation/bad_memory.txt
--- /dev/null
+++ a/Documentation/bad_memory.txt
@@ -0,0 +1,45 @@
+March 2008
+Jan-Simon Moeller, dl9pf@gmx.de
+
+
+How to deal with bad memory e.g. reported by memtest86+ ?
+#########################################################
+
+There are three possibilities I know of:
+
+1) Reinsert/swap the memory modules
+
+2) Buy new modules (best!) or try to exchange the memory
+   if you have spare-parts
+
+3) Use BadRAM or memmap
+
+This Howto is about number 3) .
+
+
+BadRAM
+######
+BadRAM is the actively developed and available as kernel-patch
+here:  http://rick.vanrein.org/linux/badram/
+
+For more details see the BadRAM documentation.
+
+memmap
+######
+
+memmap is already in the kernel and usable as kernel-parameter at
+boot-time.  Its syntax is slightly strange and you may need to
+calculate the values by yourself!
+
+Syntax to exclude a memory area (see kernel-parameters.txt for details=
):
+memmap=3D<size>$<address>
+
+Example: memtest86+ reported here errors at address 0x18691458, 0x1869=
8424 and
+         some others. All had 0x1869xxxx in common, so I chose a patte=
rn of
+         0x18690000,0xffff0000.
+
+With the numbers of the example above:
+memmap=3D64K$0x18690000
+ or
+memmap=3D0x10000$0x18690000
+
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
backlight-catch-invalid-input.patch
backlight-catch-invalid-input-checkpatch-fixes.patch
acpi_evaluate_integer-avoid-using-kmalloc.patch
strict_strto-is-not-strict-enough.patch
lis3lv02d-separate-the-core-from-hp-acpi-api.patch
lis3lv02d-merge-with-leds-hp-disk.patch
document-hadling-of-bad-memory.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
