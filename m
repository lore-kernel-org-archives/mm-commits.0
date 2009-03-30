From: akpm@linux-foundation.org
Subject: + kexec-vmcoreinfo_data-can-become-static.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:05:00 -0700
Message-ID: <200903302305.n2UN50s7017087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbZC3XGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:06:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitri.vorobiev@movial.com, ebiederm@xmission.com


The patch titled
     kexec: vmcoreinfo_data[] can become static
has been added to the -mm tree.  Its filename is
     kexec-vmcoreinfo_data-can-become-static.patch

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
Subject: kexec: vmcoreinfo_data[] can become static
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>

The vmcoreinfo_data[] array is not used outside of kernel/kexec.c, and
can therefore become static. This patch adds the relevant keyword to the
definition of the array.

Noticed by sparse.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec.c~kexec-vmcoreinfo_data-can-become-static kernel/kexec.c
--- a/kernel/kexec.c~kexec-vmcoreinfo_data-can-become-static
+++ a/kernel/kexec.c
@@ -42,7 +42,7 @@
 note_buf_t* crash_notes;
 
 /* vmcoreinfo stuff */
-unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
+static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
 u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
_

Patches currently in -mm which might be from dmitri.vorobiev@movial.com are

origin.patch
linux-next.patch
kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch
kexec-vmcoreinfo_data-can-become-static.patch

