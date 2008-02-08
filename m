From: akpm@linux-foundation.org
Subject: - vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:49 -0800
Message-ID: <200802080806.m1886Uqa014457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761958AbYBHIUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     vmcoreinfo: use the existing offsetof() for VMCOREINFO_OFFSET()
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmcoreinfo: use the existing offsetof() for VMCOREINFO_OFFSET()
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

It is better that the existing offsetof() is used for VMCOREINFO_OFFSET().

This discussion is the following:
http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0584.html

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kexec.h~vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset include/linux/kexec.h
--- a/include/linux/kexec.h~vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset
+++ a/include/linux/kexec.h
@@ -137,7 +137,7 @@ unsigned long paddr_vmcoreinfo_note(void
 			      (unsigned long)sizeof(struct name))
 #define VMCOREINFO_OFFSET(name, field) \
 	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
-			      (unsigned long)&(((struct name *)0)->field))
+			      (unsigned long)offsetof(struct name, field))
 #define VMCOREINFO_LENGTH(name, value) \
 	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
 #define VMCOREINFO_NUMBER(name) \
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

origin.patch
