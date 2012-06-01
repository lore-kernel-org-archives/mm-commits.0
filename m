From: akpm@linux-foundation.org
Subject: [merged] sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:32:59 -0700
Message-ID: <20120601193259.739E5A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41125 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab2FATdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:00 -0400
Received: by vcbfl13 with SMTP id fl13so245417vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:32:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasikanth.v19@gmail.com, amwang@redhat.com, gorcunov@openvz.org, gregkh@linuxfoundation.org, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sethostname/setdomainname: notify userspace when there is a change in uts_kern_table
has been removed from the -mm tree.  Its filename was
     sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasikantha babu <sasikanth.v19@gmail.com>
Subject: sethostname/setdomainname: notify userspace when there is a change in uts_kern_table

sethostname() and setdomainname() notify userspace on failure (without
modifying uts_kern_table).  Change things so that we only notify userspace
on success, when uts_kern_table was actually modified.

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: WANG Cong <amwang@redhat.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table kernel/sys.c
--- a/kernel/sys.c~sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table
+++ a/kernel/sys.c
@@ -1378,8 +1378,8 @@ SYSCALL_DEFINE2(sethostname, char __user
 		memcpy(u->nodename, tmp, len);
 		memset(u->nodename + len, 0, sizeof(u->nodename) - len);
 		errno = 0;
+		uts_proc_notify(UTS_PROC_HOSTNAME);
 	}
-	uts_proc_notify(UTS_PROC_HOSTNAME);
 	up_write(&uts_sem);
 	return errno;
 }
@@ -1429,8 +1429,8 @@ SYSCALL_DEFINE2(setdomainname, char __us
 		memcpy(u->domainname, tmp, len);
 		memset(u->domainname + len, 0, sizeof(u->domainname) - len);
 		errno = 0;
+		uts_proc_notify(UTS_PROC_DOMAINNAME);
 	}
-	uts_proc_notify(UTS_PROC_DOMAINNAME);
 	up_write(&uts_sem);
 	return errno;
 }
_

Patches currently in -mm which might be from sasikanth.v19@gmail.com are

origin.patch

