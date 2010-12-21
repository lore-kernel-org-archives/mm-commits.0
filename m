From: akpm@linux-foundation.org
Subject: + ima-fix-add-lsm-rule-bug.patch added to -mm tree
Date: Tue, 21 Dec 2010 14:39:39 -0800
Message-ID: <201012212239.oBLMddnr030158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664Ab0LUWjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 17:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, safford@watson.ibm.com, serge.hallyn@canonical.com, stable@kernel.org, zohar@us.ibm.com


The patch titled
     ima: fix add LSM rule bug
has been added to the -mm tree.  Its filename is
     ima-fix-add-lsm-rule-bug.patch

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
Subject: ima: fix add LSM rule bug
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

If security_filter_rule_init() doesn't return a rule, then not everything
is as fine as the return code implies.

This bug only occurs when the LSM (eg. SELinux) is disabled at runtime.

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

linux-next.patch
ima-fix-add-lsm-rule-bug.patch

