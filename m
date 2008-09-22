From: akpm@linux-foundation.org
Subject: - audit-ignore-terminating-nul-in-audit_user_tty-messages.patch removed from -mm tree
Date: Mon, 22 Sep 2008 15:45:53 -0700
Message-ID: <200809222245.m8MMjrmw002023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbYIVWqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 18:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitr@redhat.com, eparis@redhat.com, sgrubb@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: ignore terminating NUL in AUDIT_USER_TTY messages
has been removed from the -mm tree.  Its filename was
     audit-ignore-terminating-nul-in-audit_user_tty-messages.patch

This patch was dropped because an updated version will be merged

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

linux-next.patch
audit-ignore-terminating-nul-in-audit_user_tty-messages.patch

