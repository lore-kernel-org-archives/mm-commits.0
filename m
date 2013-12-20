From: akpm@linux-foundation.org
Subject: +
 ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch added to -mm tree
Date: Fri, 20 Dec 2013 15:29:34 -0800
Message-ID: <52b4d2de.ykTs8bvF+IIkJUMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3LTX3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Dec 2013 18:29:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, tariq.x.saeed@oracle.com

Subject: + ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch added to -mm tree
To: tariq.x.saeed@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 20 Dec 2013 15:29:34 -0800


The patch titled
     Subject: ocfs2: punch hole should return EINVAL if the length argument in ioctl is negative
has been added to the -mm tree.  Its filename is
     ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2: punch hole should return EINVAL if the length argument in ioctl is negative

Orabug:14789508

An unreserve space ioctl OCFS2_IOC_UNRESVSP/64 should reject a negative
length.

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
@@ -1872,7 +1872,8 @@ static int __ocfs2_change_file_space(str
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

ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch
ocfs2-punch-hole-should-return-einval-if-the-length-argument-in-ioctl-is-negative.patch
ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen-orabug-17330860.patch

