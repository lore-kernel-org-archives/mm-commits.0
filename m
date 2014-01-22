From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:59 -0800
Message-ID: <52e0260f.dY/hF6MKI8rmmBPP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaAVUL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, tariq.x.saeed@oracle.com

Subject: [merged] ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch removed from -mm tree
To: tariq.x.saeed@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:59 -0800


The patch titled
     Subject: ocfs2: punch hole should return EINVAL if the length argument in ioctl is negative
has been removed from the -mm tree.  Its filename was
     ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2: punch hole should return EINVAL if the length argument in ioctl is negative

An unreserve space ioctl OCFS2_IOC_UNRESVSP/64 should reject a negative
length.

Orabug:14789508

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative
+++ a/fs/ocfs2/file.c
@@ -1869,7 +1869,8 @@ static int __ocfs2_change_file_space(str
 	}
 	size = sr->l_start + sr->l_len;
 
-	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) {
+	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64 ||
+	    cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) {
 		if (sr->l_len <= 0) {
 			ret = -EINVAL;
 			goto out_inode_unlock;
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

origin.patch
ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch
ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen.patch

