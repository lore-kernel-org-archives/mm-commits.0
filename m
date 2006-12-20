From: akpm@osdl.org
Subject: + make-reading-proc-sys-kernel-cap-bould-not-require.patch added to -mm tree
Date: Wed, 20 Dec 2006 15:50:05 -0800
Message-ID: <200612202350.kBKNo5ex010158@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161023AbWLTXuw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 18:50:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov


The patch titled
     make reading /proc/sys/kernel/cap-bould not require CAP_SYS_MODULE
has been added to the -mm tree.  Its filename is
     make-reading-proc-sys-kernel-cap-bould-not-require.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make reading /proc/sys/kernel/cap-bould not require CAP_SYS_MODULE
From: Eric Paris <eparis@redhat.com>

Reading /proc/sys/kernel/cap-bound requires CAP_SYS_MODULE.  (see
proc_dointvec_bset in kernel/sysctl.c)

sysctl appears to drive all over proc reading everything it can get it's
hands on and is complaining when it is being denied access to read
cap-bound.  Clearly writing to cap-bound should be a sensitive operation
but requiring CAP_SYS_MODULE to read cap-bound seems a bit to strong.  I
believe the information could with reasonable certainty be obtained by
looking at a bunch of the output of /proc/pid/status which has very low
security protection, so at best we are just getting a little obfuscation of
information.

Currently SELinux policy has to 'dontaudit' capability checks for
CAP_SYS_MODULE for things like sysctl which just want to read cap-bound. 
In doing so we also as a byproduct have to hide warnings of potential
exploits such as if at some time that sysctl actually tried to load a
module.  I wondered if anyone would have a problem opening cap-bound up to
read from anyone?

Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~make-reading-proc-sys-kernel-cap-bould-not-require kernel/sysctl.c
--- a/kernel/sysctl.c~make-reading-proc-sys-kernel-cap-bould-not-require
+++ a/kernel/sysctl.c
@@ -1961,7 +1961,7 @@ int proc_dointvec_bset(ctl_table *table,
 {
 	int op;
 
-	if (!capable(CAP_SYS_MODULE)) {
+	if (write && !capable(CAP_SYS_MODULE)) {
 		return -EPERM;
 	}
 
_

Patches currently in -mm which might be from eparis@redhat.com are

make-reading-proc-sys-kernel-cap-bould-not-require.patch

