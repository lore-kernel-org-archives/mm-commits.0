From: akpm@linux-foundation.org
Subject: + fixing-the-warning-in-cgroupc.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:28:35 -0700
Message-ID: <200710240628.l9O6SZdI026422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbXJXG2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:28:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, menage@google.com


The patch titled
     Fix warning in cgroup.c
has been added to the -mm tree.  Its filename is
     fixing-the-warning-in-cgroupc.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Fix warning in cgroup.c
=46rom: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

kernel/cgroup.c: In function =91proc_cgroupstats_show=92:
kernel/cgroup.c:2405: warning: unused variable =91root=92

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/cgroup.c~fixing-the-warning-in-cgroupc kernel/cgroup.c
--- a/kernel/cgroup.c~fixing-the-warning-in-cgroupc
+++ a/kernel/cgroup.c
@@ -2402,7 +2402,6 @@ struct file_operations proc_cgroup_opera
 static int proc_cgroupstats_show(struct seq_file *m, void *v)
 {
 	int i;
-	struct cgroupfs_root *root;
=20
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
 	mutex_lock(&cgroup_mutex);
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.co=
m are

origin.patch
fixing-the-warning-in-cgroupc.patch
