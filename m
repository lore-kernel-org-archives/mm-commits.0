From: akpm@linux-foundation.org
Subject: - ipc-fix-a-kernel-doc-warning.patch removed from -mm tree
Date: Fri, 07 Mar 2008 12:48:39 -0800
Message-ID: <200803072048.m27KmdIr016560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758996AbYCGUtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 15:49:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peifferp@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     ipc: fix a kernel-doc warning
has been removed from the -mm tree.  Its filename was
     ipc-fix-a-kernel-doc-warning.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: fix a kernel-doc warning
From: "Pierre Peiffer" <peifferp@gmail.com>
Return-Path: <peifferp@gmail.com>
X-Spam-Checker-Version: SpamAssassin 3.2.0 (2007-05-01) on y
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=none autolearn=no version=3.2.0
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by y (8.14.1/8.14.1) with ESMTP id m27Keole004321
	for <akpm@localhost>; Fri, 7 Mar 2008 12:40:50 -0800
Received: from imap1.linux-foundation.org [140.211.169.55]
	by localhost.localdomain with POP3 (fetchmail-6.3.8)
	for <akpm@localhost> (single-drop); Fri, 07 Mar 2008 12:40:50 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m27Kaucw016110
	for <akpm@imap1.linux-foundation.org>; Fri, 7 Mar 2008 12:36:56 -0800
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.189])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m27KbFce008765
	for <akpm@linux-foundation.org>; Fri, 7 Mar 2008 12:37:17 -0800
Received: by rn-out-0910.google.com with SMTP id e11so863392rng.17
        for <akpm@linux-foundation.org>; Fri, 07 Mar 2008 12:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        bh=VxD/rrrXvzb1dLrVjBD2wwwxD/E9yjszonUUlYR90bo=;
        b=TQKfTECvC1gTOEY5QeAe6ItXel4PGIv+jVcj9qrLUx7sCMP6jlXMXQ/gckHpVcq3TGvRUn5p310d4x9WcOsK2kGEXbopTM2JY0w45jUuWJkY0NkEyvDdrAZC4M4e7dzLaryI6X2crmAGUTVeBLymc0gqm34ZHiUAXSl/frUuAEs=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Hesg/vHw1GS6pnpU1p1Wq1sD1A9IMp4MBMm8kkqxUbM7jdueEk4WvrCWK8kf5DnlYJBdD/X6A6yZy/Ihk/F6l/q9tnFZxWLENxKlnO9EXpl4LK3wiqt01CTNzbJ9j+sjebNdrVMfCHBOg2BW7LLWfkixXH24EJ05SC1hdd5a8bA=
Received: by 10.140.125.4 with SMTP id x4mr944798rvc.229.1204922208066;
        Fri, 07 Mar 2008 12:36:48 -0800 (PST)
Received: by 10.141.35.15 with HTTP; Fri, 7 Mar 2008 12:36:48 -0800 (PST)
Message-ID: <878847400803071236w47178fa4r79f50d537b383843@mail.gmail.com>
Date: Fri, 7 Mar 2008 21:36:48 +0100
To: akpm@linux-foundation.org, "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: [PATCH 2.6.25-rc3-mm1] IPC: fix a kernel-doc warning
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Received-SPF: pass (domain of peifferp@gmail.com designates 64.233.170.189 as permitted sender)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13

Hi,

This patch fixes this warning produced by kernel-doc (thanks Randy Dunlap):

Warning(linux-2.6.25-rc3-mm1//ipc/util.c:845):
No description found for parameter 'extrat_perm'

It is due to an inconsistency in a variable name between the C-code and
the associated comment.

Signed-off-by: Pierre Peiffer <peifferp@gmail.com>
---
 ipc/util.c |    4 ++--
 ipc/util.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: b/ipc/util.c
===================================================================
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -841,7 +841,7 @@
  *    or an err-code without any lock held otherwise.
  */
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extrat_perm)
+				      struct ipc64_perm *perm, int extra_perm)
 {
 	struct kern_ipc_perm *ipcp;
 	int err;
@@ -858,7 +858,7 @@
 		goto out_unlock;

 	if (cmd == IPC_SET) {
-		err = audit_ipc_set_perm(extrat_perm, perm->uid,
+		err = audit_ipc_set_perm(extra_perm, perm->uid,
 					 perm->gid, perm->mode);
 		if (err)
 			goto out_unlock;
Index: b/ipc/util.h
===================================================================
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -114,7 +114,7 @@
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
 void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extrat_perm);
+				      struct ipc64_perm *perm, int extra_perm);

 #if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) ||
defined(__XTENSA__)
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */

-- 
Pierre

Patches currently in -mm which might be from peifferp@gmail.com are

ipc-fix-a-kernel-doc-warning.patch

