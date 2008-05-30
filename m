From: akpm@linux-foundation.org
Subject: + sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch added to -mm tree
Date: Fri, 30 May 2008 16:28:44 -0700
Message-ID: <200805302328.m4UNSi0j016977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488AbYE3X3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, adobriyan@gmail.com, chrisw@sous-sol.org, davem@davemloft.net, ebiederm@xmission.com, morgan@kernel.org, xemul@openvz.org


The patch titled
     sysctl: allow override of /proc/sys/net with CAP_NET_ADMIN
has been added to the -mm tree.  Its filename is
     sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: allow override of /proc/sys/net with CAP_NET_ADMIN
From: Stephen Hemminger <shemminger@vyatta.com>

Extend the permission check for networking sysctl's to allow modification
when current process has CAP_NET_ADMIN capability and is not root.  This
version uses the until now unused permissions hook to override the mode
value for /proc/sys/net if accessed by a user with capabilities.

Found while working with Quagga.  It is impossible to turn forwarding
on/off through the command interface because Quagga uses secure coding
practice of dropping privledges during initialization and only raising via
capabilities when necessary.  Since the dameon has reset real/effective
uid after initialization, all attempts to access /proc/sys/net variables
will fail.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sysctl_net.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN net/sysctl_net.c~sysctl-allow-override-of-proc-sys-net-with-cap_net_admin net/sysctl_net.c
--- a/net/sysctl_net.c~sysctl-allow-override-of-proc-sys-net-with-cap_net_admin
+++ a/net/sysctl_net.c
@@ -36,8 +36,22 @@ net_ctl_header_lookup(struct ctl_table_r
 	return &namespaces->net_ns->sysctl_table_headers;
 }
 
+/* Return standard mode bits for table entry. */
+static int net_ctl_permissions(struct ctl_table_root *root,
+			       struct nsproxy *nsproxy,
+			       struct ctl_table *table)
+{
+	/* Allow network administrator to have same access as root. */
+	if (capable(CAP_NET_ADMIN)) {
+		int mode = (table->mode >> 6) & 7;
+		return (mode << 6) | (mode << 3) | mode;
+	}
+	return table->mode;
+}
+
 static struct ctl_table_root net_sysctl_root = {
 	.lookup = net_ctl_header_lookup,
+	.permissions = net_ctl_permissions,
 };
 
 static LIST_HEAD(net_sysctl_ro_tables);
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

