From: akpm@linux-foundation.org
Subject: + kexec-fix-make-headers_check.patch added to -mm tree
Date: Tue, 13 Jan 2015 16:47:35 -0800
Message-ID: <54b5bca7.QtC+iIL4R9s94EbY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbANArg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:47:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoff@infradead.org, arnd@arndb.de, benh@kernel.crashing.org, hpa@zytor.com, max@stro.at, mmarek@suse.cz, pebolle@tiscali.nl, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: Fix make headers_check
has been added to the -mm tree.  Its filename is
     kexec-fix-make-headers_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-fix-make-headers_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-fix-make-headers_check.patch

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
Subject: kexec: Fix make headers_check

Remove the unneded declaration for a kexec_load() routine.

Fixes errors like these when running 'make headers_check':

include/uapi/linux/kexec.h: userspace cannot reference function or variable defined in the kernel

Paul said:

: The kexec_load declaration isn't very useful for userspace, see the patch
: I submitted in http://lkml.kernel.org/r/1389791824.17407.9.camel@x220 . 
: And After my attempt the export of that declaration has also been
: discussed in
: http://lkml.kernel.org/r/115373b6ac68ee7a305975896e1c4971e8e51d4c.1408731991.git.geoff@infradead.org
: 
: In that last discussion no one has been able to point to an actual user of
: it.  So, as far as I can tell, no one actually uses it.  Which makes
: sense, because including this header by itself doesn't give one access to
: a useful definition of kexec_load.  So why bother with the declaration?

Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Paul Bolle <pebolle@tiscali.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Maximilian Attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/kexec.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/uapi/linux/kexec.h~kexec-fix-make-headers_check include/uapi/linux/kexec.h
--- a/include/uapi/linux/kexec.h~kexec-fix-make-headers_check
+++ a/include/uapi/linux/kexec.h
@@ -55,12 +55,6 @@ struct kexec_segment {
 	size_t memsz;
 };
 
-/* Load a new kernel image as described by the kexec_segment array
- * consisting of passed number of segments at the entry-point address.
- * The flags allow different useage types.
- */
-extern int kexec_load(void *, size_t, struct kexec_segment *,
-		unsigned long int);
 #endif /* __KERNEL__ */
 
 #endif /* _UAPILINUX_KEXEC_H */
_

Patches currently in -mm which might be from geoff@infradead.org are

kexec-fix-make-headers_check.patch
kexec-simplify-conditional.patch
kexec-add-bit-definitions-for-kimage-entry-flags.patch
kexec-add-ind_flags-macro.patch

