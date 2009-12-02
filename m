From: akpm@linux-foundation.org
Subject: + bsdacct-fix-uid-gid-misreporting.patch added to -mm tree
Date: Wed, 02 Dec 2009 14:03:34 -0800
Message-ID: <200912022203.nB2M3Y9X025980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbZLBWFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 17:05:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, dhowells@redhat.com, jkj@kapsi.fi, jmorris@namei.org, mschmidt@redhat.com, serue@us.ibm.com, stable@kernel.org


The patch titled
     bsdacct: fix uid/gid misreporting
has been added to the -mm tree.  Its filename is
     bsdacct-fix-uid-gid-misreporting.patch

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
Subject: bsdacct: fix uid/gid misreporting
From: Alexey Dobriyan <adobriyan@gmail.com>

commit d8e180dcd5bbbab9cd3ff2e779efcf70692ef541 "bsdacct: switch
credentials for writing to the accounting file" introduced credential
switching during final acct data collecting.  However, uid/gid pair
continued to be collected from current which became credentials of who
created acct file, not who exits.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14676

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Juho K. Juopperi <jkj@kapsi.fi>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/acct.c~bsdacct-fix-uid-gid-misreporting kernel/acct.c
--- a/kernel/acct.c~bsdacct-fix-uid-gid-misreporting
+++ a/kernel/acct.c
@@ -536,7 +536,8 @@ static void do_acct_process(struct bsd_a
 	do_div(elapsed, AHZ);
 	ac.ac_btime = get_seconds() - elapsed;
 	/* we really need to bite the bullet and change layout */
-	current_uid_gid(&ac.ac_uid, &ac.ac_gid);
+	ac.ac_uid = orig_cred->uid;
+	ac.ac_gid = orig_cred->gid;
 #if ACCT_VERSION==2
 	ac.ac_ahz = AHZ;
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

bsdacct-fix-uid-gid-misreporting.patch
linux-next.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
via-pmu-convert-to-proc_fops-seq_file.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
mpt-fusion-convert-to-seq_file.patch
sysctl_max_map_count-should-be-non-negative.patch
alpha-convert-srm-code-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-convert-to-seq_file-proc_fops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
clps711xfb-convert-to-proc_fops.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
proc-remove-docbook-and-example.patch

