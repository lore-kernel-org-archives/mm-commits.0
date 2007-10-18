From: akpm@linux-foundation.org
Subject: + ia64-check-segrellds-vs-build-id.patch added to -mm tree
Date: Thu, 18 Oct 2007 13:59:34 -0700
Message-ID: <200710182059.l9IKxYCK030795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906AbXJRU7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 16:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, dchapman@redhat.com, tony.luck@intel.com


The patch titled
     ia64: check-segrel.lds vs --build-id
has been added to the -mm tree.  Its filename is
     ia64-check-segrellds-vs-build-id.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: check-segrel.lds vs --build-id
From: Roland McGrath <roland@redhat.com>

Some versions of ld with --build-id support will crash when using the flag
with a linker script that discards notes.  This bites ia64's
check-segrel.lds.  The bug is easy to avoid.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Doug Chapman <dchapman@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/scripts/check-segrel.lds |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/scripts/check-segrel.lds~ia64-check-segrellds-vs-build-id arch/ia64/scripts/check-segrel.lds
--- a/arch/ia64/scripts/check-segrel.lds~ia64-check-segrellds-vs-build-id
+++ a/arch/ia64/scripts/check-segrel.lds
@@ -1,6 +1,7 @@
 SECTIONS {
 	. = SIZEOF_HEADERS;
 	.rodata : { *(.rodata) } :ro
+	.note : { *(.note*) }
 	. = 0xa0000;
 	.data : { *(.data) } :dat
 	/DISCARD/ : { *(*) }
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
ia64-check-segrellds-vs-build-id.patch
x86_64-use-linux-elfcore-compath.patch
fix-tsk-exit_state-usage-resend.patch
