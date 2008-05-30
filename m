From: akpm@linux-foundation.org
Subject: - sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch removed from -mm tree
Date: Fri, 30 May 2008 16:27:14 -0700
Message-ID: <200805302327.m4UNRFag016871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbYE3X1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     From: Stephen Hemminger <shemminger@vyatta.com>
has been removed from the -mm tree.  Its filename was
     sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Stephen Hemminger <shemminger@vyatta.com>
From: Stephen Hemminger <shemminger@vyatta.com>
Return-Path: <shemminger@vyatta.com>
X-Spam-Checker-Version: SpamAssassin 3.2.4 (2008-01-01) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=none autolearn=ham
	version=3.2.4
Received: from y.localdomain (y.localdomain [127.0.0.1])
	by y.localdomain (8.14.2/8.14.2) with ESMTP id m4UNOJ5F026226
	for <akpm@localhost>; Fri, 30 May 2008 16:24:19 -0700
Received: from imap1.linux-foundation.org [140.211.169.55]
	by y.localdomain with IMAP (fetchmail-6.3.8)
	for <akpm@localhost> (single-drop); Fri, 30 May 2008 16:24:19 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4UNJhu9016626
	for <akpm@imap1.linux-foundation.org>; Fri, 30 May 2008 16:19:43 -0700
Received: from mail.vyatta.com (mail.vyatta.com [216.93.170.194])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4UNJ8i1029054
	for <akpm@linuxfoundation.org>; Fri, 30 May 2008 16:19:09 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.vyatta.com (Postfix) with ESMTP id 2FEFB4F4235;
	Fri, 30 May 2008 16:19:03 -0700 (PDT)
X-Virus-Scanned: amavisd-new at 
Received: from mail.vyatta.com ([127.0.0.1])
	by localhost (mail.vyatta.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4cdzLsCZqS9y; Fri, 30 May 2008 16:18:58 -0700 (PDT)
Received: from extreme (pool-71-245-98-107.ptldor.fios.verizon.net [71.245.98.107])
	by mail.vyatta.com (Postfix) with ESMTP id 5A2504F4226;
	Fri, 30 May 2008 16:18:58 -0700 (PDT)
Date: Fri, 30 May 2008 16:18:57 -0700
To: akpm@linuxfoundation.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Chris Wright <chrisw@sous-sol.org>
Cc: stephen.hemminger@vyatta.com, adobriyan@gmail.com, morgan@kernel.org,
        xemul@openvz.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] sysctl: allow override of /proc/sys/net with CAP_NET_ADMIN
Message-ID: <20080530161857.25e3fbc5@extreme>
In-Reply-To: <200805292349.m4TNneua029348@imap1.linux-foundation.org>
References: <200805292349.m4TNneua029348@imap1.linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received-SPF: none (domain of shemminger@vyatta.com does not designate permitted sender hosts)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13

Extend the permission check for networking sysctl's to allow
modification when current process has CAP_NET_ADMIN capability and
is not root. This version uses the until now unused permissions hook
to override the mode value for /proc/sys/net if accessed by a user
with capabilities.

Found while working with Quagga. It is impossible to turn forwarding
on/off through the command interface because Quagga uses secure coding
practice of dropping privledges during initialization and only raising
via capabilities when necessary. Since the dameon has reset real/effective
uid after initialization, all attempts to access /proc/sys/net variables
will fail. 

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
Patch against 2.6.26-rc4.
Openvz probably uses this hook for something else but since they aren't
in mainline, too bad for them.

--- a/net/sysctl_net.c	2008-05-30 11:53:05.000000000 -0700
+++ b/net/sysctl_net.c	2008-05-30 12:10:31.000000000 -0700
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
 
 static int sysctl_net_init(struct net *net)

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

