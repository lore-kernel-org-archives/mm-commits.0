From: akpm@linux-foundation.org
Subject: + kernel-profilec-fix-section-mismatch-warning.patch added to -mm tree
Date: Tue, 18 Nov 2008 22:20:08 -0800
Message-ID: <200811190620.mAJ6K8rT010075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbYKSGUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 01:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, mingo@elte.hu


The patch titled
     From: "Rakib Mullick" <rakib.mullick@gmail.com>
has been added to the -mm tree.  Its filename is
     kernel-profilec-fix-section-mismatch-warning.patch

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
Subject: From: "Rakib Mullick" <rakib.mullick@gmail.com>


Impact: Fix section mismatch warning in kernel/profile.c

Here, profile_nop function has been called from a non-init function
create_hash_tables(void). Which generetes a section mismatch warning.
Previously, create_hash_tables(void) was a init function. So, removing
__init from create_hash_tables(void) requires profile_nop to be
non-init. This patch makes profile_nop function inline and fixes the
following warning:

WARNING: vmlinux.o(.text+0x6ebb6): Section mismatch in reference from
the function create_hash_tables() to the function
.init.text:profile_nop()
The function create_hash_tables() references
the function __init profile_nop().
This is often because create_hash_tables lacks a __init
annotation or the annotation of profile_nop is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/profile.c~kernel-profilec-fix-section-mismatch-warning kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-fix-section-mismatch-warning
+++ a/kernel/profile.c
@@ -544,7 +544,7 @@ static const struct file_operations proc
 };
 
 #ifdef CONFIG_SMP
-static void __init profile_nop(void *unused)
+static inline void profile_nop(void *unused)
 {
 }
 
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
kernel-profilec-fix-section-mismatch-warning.patch
kernel-profilec-fix-section-mismatch-warning-fix.patch
init-properly-placing-noinline-keyword.patch

