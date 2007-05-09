From: akpm@linux-foundation.org
Subject: - add-spaces-on-either-side-of-case-operator.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:28 -0700
Message-ID: <200705090249.l492nSe2009225@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967076AbXEICtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: add spaces on either side of case "..." operator.
has been removed from the -mm tree.  Its filename was
     add-spaces-on-either-side-of-case-operator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: audit: add spaces on either side of case "..." operator.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Following the programming advice laid down in the gcc manual, make
sure the case "..." operator has spaces on either side.

According to:

http://gcc.gnu.org/onlinedocs/gcc-4.1.2/gcc/Case-Ranges.html#Case-Ranges:

  "Be careful: Write spaces around the ..., for otherwise it may be
parsed wrong when you use it with integer values."

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/audit.c~add-spaces-on-either-side-of-case-operator kernel/audit.c
--- a/kernel/audit.c~add-spaces-on-either-side-of-case-operator
+++ a/kernel/audit.c
@@ -515,8 +515,8 @@ static int audit_netlink_ok(struct sk_bu
 			err = -EPERM;
 		break;
 	case AUDIT_USER:
-	case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
-	case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
+	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
+	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
 		if (security_netlink_recv(skb, CAP_AUDIT_WRITE))
 			err = -EPERM;
 		break;
@@ -614,8 +614,8 @@ static int audit_receive_msg(struct sk_b
 							loginuid, sid);
 		break;
 	case AUDIT_USER:
-	case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
-	case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
+	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
+	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
 		if (!audit_enabled && msg_type != AUDIT_USER_AVC)
 			return 0;
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
