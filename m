From: akpm@linux-foundation.org
Subject: + cifs-check-for-granted-memory.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:50:33 -0700
Message-ID: <200708172150.l7HLoXqT031088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbXHQVvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, sfrench@us.ibm.com


The patch titled
     CIFS: check for granted memory
has been added to the -mm tree.  Its filename is
     cifs-check-for-granted-memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CIFS: check for granted memory
From: Cyrill Gorcunov <gorcunov@gmail.com>

Add a check for granted memory to prevent possible NULL pointer usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/sess.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN fs/cifs/sess.c~cifs-check-for-granted-memory fs/cifs/sess.c
--- a/fs/cifs/sess.c~cifs-check-for-granted-memory
+++ a/fs/cifs/sess.c
@@ -372,6 +372,10 @@ CIFS_SessSetup(unsigned int xid, struct 
 
 	/* 2000 big enough to fit max user, domain, NOS name etc. */
 	str_area = kmalloc(2000, GFP_KERNEL);
+	if (str_area == NULL) {
+		cifs_small_buf_release(smb_buf);
+		return -ENOMEM;
+	}
 	bcc_ptr = str_area;
 
 	ses->flags &= ~CIFS_SES_LANMAN;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

cifs-check-for-granted-memory.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
