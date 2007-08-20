From: akpm@linux-foundation.org
Subject: - cifs-check-for-granted-memory.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:11:41 -0700
Message-ID: <200708201911.l7KJBfR3018278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753793AbXHTTM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:12:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     CIFS: check for granted memory
has been removed from the -mm tree.  Its filename was
     cifs-check-for-granted-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
