From: akpm@linux-foundation.org
Subject: + ipath-strncpy-does-not-null-terminate-string.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:46:26 -0700
Message-ID: <200907232046.n6NKkQGm026494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbZGWUqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ralph.campbell@qlogic.com, rolandd@cisco.com


The patch titled
     ipath: strncpy does not null terminate string
has been added to the -mm tree.  Its filename is
     ipath-strncpy-does-not-null-terminate-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipath: strncpy does not null terminate string
From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 drivers/infiniband/hw/ipath/ipath_mad.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~ipath-strncpy-does-not-null-terminate-string drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c~ipath-strncpy-does-not-null-terminate-string
+++ a/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1616,7 +1616,7 @@ static int try_alloc_port(struct ipath_d
 		pd->port_cnt = 1;
 		port_fp(fp) = pd;
 		pd->port_pid = get_pid(task_pid(current));
-		strncpy(pd->port_comm, current->comm, sizeof(pd->port_comm));
+		strlcpy(pd->port_comm, current->comm, sizeof(pd->port_comm));
 		ipath_stats.sps_ports++;
 		ret = 0;
 	} else
diff -puN drivers/infiniband/hw/ipath/ipath_mad.c~ipath-strncpy-does-not-null-terminate-string drivers/infiniband/hw/ipath/ipath_mad.c
--- a/drivers/infiniband/hw/ipath/ipath_mad.c~ipath-strncpy-does-not-null-terminate-string
+++ a/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -60,7 +60,7 @@ static int recv_subn_get_nodedescription
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	strncpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	strlcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
 
 	return reply(smp);
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ipath-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

