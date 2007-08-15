From: akpm@linux-foundation.org
Subject: + sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:24:48 -0700
Message-ID: <200708151924.l7FJOmAD011147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756310AbXHOTZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 15:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, ebiederm@xmission.com


The patch titled
     kernel/sysctl_check.c must #include <linux/string.h>
has been added to the -mm tree.  Its filename is
     sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/sysctl_check.c must #include <linux/string.h>
From: Adrian Bunk <bunk@kernel.org>

  CC      kernel/sysctl_check.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/kernel/sysctl_check.c: In function 'sysctl_binary_lookup':
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/kernel/sysctl_check.c:1303: error: implicit declaration of function 'strcmp'
make[2]: *** [kernel/sysctl_check.o] Error 1

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/sysctl_check.c~sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh
+++ a/kernel/sysctl_check.c
@@ -3,6 +3,7 @@
 #include "../arch/s390/appldata/appldata.h"
 #include "../fs/xfs/linux-2.6/xfs_sysctl.h"
 #include <linux/sunrpc/debug.h>
+#include <linux/string.h>
 #include <net/ip_vs.h>
 
 struct trans_ctl_table {
_

Patches currently in -mm which might be from bunk@kernel.org are

sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
