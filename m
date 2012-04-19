From: akpm@linux-foundation.org
Subject: + sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch added to -mm tree
Date: Thu, 19 Apr 2012 13:10:53 -0700
Message-ID: <20120419201054.1E4B1A0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:44806 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2DSUKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 16:10:55 -0400
Received: by vbnl22 with SMTP id l22so1023693vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 13:10:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasikanth.v19@gmail.com, amwang@redhat.com, gorcunov@openvz.org, gregkh@linuxfoundation.org, paul.gortmaker@windriver.com


The patch titled
     Subject: sethostname/setdomainname: notify userspace when there is a change in uts_kern_table
has been added to the -mm tree.  Its filename is
     sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1295,8 +1295,8 @@ SYSCALL_DEFINE2(sethostname, char __user
 		memcpy(u->nodename, tmp, len);
 		memset(u->nodename + len, 0, sizeof(u->nodename) - len);
 		errno = 0;
+		uts_proc_notify(UTS_PROC_HOSTNAME);
 	}
-	uts_proc_notify(UTS_PROC_HOSTNAME);
 	up_write(&uts_sem);
 	return errno;
 }
@@ -1346,8 +1346,8 @@ SYSCALL_DEFINE2(setdomainname, char __us
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
Subject: Subject: sethostname/setdomainname: notify userspace when there is a change in uts_kern_table

Patches currently in -mm which might be from sasikanth.v19@gmail.com are

sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch

