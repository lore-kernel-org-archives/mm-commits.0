From: akpm@linux-foundation.org
Subject: - fix-cpu-hotplug-problem-in-softirq-code.patch removed from -mm tree
Date: Fri, 02 May 2008 12:41:44 -0700
Message-ID: <200805021941.m42Jfirm011106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932267AbYEBTnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, mingo@elte.hu, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Fix cpu hotplug problem in softirq code
has been removed from the -mm tree.  Its filename was
     fix-cpu-hotplug-problem-in-softirq-code.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Fix cpu hotplug problem in softirq code
=46rom: Christian Borntraeger <borntraeger@de.ibm.com>

currently cpu hotplug (unplug) seems broken on s390 and likely others. =
On cpu=20
unplug the system starts to behave very strange and hangs.

I bisected the problem to the following commit:

commit 48f20a9a9488c432fc86df1ff4b7f4fa895d1183
Author: Olof Johansson <olof@lixom.net>
Date: =A0 Tue Mar 4 15:23:25 2008 -0800
=A0 =A0 tasklets: execute tasklets in the same order they were queued

Reverting this patch seems to fix the problem.  I looked into takeover_=
tasklet
and it seems that there is a way to corrupt the tail pointer of the cur=
rent
cpu.  If the tasklet list of the frozen cpu is empty, the tail pointer =
of the
current cpu points to the address of the head pointer of the stopped cp=
u and
not to the next pointer of a tasklet_struct.

This patch avoids the list splice of the list is empty and cpu hotplug =
seems
to work as the tail pointer is not corrupted.  Olof, can you look into =
that
patch and ACK/NACK it so Andrew can push this to Linus, if appropriate?=
=20
Please note that some lines are longer than 80 chars, but line-wrapping=
 looked
worse that this version.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Olof Johansson <olof@lixom.net>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN kernel/softirq.c~fix-cpu-hotplug-problem-in-softirq-code kern=
el/softirq.c
--- a/kernel/softirq.c~fix-cpu-hotplug-problem-in-softirq-code
+++ a/kernel/softirq.c
@@ -589,16 +589,20 @@ static void takeover_tasklets(unsigned i
 	local_irq_disable();
=20
 	/* Find end, append list for that CPU. */
-	*__get_cpu_var(tasklet_vec).tail =3D per_cpu(tasklet_vec, cpu).head;
-	__get_cpu_var(tasklet_vec).tail =3D per_cpu(tasklet_vec, cpu).tail;
-	per_cpu(tasklet_vec, cpu).head =3D NULL;
-	per_cpu(tasklet_vec, cpu).tail =3D &per_cpu(tasklet_vec, cpu).head;
+	if (&per_cpu(tasklet_vec, cpu).head !=3D per_cpu(tasklet_vec, cpu).ta=
il) {
+		*(__get_cpu_var(tasklet_vec).tail) =3D per_cpu(tasklet_vec, cpu).hea=
d;
+		__get_cpu_var(tasklet_vec).tail =3D per_cpu(tasklet_vec, cpu).tail;
+		per_cpu(tasklet_vec, cpu).head =3D NULL;
+		per_cpu(tasklet_vec, cpu).tail =3D &per_cpu(tasklet_vec, cpu).head;
+	}
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
=20
-	*__get_cpu_var(tasklet_hi_vec).tail =3D per_cpu(tasklet_hi_vec, cpu).=
head;
-	__get_cpu_var(tasklet_hi_vec).tail =3D per_cpu(tasklet_hi_vec, cpu).t=
ail;
-	per_cpu(tasklet_hi_vec, cpu).head =3D NULL;
-	per_cpu(tasklet_hi_vec, cpu).tail =3D &per_cpu(tasklet_hi_vec, cpu).h=
ead;
+	if (&per_cpu(tasklet_hi_vec, cpu).head !=3D per_cpu(tasklet_hi_vec, c=
pu).tail) {
+		*__get_cpu_var(tasklet_hi_vec).tail =3D per_cpu(tasklet_hi_vec, cpu)=
=2Ehead;
+		__get_cpu_var(tasklet_hi_vec).tail =3D per_cpu(tasklet_hi_vec, cpu).=
tail;
+		per_cpu(tasklet_hi_vec, cpu).head =3D NULL;
+		per_cpu(tasklet_hi_vec, cpu).tail =3D &per_cpu(tasklet_hi_vec, cpu).=
head;
+	}
 	raise_softirq_irqoff(HI_SOFTIRQ);
=20
 	local_irq_enable();
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

origin.patch
git-kvm.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
