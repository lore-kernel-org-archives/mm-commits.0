From: akpm@linux-foundation.org
Subject: [merged]
 efivars-use-in_compat_syscall-to-check-for-compat-callers.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:40:53 -0700
Message-ID: <56f2d525.pFDk/kgly8SjWS9e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbcCWRky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, matt@codeblueprint.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/efi/efivars.c: use in_compat_syscall() to check for compat callers
has been removed from the -mm tree.  Its filename was
     efivars-use-in_compat_syscall-to-check-for-compat-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: drivers/firmware/efi/efivars.c: use in_compat_syscall() to check for compat callers

This should make no difference on any architecture, as x86's historical
is_compat_task behavior really did check whether the calling syscall was a
compat syscall.  x86's is_compat_task is going away, though.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/efivars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/efi/efivars.c~efivars-use-in_compat_syscall-to-check-for-compat-callers drivers/firmware/efi/efivars.c
--- a/drivers/firmware/efi/efivars.c~efivars-use-in_compat_syscall-to-check-for-compat-callers
+++ a/drivers/firmware/efi/efivars.c
@@ -231,7 +231,7 @@ sanity_check(struct efi_variable *var, e
 
 static inline bool is_compat(void)
 {
-	if (IS_ENABLED(CONFIG_COMPAT) && is_compat_task())
+	if (IS_ENABLED(CONFIG_COMPAT) && in_compat_syscall())
 		return true;
 
 	return false;
_

Patches currently in -mm which might be from luto@kernel.org are


