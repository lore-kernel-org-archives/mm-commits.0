From: akpm@linux-foundation.org
Subject: + kernelh-add-pr_warn-for-symmetry-to-dev_warn-netdev_warn.patch added to -mm tree
Date: Thu, 29 Apr 2010 15:04:07 -0700
Message-ID: <201004292204.o3TM47eM014414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757784Ab0D3RIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     kernel.h: add pr_warn for symmetry to dev_warn, netdev_warn
has been added to the -mm tree.  Its filename is
     kernelh-add-pr_warn-for-symmetry-to-dev_warn-netdev_warn.patch

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
Subject: kernel.h: add pr_warn for symmetry to dev_warn, netdev_warn
From: Joe Perches <joe@perches.com>

The current logging macros are
pr_<level>, dev_<level>, netdev_<level>, and netif_<level>.
pr_ uses warning, the other use warn.

Standardize these logging macros a bit more by adding pr_warn and
pr_warn_ratelimited.

Right now, there are:

$ for level in emerg alert crit err warn warning notice info ; do \
    for prefix in pr dev netdev netif ; do \
      echo -n "${prefix}_${level}:	`git grep -w "${prefix}_${level}" | wc -l`	" ; \
    done ; \
    echo ; \
  done
pr_emerg: 	45	dev_emerg: 	4	netdev_emerg: 	1	netif_emerg: 	4
pr_alert: 	24	dev_alert: 	36	netdev_alert: 	1	netif_alert: 	6
pr_crit: 	24	dev_crit: 	22	netdev_crit: 	1	netif_crit: 	4
pr_err:  	2013	dev_err: 	8467	netdev_err: 	267	netif_err: 	240
pr_warn: 	0	dev_warn: 	1818	netdev_warn: 	126	netif_warn: 	23
pr_warning: 	773	dev_warning: 	0	netdev_warning:	0	netif_warning: 	0
pr_notice: 	148	dev_notice: 	111	netdev_notice: 	9	netif_notice: 	3
pr_info: 	1717	dev_info: 	3007	netdev_info: 	101	netif_info: 	85

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/kernel.h~kernelh-add-pr_warn-for-symmetry-to-dev_warn-netdev_warn include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-pr_warn-for-symmetry-to-dev_warn-netdev_warn
+++ a/include/linux/kernel.h
@@ -387,6 +387,7 @@ static inline char *pack_hex_byte(char *
         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
         printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn pr_warning
 #define pr_notice(fmt, ...) \
         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
@@ -445,6 +446,7 @@ static inline char *pack_hex_byte(char *
 	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning_ratelimited(fmt, ...) \
 	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn_ratelimited pr_warning_ratelimited
 #define pr_notice_ratelimited(fmt, ...) \
 	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info_ratelimited(fmt, ...) \
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
kernelh-add-pr_warn-for-symmetry-to-dev_warn-netdev_warn.patch
vsprintfc-use-noinline_for_stack.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch

