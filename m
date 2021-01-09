Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9ECC433E0
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 01:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BBCE2399C
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 01:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbhAIBvr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jan 2021 20:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbhAIBvp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 Jan 2021 20:51:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 099D22399C;
        Sat,  9 Jan 2021 01:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610157064;
        bh=q+U97/f2ZusGnJOUgz17CUaIQ+Sd3bKeDR5GKs0KjhU=;
        h=Date:From:To:Subject:From;
        b=EDceVnsuKMJmKKtAF6nNEpCtJTWPJqdue1U/u7e+9P4MFz5OSck5T1981QzkNhb91
         GkQzPR00gl3y0T/BZxIulotITDhKCqxU3bnhWo2ciH/p4WCTJyTfNs64sOdCN1+9w4
         x0TJ9l0Gsi5alZAk7BaOFHZ1USN98266Pw/eh4rI=
Date:   Fri, 08 Jan 2021 17:51:03 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, keescook@chromium.org, mcgrof@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        vbabka@suse.cz, yzaikin@google.com
Subject:  +
 proc_sysctl-fix-oops-caused-by-incorrect-command-parameters.patch added to
 -mm tree
Message-ID: <20210109015103.TvS498rH6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc_sysctl: fix oops caused by incorrect command parameters.
has been added to the -mm tree.  Its filename is
     proc_sysctl-fix-oops-caused-by-incorrect-command-parameters.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc_sysctl-fix-oops-caused-by-incorrect-command-parameters.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc_sysctl-fix-oops-caused-by-incorrect-command-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: proc_sysctl: fix oops caused by incorrect command parameters.

The process_sysctl_arg() does not check whether val is empty before
invoking strlen(val).  If the command line parameter () is incorrectly
configured and val is empty, oops is triggered.

For example, "hung_task_panic=1" is incorrectly written as "hung_task_panic".

log:
	Kernel command line: .... hung_task_panic
	....
	[000000000000000n] user address but active_mm is swapper
	Internal error: Oops: 96000005 [#1] SMP
	Modules linked in:
	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.1 #1
	Hardware name: linux,dummy-virt (DT)
	pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=--)
	pc : __pi_strlen+0x10/0x98
	lr : process_sysctl_arg+0x1e4/0x2ac
	sp : ffffffc01104bd40
	x29: ffffffc01104bd40 x28: 0000000000000000
	x27: ffffff80c0a4691e x26: ffffffc0102a7c8c
	x25: 0000000000000000 x24: ffffffc01104be80
	x23: ffffff80c22f0b00 x22: ffffff80c02e28c0
	x21: ffffffc0109f9000 x20: 0000000000000000
	x19: ffffffc0107c08de x18: 0000000000000003
	x17: ffffffc01105d000 x16: 0000000000000054
	x15: ffffffffffffffff x14: 3030253078413830
	x13: 000000000000ffff x12: 0000000000000000
	x11: 0101010101010101 x10: 0000000000000005
	x9 : 0000000000000003 x8 : ffffff80c0980c08
	x7 : 0000000000000000 x6 : 0000000000000002
	x5 : ffffff80c0235000 x4 : ffffff810f7c7ee0
	x3 : 000000000000043a x2 : 00bdcc4ebacf1a54
	x1 : 0000000000000000 x0 : 0000000000000000
	Call trace:
	 __pi_strlen+0x10/0x98
	 parse_args+0x278/0x344
	 do_sysctl_args+0x8c/0xfc
	 kernel_init+0x5c/0xf4
	 ret_from_fork+0x10/0x30
	Code: b200c3eb 927cec01 f2400c07 54000301 (a8c10c22)

Link: https://lkml.kernel.org/r/20210108023339.55917-1-nixiaoming@huawei.com
Fixes: 3db978d480e2843 ("kernel/sysctl: support setting sysctl parameters from kernel command line")
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/proc/proc_sysctl.c~proc_sysctl-fix-oops-caused-by-incorrect-command-parameters
+++ a/fs/proc/proc_sysctl.c
@@ -1757,6 +1757,11 @@ static int process_sysctl_arg(char *para
 	loff_t pos = 0;
 	ssize_t wret;
 
+	if (!val) {
+		pr_err("Missing param value! Expected '%s=...value...'\n", param);
+		return 0;
+	}
+
 	if (strncmp(param, "sysctl", sizeof("sysctl") - 1) == 0) {
 		param += sizeof("sysctl") - 1;
 
_

Patches currently in -mm which might be from nixiaoming@huawei.com are

proc_sysctl-fix-oops-caused-by-incorrect-command-parameters.patch

