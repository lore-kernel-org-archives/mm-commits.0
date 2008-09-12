From: akpm@linux-foundation.org
Subject: + audit-ignore-terminating-nul-in-audit_user_tty-messages.patch added to -mm tree
Date: Fri, 12 Sep 2008 15:01:04 -0700
Message-ID: <200809122201.m8CM146i006661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbYILWBJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 18:01:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mitr@redhat.com, eparis@redhat.com, sgrubb@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     audit: ignore terminating NUL in AUDIT_USER_TTY messages
has been added to the -mm tree.  Its filename is
     audit-ignore-terminating-nul-in-audit_user_tty-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: ignore terminating NUL in AUDIT_USER_TTY messages
From: Miloslav Trmac <mitr@redhat.com>

AUDIT_USER_TTY, like all other messages sent from user-space, is sent
NUL-terminated.  Unlike other user-space audit messages, which come only
from trusted sources, AUDIT_USER_TTY messages are processed using
audit_log_n_untrustedstring().

This patch modifies AUDIT_USER_TTY handling to ignore the trailing NUL
and use the "quoted_string" representation of the message if possible.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/audit.c~audit-ignore-terminating-nul-in-audit_user_tty-messages kernel/audit.c
--- a/kernel/audit.c~audit-ignore-terminating-nul-in-audit_user_tty-messages
+++ a/kernel/audit.c
@@ -763,6 +763,9 @@ static int audit_receive_msg(struct sk_b
 
 				audit_log_format(ab, " msg=");
 				size = nlmsg_len(nlh);
+				if (size > 0 &&
+				    ((unsigned char *)data)[size - 1] == '\0')
+					size--;
 				audit_log_n_untrustedstring(ab, data, size);
 			}
 			audit_set_pid(ab, pid);
_

Patches currently in -mm which might be from mitr@redhat.com are

audit-ignore-terminating-nul-in-audit_user_tty-messages.patch

