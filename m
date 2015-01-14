From: akpm@linux-foundation.org
Subject: + kexec-simplify-conditional.patch added to -mm tree
Date: Tue, 13 Jan 2015 16:47:37 -0800
Message-ID: <54b5bca9.NyezbTD8TC7Yo8yA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbANAri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:47:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoff@infradead.org, arnd@arndb.de, benh@kernel.crashing.org, hpa@zytor.com, max@stro.at, mmarek@suse.cz, pebolle@tiscali.nl, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: simplify conditional
has been added to the -mm tree.  Its filename is
     kexec-simplify-conditional.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-simplify-conditional.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-simplify-conditional.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geoff Levand <geoff@infradead.org>
Subject: kexec: simplify conditional

Simplify the code around one of the conditionals in the kexec_load syscall
routine.

The original code was confusing with a redundant check on KEXEC_ON_CRASH
and comments outside of the conditional block.  This change switches the
order of the conditional check, and cleans up the comments for the
conditional.  There is no functional change to the code.

Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Maximilian Attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN kernel/kexec.c~kexec-simplify-conditional kernel/kexec.c
--- a/kernel/kexec.c~kexec-simplify-conditional
+++ a/kernel/kexec.c
@@ -1284,19 +1284,22 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 	if (nr_segments > 0) {
 		unsigned long i;
 
-		/* Loading another kernel to reboot into */
-		if ((flags & KEXEC_ON_CRASH) == 0)
-			result = kimage_alloc_init(&image, entry, nr_segments,
-						   segments, flags);
-		/* Loading another kernel to switch to if this one crashes */
-		else if (flags & KEXEC_ON_CRASH) {
-			/* Free any current crash dump kernel before
+		if (flags & KEXEC_ON_CRASH) {
+			/*
+			 * Loading another kernel to switch to if this one
+			 * crashes.  Free any current crash dump kernel before
 			 * we corrupt it.
 			 */
+
 			kimage_free(xchg(&kexec_crash_image, NULL));
 			result = kimage_alloc_init(&image, entry, nr_segments,
 						   segments, flags);
 			crash_map_reserved_pages();
+		} else {
+			/* Loading another kernel to reboot into. */
+
+			result = kimage_alloc_init(&image, entry, nr_segments,
+						   segments, flags);
 		}
 		if (result)
 			goto out;
_

Patches currently in -mm which might be from geoff@infradead.org are

kexec-fix-make-headers_check.patch
kexec-simplify-conditional.patch
kexec-add-bit-definitions-for-kimage-entry-flags.patch
kexec-add-ind_flags-macro.patch

