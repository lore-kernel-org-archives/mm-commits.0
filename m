From: akpm@linux-foundation.org
Subject: [merged] ima-fix-add-lsm-rule-bug.patch removed from -mm tree
Date: Tue, 04 Jan 2011 11:41:24 -0800
Message-ID: <201101041942.p04Jgpma020656__25623.1148181998$1294170215$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508Ab1ADTnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 14:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, safford@watson.ibm.com, serge.hallyn@canonical.com, stable@kernel.org, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ima: fix add LSM rule bug
has been removed from the -mm tree.  Its filename was
     ima-fix-add-lsm-rule-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ima: fix add LSM rule bug
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

If security_filter_rule_init() doesn't return a rule, then not everything
is as fine as the return code implies.

This bug only occurs when the LSM (eg. SELinux) is disabled at runtime.

Adding an empty LSM rule causes ima_match_rules() to always succeed,
ignoring any remaining rules.  

 default IMA TCB policy:
  # PROC_SUPER_MAGIC
  dont_measure fsmagic=0x9fa0
  # SYSFS_MAGIC
  dont_measure fsmagic=0x62656572
  # DEBUGFS_MAGIC
  dont_measure fsmagic=0x64626720
  # TMPFS_MAGIC
  dont_measure fsmagic=0x01021994
  # SECURITYFS_MAGIC
  dont_measure fsmagic=0x73636673

  < LSM specific rule >
  dont_measure obj_type=var_log_t

  measure func=BPRM_CHECK
  measure func=FILE_MMAP mask=MAY_EXEC
  measure func=FILE_CHECK mask=MAY_READ uid=0

Thus without the patch, with the boot parameters 'tcb selinux=0', adding
the above 'dont_measure obj_type=var_log_t' rule to the default IMA TCB
measurement policy, would result in nothing being measured.  The patch
prevents the default TCB policy from being replaced.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: David Safford <safford@watson.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_policy.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN security/integrity/ima/ima_policy.c~ima-fix-add-lsm-rule-bug security/integrity/ima/ima_policy.c
--- a/security/integrity/ima/ima_policy.c~ima-fix-add-lsm-rule-bug
+++ a/security/integrity/ima/ima_policy.c
@@ -253,6 +253,8 @@ static int ima_lsm_rule_init(struct ima_
 	result = security_filter_rule_init(entry->lsm[lsm_rule].type,
 					   Audit_equal, args,
 					   &entry->lsm[lsm_rule].rule);
+	if (!entry->lsm[lsm_rule].rule)
+		return -EINVAL;
 	return result;
 }
 
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

origin.patch
linux-next.patch

