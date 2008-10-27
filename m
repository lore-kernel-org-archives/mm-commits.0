From: akpm@linux-foundation.org
Subject: + kernel-profile-fix-profile_init-section-mismatch.patch added to -mm tree
Date: Sun, 26 Oct 2008 23:08:52 -0700
Message-ID: <200810270608.m9R68quc015329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbYJ0GJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 02:09:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, dave@linux.vnet.ibm.com, sam@ravnborg.org


The patch titled
     kernel/profile: fix profile_init() section mismatch
has been added to the -mm tree.  Its filename is
     kernel-profile-fix-profile_init-section-mismatch.patch

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
Subject: kernel/profile: fix profile_init() section mismatch
From: Paul Mundt <lethal@linux-sh.org>

profile_init() calls in to alloc_bootmem() on early initialization.  While
alloc_bootmem() is __init, the reference itself is safe in that it is
tucked below a !slab_is_available() check.  So, flag profile_init() as
__ref.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/profile.c~kernel-profile-fix-profile_init-section-mismatch kernel/profile.c
--- a/kernel/profile.c~kernel-profile-fix-profile_init-section-mismatch
+++ a/kernel/profile.c
@@ -102,7 +102,7 @@ int profile_setup(char *str)
 __setup("profile=", profile_setup);
 
 
-int profile_init(void)
+int __ref profile_init(void)
 {
 	int buffer_bytes;
 	if (!prof_on)
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
kernel-profile-fix-profile_init-section-mismatch.patch
linux-next.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch

